resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "cachemoney_apprunner"
  subnets            = module.vpc.private_subnets
  security_groups    = [module.vpc.vpc_security_group_id]
}
