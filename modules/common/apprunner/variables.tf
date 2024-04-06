variable "username" {
  type = string
}

variable "be_repo_name" {
  type = string
}

variable "be_branch_name" {
  type = string
}

variable "port" {
  type    = string
  default = "5000"
}

variable "ecr_url" {
  type = string
}

variable "apprunner_role_arn" {
  type = string
}

variable "apprunner_instance_role_arn" {
  type = string
}

variable "auto_deployments_enabled" {
  type    = bool
  default = true
}

variable "egress_type" {
  type        = string
  description = "Valid values are: DEFAULT and VPC"
  default     = "VPC"
}

variable "vpc_connector_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the App Runner VPC connector that you want to associate with your App Runner service. Only valid when EgressType = VPC"
  default     = null
}

variable "cpu" {
  default = 1024
  type    = number
}

variable "memory" {
  default = 2048
  type    = number
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A map of tags to assign to the resource."
}

variable "account_id" {
  type = string
}

variable "be_env_variables" {
  type = map(string)
}

#variable "domain_name" {
#  type        = string
#  default     = "bibek-mishra.com.np"
#  description = "Domain name for the domain association."
#}
#
#variable "route53_zone_id" {
#  type    = string
#  default = "Z07244273P7WJU51UIRQE"
#}

