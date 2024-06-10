output "public_SB_id1" {
  value = aws_subnet.public_SB_1.id
}

output "public_SB_id2" {
  value = aws_subnet.public_SB_2.id
}

output "frontSG" {
  value = aws_security_group.web.id
}

output "public_SB_cidr1" {
  value = aws_subnet.public_SB_1.cidr_block
}

output "public_SB_cidr2" {
  value = aws_subnet.public_SB_2.cidr_block
}