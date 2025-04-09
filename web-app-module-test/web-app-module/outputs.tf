output "instance1_ip" {
  value = aws_instance.creation_1.public_ip
}

output "instance2_ip" {
  value = aws_instance.creation_2.public_ip
}
