data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "instance_sg" {
  name = "pointbreak_auto_tf_sg"
  description = "Security group for web server instances"
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.instance_sg.id
  from_port         = var.instance_port
  to_port           = var.instance_port
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_common_cidr]
}

resource "aws_security_group_rule" "allow_mysql" {
  type              = "ingress"
  security_group_id = aws_security_group.instance_sg.id
  from_port         = var.mysql_port
  to_port           = var.mysql_port
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_common_cidr]
}

resource "aws_security_group" "alb" {
  name = "pointbreak-tf-alb-sg"
  description = "Security group for Application Load Balancer"
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_common_cidr]
}

resource "aws_security_group_rule" "allow_alb_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_common_cidr]
}


#####################################################

# Allow ALB to access instances
resource "aws_security_group_rule" "alb_to_instances" {
  type                     = "ingress"
  from_port                = var.instance_port
  to_port                  = var.instance_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.instance_sg.id
  source_security_group_id = aws_security_group.alb.id
}


