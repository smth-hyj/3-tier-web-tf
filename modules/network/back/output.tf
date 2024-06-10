output "private_SB_id1" {
  value = aws_subnet.private_SB_1.id
}

output "private_SB_id2" {
  value = aws_subnet.private_SB_2.id
}

output "backSG" {
  value = aws_security_group.app.id
}