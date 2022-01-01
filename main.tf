module "VPC" {
  source = "./modules/vpc"
  vpc_settings = var.vpc
}

module "ECS" {
  source = "./modules/ecs"
  ecs_cluster_settings = var.ecs_cluster
  vpc_settings = var.vpc
  vpc_id = module.VPC.vpc_output.vpc_id
  private_subnet = module.VPC.vpc_output.private_subnet.*.id
  ec2_role = module.iam_roles.iamrole.ec2_servicerole_id
  sg_cluster_id = module.Security_Groups.securitygroup.sg_cluster
  
}
module "ECS_service" {
  source = "./modules/ServiceStatic"
  ecs_cluster_settings = var.ecs_cluster
  vpc_settings = var.vpc
  ecs_service_settings = var.ecs_service
  vpc_id = module.VPC.vpc_output.vpc_id
  private_subnet = module.VPC.vpc_output.private_subnet.*.id
  clusterid = module.ECS.ecs_cluster_settings.cluster_arn
  servicearn = module.iam_roles.iamrole.service_role_arn
  elb_id_ref = module.Load_Balancer.loadbalancer_settings.elb_id
  
}
module "Security_Groups" {
  source = "./modules/securitygroups"
  securitygroup = var.sg
  ecs_cluster_settings = var.ecs_cluster
  vpc_id = module.VPC.vpc_output.vpc_id
}
module "Load_Balancer" {
  source = "./modules/loadbalancers"
  loadbalancer_settings = var.lb
  sg_loadbalancer = module.Security_Groups.securitygroup.sg_elb
  subnet = module.VPC.vpc_output.public_subnet.*.id
}
module "iam_roles" {
  source = "./modules/iamroles"
  iamrole = var.iamroles
  ecs_cluster_settings = var.ecs_cluster
  vpc_settings = var.vpc
  
}