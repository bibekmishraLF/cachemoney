variable "username" {
  type = string
}

variable "cache_money_cli" {
  type = map(string)
}

variable "fe_env_variables" {
  type    = map(string)
  default = {}
}

variable "be_env_variables" {
  type    = map(string)
  default = {}
}

variable "github_connection_arn" {
  type = string
}

variable "ecr_information" {
  type = map(string)
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "account_id" {
  type = string
}

variable "codepipeline_bucket" {
  type = string
}

variable "codepipeline_bucket_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_connector_arn" {
  type    = string
  default = "arn:aws:apprunner:us-east-1:533267031274:vpcconnector/cachemoney_apprunner/1/823ab51378404a129bc853e30d357e6d"
}


