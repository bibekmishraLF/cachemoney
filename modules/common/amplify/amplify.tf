resource "aws_amplify_app" "fe" {
  name         = "${var.username}-${var.fe_branch_name}"
  repository   = "https://github.com/bibekmishraLF/${var.fe_repo_name}"
  access_token = sensitive(var.access_token)

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404-200"
    target = "/index.html"
  }
  tags = merge(var.tags,
    {
      Name = "${var.username}-${var.fe_branch_name}"
  })
  environment_variables = merge(var.fe_env_variables, {
    VITE_BASE_ENV = "https://${var.be_url}"
  })
}

resource "aws_amplify_branch" "fe" {

  app_id      = aws_amplify_app.fe.id
  branch_name = var.fe_branch_name

  framework = var.framework
  stage     = var.stage
  tags = merge(var.tags,
    {
      Name = "${var.username}-${var.fe_branch_name}"
  })
}


