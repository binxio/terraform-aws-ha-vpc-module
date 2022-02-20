locals {
  tags = merge(var.tags,
    {
      "Module" = "binxio/terraform-aws-ha-vpc-module",
    }
  )
}
