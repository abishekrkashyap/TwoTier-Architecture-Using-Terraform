output "Region" {
  value = var.Region
}

output "Project-Name" {
  value = var.projectName
}

output "VPC-Id" {
  value = aws_vpc.VPC.id
}

output "PUBLIC_SUB_1_A_ID" {
  value = aws_subnet.pub-sub-1-a.id
}
output "PUBLIC_SUB_2_B_ID" {
  value = aws_subnet.pub-sub-2-b.id
}
output "PRIVATE_SUB_3_A_ID" {
  value = aws_subnet.pri-sub-3-a.id
}

output "PRIVATE_SUB_4_B_ID" {
  value = aws_subnet.pri-sub-4-b.id
}

output "PRIVATE_SUB_5_A_ID" {
  value = aws_subnet.pri-sub-5-a.id
}

output "PRIVATE_SUB_6_B_ID" {
    value = aws_subnet.pri-sub-6-b.id 
}

output "IGW_ID" {
    value = aws_internet_gateway.internetGateway.id
}