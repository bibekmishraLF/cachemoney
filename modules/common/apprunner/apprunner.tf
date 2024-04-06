resource "aws_apprunner_service" "be" {
  service_name = "${var.username}-${var.be_branch_name}"

  source_configuration {
    image_repository {
      image_configuration {
        port                          = var.port
        runtime_environment_variables = var.be_env_variables
      }
      image_identifier      = "${var.ecr_url}:${var.be_branch_name}"
      image_repository_type = "ECR"
    }
    authentication_configuration {
      access_role_arn = var.apprunner_role_arn
    }
    auto_deployments_enabled = var.auto_deployments_enabled
  }
  network_configuration {
    egress_configuration {
      egress_type       = var.egress_type
      vpc_connector_arn = var.vpc_connector_arn
    }
  }
  instance_configuration {
    instance_role_arn = var.apprunner_instance_role_arn
    cpu               = var.cpu
    memory            = var.memory
  }
  tags = merge(var.tags,
    {
      Name = "${var.username}-${var.be_branch_name}"
  })
}

#resource "aws_apprunner_custom_domain_association" "be" {
#  domain_name = "${var.username}-${var.be_branch_name}-api.${var.domain_name}"
#  service_arn = aws_apprunner_service.be.arn
#  depends_on = [aws_apprunner_service.be]
#}
#
## Extract certificate validation records
#locals {
#  certificate_validation_records = [
#    for record in aws_apprunner_custom_domain_association.be.certificate_validation_records :
#    {
#      name    = record.name
#      type    = record.type
#      value   = record.value
#      records = [record.value]
#      ttl     = 60 # You can adjust the TTL as per your requirements
#    }
#  ]
#}
#
## Add certificate validation records to Route 53 hosted zone
#resource "aws_route53_record" "cert_validation" {
#  for_each = { for idx, record in local.certificate_validation_records : idx => record }
#
#  zone_id = var.route53_zone_id
#  name    = each.value.name
#  type    = each.value.type
#  ttl     = each.value.ttl
#  records = each.value.records
#  depends_on = [aws_apprunner_custom_domain_association.be]
#}
#
#resource "aws_route53_record" "be" {
#  name    = "${var.username}-${var.be_branch_name}-api.${var.domain_name}"
#  type    = "CNAME"
#  zone_id = var.route53_zone_id
#  ttl     = 60
#  records = [aws_apprunner_custom_domain_association.be.dns_target]
#  depends_on = [
#    aws_apprunner_custom_domain_association.be,
#    aws_apprunner_service.be
#  ]
#}

