# Network Resources
#  * VPC
#  * Public & Private Subnets
#  * Internet Gateway
#  * NAT Gateway
#  * Elastic IP
#  * Route Tables & Associations (Public & private)

# VPC
resource "aws_vpc" "roey_pf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "${var.project_name}-vpc" }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.roey_pf_vpc.id

  tags = merge(var.tags, { Name = "${var.project_name}-igw" })
}

# Public subnets
resource "aws_subnet" "public_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.roey_pf_vpc.id
  cidr_block              = var.cidr_blocks_public_subnet[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    "Name"                                      = "${var.project_name}-public-${var.availability_zones[count.index]}"
    "KubernetesCluster"                         = var.cluster_name
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}

# Elastic IP
resource "aws_eip" "nat_eip" {
  count  = length(var.availability_zones)
  domain = "vpc"
  tags   = merge(var.tags, { Name = "${var.project_name}-eip-${count.index}" })
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags          = merge(var.tags, { Name = "${var.project_name}-ngw-${count.index}" })
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.roey_pf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, { Name = "${var.project_name}-public-table" })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.roey_pf_vpc.id
  cidr_block              = var.cidr_blocks_private_subnet[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name                              = "${var.project_name}-private-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

# Private route table
resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.roey_pf_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = merge(var.tags, { Name = "${var.project_name}-private-table-${count.index}" })
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
