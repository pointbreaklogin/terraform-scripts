resource "aws_db_instance" "rds" {
  identifier             = "pointbreak-tf-db-instance"
  engine                 = "mysql"
  engine_version         = "8.0.40"
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = var.storage_type
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = true
  skip_final_snapshot    = true
  multi_az               = false
  apply_immediately      = true
  auto_minor_version_upgrade = true
  deletion_protection    = false
  storage_encrypted      = false
  license_model          = "general-public-license"
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}
