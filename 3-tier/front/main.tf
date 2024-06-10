module "network" {
  source = "../../modules/network/front"
  vpc_id = var.vpc_id
  default_RT = var.default_RT
}

module "elb-asg" {
  source = "../../modules/asg/front"
  webSGid = module.network.frontSG
  webSBids = [module.network.public_SB_id1, module.network.public_SB_id2]
  webSBid1 = module.network.public_SB_id1
  webSBid2 = module.network.public_SB_id2
  vpc_id = var.vpc_id
}