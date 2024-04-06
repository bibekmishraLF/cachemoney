locals {
  tags = {
    Environment = "Isolated Environment for ${split("/", split(":", data.aws_caller_identity.current.arn)[5])[1]}"
    Creator     = split("/", split(":", data.aws_caller_identity.current.arn)[5])[1]
    Project     = "hackathon-2024-lf"
    Deletable   = "false"
  }
  username                = split("/", split(":", data.aws_caller_identity.current.arn)[5])[1]
  account_id              = data.aws_caller_identity.current.account_id
  aws_region              = data.aws_region.current.name
  codepipeline_bucket_arn = "arn:aws:s3:::lf-hackathon-2024-terraform-codepipeline"
  codepipeline_bucket     = "lf-hackathon-2024-terraform-codepipeline"
}