provider "aws" {
  region = "ca-central-1"
}

module "vpc" {
  source                = "git::https://github.com/Shanav-Technologies/terraform-aws-vpc.git?ref=v1.0.0"
  name                  = "app"
  environment           = "test"
  cidr_block            = "10.0.0.0/16"
  additional_cidr_block = ["172.3.0.0/16", "172.2.0.0/16"]
}

module "route53" {
  source                     = "../../"
  name                       = "route53"
  environment                = "test"
  label_order                = ["environment", "name"]
  private_hostedzone_enabled = true
  record_enabled             = true

  domain_name = "Shanav-Technologies.com"
  vpc_id      = module.vpc.id # VPC ID to associate

  records = [
    {
      name    = "www"
      type    = "A"
      ttl     = 3600
      records = ["10.0.0.27"]
    },
    {
      name    = "admin"
      type    = "CNAME"
      ttl     = 3600
      records = ["mydomain.com"]
    },
  ]
}
