module "roles" {
  source = "../../common/roles"

  username                = var.username
  be_branch_name          = var.cache_money_cli.be_branch_name
  github_connection_arn   = var.github_connection_arn
  tags                    = var.tags
  account_id              = var.account_id
  ecr_url                 = var.ecr_information.ecr_url
  ecr_repo_name           = var.ecr_information.ecr_repo_name
  codepipeline_bucket_arn = var.codepipeline_bucket_arn
  aws_region              = var.aws_region

}
module "codepipeline" {
  source = "../../common/codepipeline"

  count                  = contains(["", null], var.cache_money_cli.be_branch_name) ? 0 : 1
  username               = var.username
  be_repo_name           = var.cache_money_cli.be_repo_name
  be_branch_name         = var.cache_money_cli.be_branch_name
  codebuild_role_arn     = module.roles.codebuild_role_arn
  codepipeline_role_arn  = module.roles.codepipeline_role_arn
  codepipeline_bucket    = var.codepipeline_bucket
  codebuild_project_name = module.roles.codebuild_project_name
  github_connection_arn  = var.github_connection_arn
  ecr_url                = var.ecr_information.ecr_url
  ecr_repo_name          = var.ecr_information.ecr_repo_name
  account_id             = var.account_id
  tags                   = var.tags
  depends_on             = [module.roles]
}

module "apprunner" {
  source = "../../common/apprunner"

  count                       = contains(["", null], var.cache_money_cli.be_branch_name) ? 0 : 1
  username                    = var.username
  be_repo_name                = var.cache_money_cli.be_repo_name
  be_branch_name              = var.cache_money_cli.be_branch_name
  ecr_url                     = var.ecr_information.ecr_url
  apprunner_role_arn          = module.roles.apprunner_role_arn
  apprunner_instance_role_arn = module.roles.apprunner_instance_role
  account_id                  = var.account_id
  tags                        = var.tags
  depends_on                  = [module.codepipeline]
  vpc_connector_arn = var.vpc_connector_arn
  be_env_variables            = var.be_env_variables
}

module "amplify" {
  source = "../../common/amplify"

  count            = contains(["", null], var.cache_money_cli.fe_branch_name) ? 0 : 1
  username         = var.username
  fe_repo_name     = var.cache_money_cli.fe_repo_name
  fe_branch_name   = var.cache_money_cli.fe_branch_name
  access_token     = var.cache_money_cli.access_token
  tags             = var.tags
  be_url           = contains(["", null], var.cache_money_cli.be_branch_name) ? var.fe_env_variables.default_api_url : module.apprunner[0].be_url
  aws_region       = var.aws_region
  depends_on       = [module.apprunner]
  fe_env_variables = var.fe_env_variables
}

