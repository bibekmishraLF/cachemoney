resource "aws_iam_role" "codebuild" {
  name               = "${var.username}-${var.be_branch_name}-codebuild"
  path               = "/"
  description        = "Allows CodeDeploy to call AWS services such as Auto Scaling on your behalf."
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = merge(var.tags,
    {
      Name = "${var.username}-${var.be_branch_name}"
  })
}



data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "s3:PutObject",
      "s3:GetObject",
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "logs:CreateLogStream",
      "codebuild:UpdateReport",
      "codebuild:BatchPutCodeCoverages",
      "s3:GetBucketLocation",
      "codebuild:BatchPutTestCases",
      "s3:GetObjectVersion"
    ]

    resources = [
      var.codepipeline_bucket_arn,
      "${var.codepipeline_bucket_arn}/*",
      "arn:aws:codebuild:us-east-1:${var.account_id}:report-group/${var.username}-${var.be_branch_name}*",
      "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/codebuild/${var.username}-${var.be_branch_name}",
      "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/codebuild/${var.username}-${var.be_branch_name}:*"
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = [
      "arn:aws:ecr:us-east-1:${var.account_id}:repository/${var.ecr_repo_name}"
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "codebuild" {
  name        = "${var.username}-${var.be_branch_name}-codebuild"
  description = "IAM policy for cloudwatch logging from fhf_react_component code build"
  policy      = data.aws_iam_policy_document.codebuild.json
  tags = merge(var.tags, {
    Name = "${var.username}-${var.be_branch_name}"
  })
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild.arn
}

# code_build_project
resource "aws_codebuild_project" "codepipeline" {
  name                   = "${var.username}-${var.be_branch_name}"
  description            = "to build react component"
  build_timeout          = 15
  queued_timeout         = 5
  concurrent_build_limit = 1

  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    buildspec       = <<-EOT
        version: 0.2

        phases:
          build:
            commands:
              - aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.us-east-1.amazonaws.com
              - docker build -t ${var.ecr_url}:${var.be_branch_name} .
              - docker push ${var.ecr_url}:${var.be_branch_name}
    EOT
    type            = "CODEPIPELINE"
    git_clone_depth = 0

  }
  tags = merge(var.tags,
    {
      Name = "${var.username}-${var.be_branch_name}"
  })
}

