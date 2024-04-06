resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "/aws/codebuild/${var.username}-${var.be_branch_name}"
  retention_in_days = 14
  tags = merge(var.tags, {
    Name = "/aws/codebuild/${var.username}-${var.be_branch_name}"
  })
}
