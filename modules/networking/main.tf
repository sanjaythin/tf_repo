
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = var.tags
}

resource "aws_subnet" "subnet_public" {
  count             =  length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_vpc,8,count.index)
  map_public_ip_on_launch = "true"
  availability_zone       = element(var.availability_zones, count.index)
  tags = var.tags
}

resource "aws_subnet" "subnet_private" {
  count =  length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_vpc,8,length(var.availability_zones)+count.index)
  map_public_ip_on_launch = "false"
  availability_zone       = element(var.availability_zones, count.index)
  tags = var.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = var.tags
}

resource "aws_route_table" "rtb_public" {
  count             =  length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "rta_subnet_public" {
  count             =  length(var.availability_zones)
  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.rtb_public[count.index].id
}