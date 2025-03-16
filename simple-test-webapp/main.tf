provider "aws" {
  region = "ap-south-1"
}

#Copy the local public key to the instances
resource "aws_key_pair" "pointbreak_auto_tf_key" {
  key_name   = "pointbreak-auto-tf-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Collect default VPC and subnet data
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


#Security group for the instance allow custom port rules
resource "aws_security_group" "pointbreak_auto_tf_sg" {
  name = "pointbreak_auto_tf_sg"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.pointbreak_auto_tf_sg.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

#Security group for ALB inbound and outbound rules
resource "aws_security_group" "alb" {
  name = "pointbreak-tf-alb-sg"
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_alb_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

#Create load balancers for web app
resource "aws_lb" "load_balancer" {
  name               = "pointbreak-tf-web-app-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}

#Create target group for load balancers
resource "aws_lb_target_group" "instances" {
  name     = "pointbreak-tf-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#Loadbalancer listener rules
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

#Listener Rule
resource "aws_lb_listener_rule" "instances_lb_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}

#Creating instance and run python server with custom port number
resource "aws_instance" "creation_1" {
  ami             = "ami-00bb6a80f01f03502"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.pointbreak_auto_tf_key.key_name
  security_groups = [aws_security_group.pointbreak_auto_tf_sg.name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World 1" > index.html
              python3 -m http.server 8080 &
              EOF

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "pointbreak-tr-instance-1"
  }
}

resource "aws_instance" "creation_2" {
  ami             = "ami-00bb6a80f01f03502"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.pointbreak_auto_tf_key.key_name
  security_groups = [aws_security_group.pointbreak_auto_tf_sg.name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World 2" > index.html
              python3 -m http.server 8080 &
              EOF

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "pointbreak-tr-instance-2"
  }
}

#Attaching instance to TG
resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.creation_1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.creation_2.id
  port             = 8080
}

#Creation and connection of route53 with domain
resource "aws_route53_zone" "primary" {
  name = "pointbreak.space"
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "pointbreak.space"
  type    = "A"

  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

#Adding Mysql port to existing SG
resource "aws_security_group_rule" "allow_mysql" {
  type = "ingress"
  security_group_id = aws_security_group.pointbreak_auto_tf_sg.id
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  
}

#Create RDS database
resource "aws_db_instance" "pointbreak_tf_db" {
  identifier = "pointbreak-tf-db-instance"
  engine = "mysql"
  engine_version = "8.0.40"
  instance_class = "db.t4g.micro"
  allocated_storage = 10
  max_allocated_storage = 20
  storage_type = "gp2"
  db_name = "pointbreak_test_tf_db"
  username = "admin"
  password = "Testpass4u4z"
  publicly_accessible = true
  skip_final_snapshot = true
  multi_az = false
  apply_immediately = true
  vpc_security_group_ids = [aws_security_group.pointbreak_auto_tf_sg.id]
  auto_minor_version_upgrade = true

  #free tier compatible parameter
  license_model = "general-public-license"
  deletion_protection = false
  storage_encrypted = false

}