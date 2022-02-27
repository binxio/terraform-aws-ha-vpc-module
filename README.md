# Terraform AWS HA VPC Module

This Terraform module creates a full-fledged highly available AWS VPC.

### Features

- Public subnets in every availability zone
- Private subnets in every availability zone
- NAT gateway in every availability zone
- Internet gateway
- Custom configured route table for public subnets
- Custom configured route tables for every private subnet

### Usage

```terraform
module "aws_ha_vpc" {
  source = "github.com/binxio/terraform-aws-ha-vpc-module"

  cidr_block = "10.0.0.0/20"
  subnet_newbits = 4
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Key = "Value"
  }
}
```

### How subnets are calculated

We create a public and private availability zone in every availability zone of a particular region (the private subnets are created on top of the already calculated public subnet cidr ranges). To calculate the cidr block of a subnet, we use the following formula:

```sh
cidrsubnet(var.cidr_block, var.subnet_newbits, availability_zone_count)
```

Consider a region with 3 availability zones and a VPC with the range `10.0.0.0/20`.

The cidr block ranges of the public subnets are: 
```sh
> cidrsubnet("10.0.0.0/20", 3, 0)
"10.0.0.0/23"
> cidrsubnet("10.0.0.0/20", 3, 1)
"10.0.2.0/23"
> cidrsubnet("10.0.0.0/20", 3, 2)
"10.0.4.0/23"
```

The cidr block ranges of the private subnets are: 
```sh
> cidrsubnet("10.0.0.0/20", 3, 3)
"10.0.6.0/23"
> cidrsubnet("10.0.0.0/20", 3, 4)
"10.0.8.0/23"
> cidrsubnet("10.0.0.0/20", 3, 5)
"10.0.10.0/23"
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.ngws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private_crt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_crt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.crt_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | Classless Inter-Domain Routing (CIDR) block | `string` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support | `bool` | `true` | no |
| <a name="input_subnet_newbits"></a> [subnet\_newbits](#input\_subnet\_newbits) | Subnet mask bits | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to all resources | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | Outputs the unique VPC identifier |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
