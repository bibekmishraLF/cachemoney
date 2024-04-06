resource "aws_iam_role" "apprunner" {
  name               = "${var.username}-${var.be_branch_name}-apprunner"
  path               = "/"
  description        = "Allows Apprunner to call AWS services such as Auto Scaling on your behalf."
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "build.apprunner.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = merge(var.tags,
    {
      Name = "${var.username}-${var.be_branch_name}-apprunner"
  })
}

data "aws_iam_policy_document" "apprunner" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:BatchCheckLayerAvailability"
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

resource "aws_iam_policy" "apprunner" {
  name        = "${var.username}-${var.be_branch_name}-apprunner"
  description = "IAM policy for cloudwatch logging from fhf_react_component code build"
  policy      = data.aws_iam_policy_document.apprunner.json
  tags = merge(var.tags, {
    Name = "${var.username}-${var.be_branch_name}-apprunner"
  })
}

resource "aws_iam_role_policy_attachment" "apprunner" {
  role       = aws_iam_role.apprunner.name
  policy_arn = aws_iam_policy.apprunner.arn
}


#####
# role for instance of appruner
resource "aws_iam_role" "apprunner_instance" {
  name               = "${var.username}-${var.be_branch_name}-instance"
  path               = "/"
  description        = "Allows Apprunner instance to call AWS services such as Auto Scaling on your behalf."
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "tasks.apprunner.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = merge(var.tags,
    {
      Name = "${var.username}-${var.be_branch_name}-instance"
  })
}

data "aws_iam_policy_document" "apprunner_instance" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:BatchCheckLayerAvailability"
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

resource "aws_iam_policy" "apprunner_instance" {
  name        = "${var.username}-${var.be_branch_name}-ar-instance"
  description = "IAM policy for cloudwatch logging from fhf_react_component code build"
  policy      = data.aws_iam_policy_document.apprunner_instance.json
  tags = merge(var.tags, {
    Name = "${var.username}-${var.be_branch_name}-apprunner"
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_instance" {
  role       = aws_iam_role.apprunner_instance.name
  policy_arn = aws_iam_policy.apprunner_instance.arn
}
