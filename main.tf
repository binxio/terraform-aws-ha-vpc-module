# VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = merge(local.tags,
    {
      "Name" = "vpc-${data.aws_region.current.name}"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, var.subnet_newbits, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name  = "public-subnet-${substr(data.aws_availability_zones.available.names[count.index], -2, -1)}"
    Owner = "Terraform"
  }
}

# Private subnets
resource "aws_subnet" "private_subnet" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, var.subnet_newbits, length(aws_subnet.public_subnet.*.id) + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.tags,
    {
      "Name" = "private-subnet-${substr(data.aws_availability_zones.available.names[count.index], -2, -1)}"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags,
    {
      "Name" = "inet-gw-${data.aws_region.current.name}"
    }
  )
}

# NAT Gateway 
resource "aws_nat_gateway" "ngw" {
  count = length(aws_subnet.public_subnet.*.id)

  allocation_id = aws_eip.ngws.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]

  # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [
    aws_internet_gateway.igw,
    aws_eip.ngws,
  ]

  tags = merge(local.tags,
    {
      "Name" = "nat-gw-${substr(data.aws_availability_zones.available.names[count.index], -2, -1)}"
    }
  )
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "ngws" {
  count = length(aws_subnet.public_subnet.*.id)

  vpc = true

  tags = merge(local.tags,
    {
      "Name" = "vpc-nat-eip"
    }
  )
}

# Route table covering public subnets
resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags,
    {
      "Name" = "public-crt-${data.aws_region.current.name}"
    }
  )
}

# Route table covering private subnets
resource "aws_route_table" "private_crt" {
  count = length(aws_subnet.private_subnet.*.id)

  vpc_id = aws_vpc.main.id


  tags = merge(local.tags,
    {
      "Name" = "private-crt-${substr(data.aws_availability_zones.available.names[count.index], -2, -1)}"
    }
  )
}

# Explicit association of public subnets to the public route table
resource "aws_route_table_association" "public_subnets" {
  count = length(aws_subnet.public_subnet.*.id)

  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_crt.id
}

# Explicit association of private subnets to the private route tables
resource "aws_route_table_association" "private_subnets" {
  count = length(aws_subnet.private_subnet.*.id)

  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_crt.*.id[count.index]
}

# Route to Internet Gateway in public route table
resource "aws_route_table_association" "crt_igw" {
  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.public_crt.id
}

# Route to NAT Gateway in private route tables
resource "aws_route" "ngw" {
  count = length(aws_route_table.private_crt.*.id)

  route_table_id         = aws_route_table.private_crt.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.*.id[count.index]
}
