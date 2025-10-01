resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.local_key_path)
}

resource "aws_instance" "creation_1" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.key.key_name
  security_groups = [aws_security_group.instance_sg.name]
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World 1" > index.html
    python3 -m http.server ${var.instance_port} &
  EOF

  root_block_device {
    volume_size = var.instance_storage
  }

  tags = {
    Name = "pointbreak-tr-instance-1"
  }
}

resource "aws_instance" "creation_2" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.key.key_name
  security_groups = [aws_security_group.instance_sg.name]
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World 2" > index.html
    python3 -m http.server ${var.instance_port} &
  EOF

  root_block_device {
    volume_size = var.instance_storage
  }

  tags = {
    Name = "pointbreak-tr-instance-2"
  }
}



resource "aws_lb_target_group_attachment" "instance1" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.creation_1.id
  port             = var.instance_port
}

resource "aws_lb_target_group_attachment" "instance2" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.creation_2.id
  port             = var.instance_port
}
