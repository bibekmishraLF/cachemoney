resource "null_resource" "trigger_amplify_build" {
  triggers = {
    app_id = aws_amplify_app.fe.id
    branch = aws_amplify_branch.fe.id
    be_url = var.be_url
  }

  provisioner "local-exec" {
    command = "aws amplify start-job --app-id ${aws_amplify_app.fe.id} --branch-name ${var.fe_branch_name} --job-type RELEASE --region ${var.aws_region} && sleep 50 "
  }
  depends_on = [
    aws_amplify_app.fe,
    aws_amplify_branch.fe
  ]
}

#resource "null_resource" "wait_for_amplify_build" {
#  depends_on = [
#    null_resource.trigger_amplify_build,
#  ]
#
#  provisioner "local-exec" {
#    command = "aws amplify wait app-deployed --app-id ${aws_amplify_app.fe.id} --deployment-status-polling-enabled --region ${var.aws_region}"
#  }
#}

#resource "aws_amplify_domain_association" "fe" {
#  app_id = aws_amplify_app.fe.id
#
#  domain_name           = var.domain_name
#  wait_for_verification = true
#
#  sub_domain {
#    branch_name = aws_amplify_branch.fe.branch_name
#    prefix      = "${var.username}-${var.fe_branch_name}"
#  }
#  depends_on = [
#    null_resource.trigger_amplify_build
#  ]
#}