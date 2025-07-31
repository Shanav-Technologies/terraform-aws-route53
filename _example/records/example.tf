provider "aws" {
  region = "ca-central-1"
}

# Step 1: Create Hosted Zone
resource "aws_route53_zone" "main" {
  name = "shanav-technologies.com"
}

# Step 2: Pass zone_id via local
locals {
  zone_id = aws_route53_zone.main.zone_id
}

# Step 3: Use records module
module "records" {
  source                    = "../../"
  name                      = "route53"
  environment               = "test"
  label_order               = ["environment", "name"]
  public_hostedzone_enabled = false
  record_enabled            = true

  zone_id     = local.zone_id
  domain_name = "shanav-technologies.com"

  records = [
    {
      name = "test"
      type = "A"
      ttl  = 3600
      records = [
        "10.10.10.10",
      ]
    },
    {
      name           = "geo"
      type           = "CNAME"
      ttl            = 5
      records        = ["shanav-technologies.com"]
      set_identifier = "europe"
      geolocation_routing_policy = {
        continent = "EU"
      }
    },
    {
      name = "alias"
      type = "A"
      alias = {
        name    = "example-lb-1234567890.us-east-1.elb.amazonaws.com" # Dummy
        zone_id = "Z35SXDOTRQ7X7K"                                    # Dummy ELB zone ID (you can replace it)
      }
    },
    {
      name           = "weighted-policy"
      type           = "A"
      set_identifier = "test"
      alias = {
        name    = "example-lb-1234567890.us-east-1.elb.amazonaws.com" # Dummy
        zone_id = "Z35SXDOTRQ7X7K"                                    # Dummy ELB zone ID
      }
      weighted_routing_policy = {
        weight = 50
      }
    }
  ]
}
