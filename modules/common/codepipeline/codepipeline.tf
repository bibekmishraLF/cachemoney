resource "aws_codepipeline" "codepipeline" {
  name           = "${var.username}-${var.be_branch_name}"
  pipeline_type  = "V2"
  execution_mode = "SUPERSEDED"
  role_arn       = var.codepipeline_role_arn

  artifact_store {
    location = var.codepipeline_bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      configuration = {
        "BranchName"           = var.be_branch_name
        "ConnectionArn"        = var.github_connection_arn
        "DetectChanges"        = "true"
        "FullRepositoryId"     = "bibekmishraLF/${var.be_repo_name}"
        "OutputArtifactFormat" = "CODE_ZIP"
      }
      input_artifacts = []
      category        = "Source"
      name            = "Source"
      namespace       = "SourceVariables"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeStarSourceConnection"
      region    = "us-east-1"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"
    action {
      configuration = {
        "BatchEnabled" = "false"
        "ProjectName"  = var.codebuild_project_name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name             = "Build"
      namespace        = "BuildVariables"
      region           = "us-east-1"
      run_order        = 1
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      output_artifacts = ["BuildArtifact", ]
    }
  }

  tags = merge(var.tags,
    {
      Name = "${var.username}-${var.be_branch_name}"
  })

}

resource "null_resource" "wait_for_pipeline_build" {

  triggers = {
    codepipeline = aws_codepipeline.codepipeline.id
  }

  provisioner "local-exec" {
    command = "sleep 5"
  }
  depends_on = [
    aws_codepipeline.codepipeline
  ]
}
