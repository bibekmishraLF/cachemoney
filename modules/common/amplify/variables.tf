variable "username" {
  type = string
}

variable "fe_repo_name" {
  type = string
}

variable "fe_branch_name" {
  type = string
}

variable "access_token" {
  type = string
}

variable "framework" {
  type    = string
  default = "React"
}

variable "stage" {
  type        = string
  default     = "PRODUCTION"
  description = "Valid values: PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL, PULL_REQUEST"
}

variable "domain_name" {
  type        = string
  default     = "bibek-mishra.com.np"
  description = "Domain name for the domain association."
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A map of tags to assign to the resource."
}

variable "be_url" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "fe_env_variables" {
  type = map(string)
}
