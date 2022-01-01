data "aws_availability_zones" "az" {
  state = "available"
}

locals {
  sum_of_azs = length(data.aws_availability_zones.az.names)
}
resource "aws_vpc" "VPC" {
  cidr_block = var.vpc_settings.vpc_cidr 
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags = {
    Name = "${terraform.workspace}-VPC"
  }
}

resource "aws_subnet" "PublicSubnet" {
  count = length(var.vpc_settings.public_subnet_cidr)
  availability_zone = data.aws_availability_zones.az.names[count.index%(local.sum_of_azs)]
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.vpc_settings.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${terraform.workspace}-PublicSubnet${count.index+1}"
  }
  
}
resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.VPC.id 
}

resource "aws_route_table_association" "PublicSubnetRouteTableAssociation" {
  count = length(var.vpc_settings.public_subnet_cidr)
  subnet_id      = aws_subnet.PublicSubnet[count.index].id
  route_table_id = aws_route_table.PublicRouteTable.id
}


resource "aws_subnet" "PrivateSubnet" {
  count = length(var.vpc_settings.private_subnet_cidr)
  availability_zone = data.aws_availability_zones.az.names[count.index%(local.sum_of_azs)]
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.vpc_settings.private_subnet_cidr[count.index]
  tags = {
    Name = "${terraform.workspace}-PrivateSubnet${count.index+1}"
  }
}

resource "aws_internet_gateway" "MyIG" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${terraform.workspace}-InternetGateway"
  }
}

resource "aws_route" "PublicRoute" {
  gateway_id                = aws_internet_gateway.MyIG.id
  route_table_id            = aws_route_table.PublicRouteTable.id
  destination_cidr_block    = "0.0.0.0/0"
  depends_on                = [aws_internet_gateway.MyIG]
}

resource "aws_eip" "ElasticIPAddress" {
  count = length(var.vpc_settings.private_subnet_cidr) >= 1 ? 1 : 0
  vpc = true
  depends_on = [aws_internet_gateway.MyIG]
  tags = {
    Name = "${terraform.workspace}-EIP"
  }
}

resource "aws_nat_gateway" "NATGateway" {
  count = length(var.vpc_settings.private_subnet_cidr) >= 1 ? 1 : 0

  allocation_id = aws_eip.ElasticIPAddress[count.index].id
  subnet_id     = aws_subnet.PublicSubnet[0].id
  tags = {
    Name = "${terraform.workspace}-NATGateway"
  }
}

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "${terraform.workspace}-PrivateRT"
  }
}


resource "aws_route" "PrivateRoute" {
  count = length(var.vpc_settings.private_subnet_cidr) >= 1 ? 1 : 0
  gateway_id                = aws_nat_gateway.NATGateway[count.index].id
  route_table_id            = aws_route_table.PrivateRouteTable.id
  destination_cidr_block    = "0.0.0.0/0"
  depends_on                = [aws_nat_gateway.NATGateway]
}


resource "aws_route_table_association" "PrivateSubnetRouteTableAssociation" {
  count = length(var.vpc_settings.private_subnet_cidr)
  subnet_id      = aws_subnet.PrivateSubnet[count.index].id
  route_table_id = aws_route_table.PrivateRouteTable.id
}