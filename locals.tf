locals {
  quad_zero_route = "0.0.0.0/0"
  tags = merge(var.tags,
    {
      "Module" = "binxio/terraform-aws-ha-vpc-module",
    }
  )
}
