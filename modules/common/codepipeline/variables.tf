variable "username" {
  type = string
}

variable "be_branch_name" {
  type = string
}

variable "be_repo_name" {
  type = string
}

variable "codebuild_role_arn" {
  type = string
}

variable "codepipeline_role_arn" {
  type = string
}

variable "codepipeline_bucket" {
  type = string
}

variable "codebuild_project_name" {
  type = string
}

variable "github_connection_arn" {
  type = string
}

variable "ecr_url" {
  type = string
}

variable "ecr_repo_name" {
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


