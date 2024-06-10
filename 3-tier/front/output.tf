output "Public_cidr_blocks" {
  value = [module.network.public_SB_cidr1, module.network.public_SB_cidr2]
}

output "public_SB_id1" {
  value = module.network.public_SB_id1
}

output "public_SB_id2" {
  value = module.network.public_SB_id2
}

output "frontSG" {
  value = module.network.frontSG
}