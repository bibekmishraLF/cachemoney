module "rds" {
  source     = "../../common/rds"
  identifier = join("", ["cachemoney", "testing"])

  engine            = "mysql"
  engine_version    = "8.0.32"
  instance_class    = "db.t3.micro"
  allocated_storage = 10
  storage_encrypted = false
  name              = "todo"
  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username               = local.mysql.username
  password               = local.mysql.password
  port                   = "3306"
  vpc_security_group_ids = [module.vpc.vpc_security_group_id]
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"
  # disable backups to create DB faster
  backup_retention_period         = 0
  tags                            = var.tags
  enabled_cloudwatch_logs_exports = []
  subnet_ids                      = module.vpc.private_subnets
  family                          = "mysql8.0"
  # DB option group
  major_engine_version = "8.0"
  skip_final_snapshot  = true
  # Database Deletion Protection
  deletion_protection        = false
  auto_minor_version_upgrade = false
  apply_immediately          = true

}
