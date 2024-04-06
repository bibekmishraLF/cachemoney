module "vpc" {
  source = "../../common/vpc"

  cidr_block = "172.23.0.0/16"
  namespace  = "cachemoney"
  stage      = "testing"
  tags       = var.tags
}