output "ALB-SG-ID" {
  value = aws_security_group.albSG.id
}

output "Client-SG-ID" {
  value = aws_security_group.clientSG.id
}

output "Database-SG-ID" {
  value = aws_security_group.databaseSG.id
}

output "Jump-SG-ID" {
  value = aws_security_group.jumpSG.id
}