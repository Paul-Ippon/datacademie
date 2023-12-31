data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.network_prefix}-vpc"
  })
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(var.tags, {
    Name = format("${var.network_prefix}-public-%02d", count.index + 1)
  })
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(var.tags, {
    Name = format("${var.network_prefix}-private-%02d", count.index + 1)
  })
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name = "${var.network_prefix}-ig"
  })
}

resource "aws_eip" "elastic_ips" {
  count = length(var.public_subnet_cidrs)
  vpc   = true

  tags = merge(var.tags, {
    Name = format("${var.network_prefix}-eip-%02d", count.index + 1)
  })

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateways" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.elastic_ips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = merge(var.tags, {
    Name = format("${var.network_prefix}-ngw-%02d", count.index + 1)
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(var.tags, {
    Name = "${var.network_prefix}-public"
  })
}

resource "aws_route_table_association" "public_route_table_associations" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_tables" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateways[count.index].id
  }

  tags = merge(var.tags, {
    Name = format("${var.network_prefix}-private-%02d", count.index + 1)
  })
}

resource "aws_route_table_association" "private_route_table_associations" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}