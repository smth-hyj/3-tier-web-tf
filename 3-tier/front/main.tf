module "network" {
  source = "../../modules/network/front"
}

module "elb-asg" {
  source = "../../modules/asg/front"
  webSGid = module.network.frontSG
  webSBids = module.network.public_SB_ids
}