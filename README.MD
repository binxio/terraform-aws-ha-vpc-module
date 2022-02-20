# Terraform AWS HA VPC Module

## Description

This Terraform module creates a full-fledged highly available AWS VPC.

### Usage

```
module "aws_ha_vpc" "vpc" {
  source = "binxio/terraform-aws-ha-vpc-module"

  cidr = "10.0.0.0/20"
  subnet_newbits = 4
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Key = "Value"
  }
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->