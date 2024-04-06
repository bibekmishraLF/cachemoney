variable "cache_money_cli" {
  type = map(string)
}

variable "aws_envs" {
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
  type    = string
  default = "arn:aws:codestar-connections:us-east-1:533267031274:connection/91bf17a8-7596-47d5-9fdd-95cf2524e40a"
}

variable "ecr_information" {
  type = map(string)
  default = {
    ecr_url       = "533267031274.dkr.ecr.us-east-1.amazonaws.com/hackathon"
    ecr_repo_name = "hackathon"
  }
}

variable "mysql" {
  type    = map(string)
  default = {}
}
