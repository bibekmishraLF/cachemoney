module "cachemoney" {
  source                  = "./modules/stage/cachemoney"
  username                = local.username
  cache_money_cli         = var.cache_money_cli
  fe_env_variables        = var.fe_env_variables
  be_env_variables        = var.be_env_variables
  github_connection_arn   = var.github_connection_arn
  ecr_information         = var.ecr_information
  tags                    = local.tags
  account_id              = local.account_id
  codepipeline_bucket     = local.codepipeline_bucket
  codepipeline_bucket_arn = local.codepipeline_bucket_arn
  aws_region              = local.aws_region
}

#module "setup" {
#  source = "./modules/stage/setup"
#
#  count = local.username == "bibekmishra" ? 1 : 0
#  tags  = local.tags
#}
