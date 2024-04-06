output "be_url" {
  value = contains(["", null], var.cache_money_cli.be_branch_name) ? null : module.apprunner[0].be_url
}

output "fe_url" {
  value = contains(["", null], var.cache_money_cli.fe_branch_name) ? null : module.amplify[0].fe_url
}

