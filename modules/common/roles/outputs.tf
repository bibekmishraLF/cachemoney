output "codebuild_role_arn" {
  value = aws_iam_role.codebuild.arn
}

output "codebuild_project_name" {
  value = aws_codebuild_project.codepipeline.name
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "apprunner_role_arn" {
  value = aws_iam_role.apprunner.arn
}

output "apprunner_instance_role" {
  value = aws_iam_role.apprunner_instance.arn
}
