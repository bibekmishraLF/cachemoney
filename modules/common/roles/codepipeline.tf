
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.username}-${var.be_branch_name}-codepipeline"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(var.tags,
    {
      Name = "${var.username}-${var.be_branch_name}-codepipeline"
  })
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]
    resources = ["*"]
    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"
      values = [
        "cloudformation.amazonaws.com",
        "elasticbeanstalk.amazonaws.com",
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:List*"
    ]

    resources = [
      var.codepipeline_bucket_arn,
      "${var.codepipeline_bucket_arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codestar-connections:UseConnection",
    ]
    resources = [var.github_connection_arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch"
    ]

    resources = [aws_codebuild_project.codepipeline.arn]
  }
  statement {
    effect = "Allow"

    actions = [
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "codepipeline" {
  name        = "${var.username}-${var.be_branch_name}-codepipeline"
  description = "Codepipeline policy"
  policy      = data.aws_iam_policy_document.codepipeline_policy.json
  tags = merge(var.tags, {
    Name = "${var.username}-${var.be_branch_name}-codepipeline"
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline.arn
}

resource "null_resource" "wait_for_role_build_complete" {
  triggers = {
    codepipeline_role            = aws_iam_role.codepipeline_role.id,
    codepipeline_policy          = aws_iam_policy.codepipeline.id
    codepipeline_role_attachment = aws_iam_role_policy_attachment.codepipeline.id
  }

  provisioner "local-exec" {
    command = "sleep 5"
  }
  depends_on = [
    aws_iam_role_policy_attachment.codebuild,
    aws_iam_role_policy_attachment.codepipeline
  ]
}
