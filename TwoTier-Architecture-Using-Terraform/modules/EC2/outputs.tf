output "jumpServer_Id" {
  value = aws_instance.jumpServer.public_ip
}