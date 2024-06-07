output "public_SB_ids" {
  value = aws_subnet.public_SB[*].id
}

output "frontSG" {
  value = aws_security_group.web.id
}