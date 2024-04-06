data "aws_secretsmanager_secret_version" "secret" {
  secret_id = "terraform/variables"
}

locals {
  mysql = {
    username = sensitive(jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["username"])
    password = sensitive(jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["password"])
    database = sensitive(jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["database"])
  }
}