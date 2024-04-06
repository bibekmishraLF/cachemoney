variable "username" {
  type = string
}

variable "be_branch_name" {
  type = string
}

variable "github_connection_arn" {
  type = string
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A map of tags to assign to the resource."
}

variable "account_id" {
  type = string
}

variable "ecr_url" {
  type = string
}

variable "ecr_repo_name" {
  type = string
}

variable "codepipeline_bucket_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

