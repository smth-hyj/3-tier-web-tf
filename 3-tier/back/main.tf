module "network" {
  source = "../../modules/network/back"
  vpc_id = var.vpc_id
  public_cidrs = var.public_cidrs
}

module "asg" {
  source = "../../modules/asg/back"
  appSBids = [module.network.private_SB_id1, module.network.private_SB_id2]
  appSGid = module.network.backSG
  vpc_id = var.vpc_id
  webSGid = var.webSGid
  webSBids = var.webSBids
}