locals {
  azs       = slice(data.aws_availability_zones.available.names, 0, 2)
  db_subnet = var.create_db_subnet ? length(local.azs) : 0
}


####################### VPC ############################
resource "aws_vpc" "webapp_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = "webapp-vpc"
  }
}

####################### Subnets ############################	
# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.webapp_vpc.id
  count             = length(local.azs)
  cidr_block        = cidrsubnet(aws_vpc.webapp_vpc.cidr_block, 8, count.index + 1)
  availability_zone = element(local.azs, count.index)
  tags = {
    Name = "webapp Public subnet ${count.index + 1}"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.webapp_vpc.id
  count             = length(local.azs)
  cidr_block        = cidrsubnet(aws_vpc.webapp_vpc.cidr_block, 8, count.index + 3)
  availability_zone = element(local.azs, count.index)
  tags = {
    Name = "webapp Private subnet ${count.index + 1}"
  }
}

# DB Subnet
resource "aws_subnet" "db_subnet" {
  vpc_id            = aws_vpc.webapp_vpc.id
  count             = local.db_subnet
  cidr_block        = cidrsubnet(aws_vpc.webapp_vpc.cidr_block, 8, count.index + 5)
  availability_zone = element(local.azs, count.index)
  tags = {
    Name = "webapp DB subnet ${count.index + 1}"
  }
}

####################### Internet Gateway ############################
resource "aws_internet_gateway" "webapp_igw" {
  vpc_id = aws_vpc.webapp_vpc.id
  tags = {
    Name = "webapp-igw"
  }
}


####################### Route Table and Association - Public ############################
resource "aws_route_table" "webapp_pub_rt" {
  vpc_id = aws_vpc.webapp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webapp_igw.id
  }
  tags = {
    Name = "Public subnet Route Table"
  }
}


# Route table association with public subnet
resource "aws_route_table_association" "pub_rt_association" {
  route_table_id = aws_route_table.webapp_pub_rt.id
  count          = length(local.azs)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
}


####################### Route Table and Association - Private ############################	
# Route table for private subnet
resource "aws_route_table" "webapp_private_rt" {
  count      = length(local.azs)
  depends_on = [aws_nat_gateway.webapp-nat-gateway]
  vpc_id     = aws_vpc.webapp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.webapp-nat-gateway[*].id, count.index)
  }
  tags = {
    Name = "Private subnet Route Table ${count.index + 1}"
  }
}


# Route table association with private subnet
resource "aws_route_table_association" "private_rt_association" {
  count          = length(local.azs)
  route_table_id = element(aws_route_table.webapp_private_rt[*].id, count.index)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
}

####################### Route Table and Association - DB ############################
# Route table for DB subnet
resource "aws_route_table" "webapp_db_rt" {
  count  = local.db_subnet
  vpc_id = aws_vpc.webapp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.webapp-nat-gateway[*].id, count.index)
  }
  tags = {
    Name = "DB subnet Route Table ${count.index + 1}"
  }
}

# Route table association with DB subnet
resource "aws_route_table_association" "db_rt_association" {
  count          = local.db_subnet
  route_table_id = element(aws_route_table.webapp_db_rt[*].id, count.index)
  subnet_id      = element(aws_subnet.db_subnet[*].id, count.index)
}


######################## Elastic IP and NAT Gateway ############################
# Elastic IP for NAT Gateway
resource "aws_eip" "web_nat_eip" {
  count      = length(local.azs)
  domain     = "vpc"
  depends_on = [aws_internet_gateway.webapp_igw]
}

# NAT Gateway
resource "aws_nat_gateway" "webapp-nat-gateway" {
  count         = length(local.azs)
  allocation_id = element(aws_eip.web_nat_eip[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnet[*].id, count.index)
  depends_on    = [aws_internet_gateway.webapp_igw]
  tags = {
    Name = "webapp-Nat Gateway ${count.index + 1}"
  }
}

####################### Security Group ############################
# Security Group for Webapp
resource "aws_security_group" "webapp_sg" {
  vpc_id = aws_vpc.webapp_vpc.id
  name   = var.sg_name
  tags   = var.tags
}

resource "aws_security_group_rule" "webapp_sg_ingress" {
  for_each                 = { for idx, ingress in var.ingress : idx => ingress }
  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  security_group_id        = aws_security_group.webapp_sg.id
  source_security_group_id = aws_security_group.dev_elb_sg.id
}

resource "aws_security_group_rule" "webapp_sg_egress" {
  type              = "egress"
  for_each          = { for idx, egress in var.egress : idx => egress }
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.webapp_sg.id
  cidr_blocks       = each.value.cidr_blocks
}

# Security Group for Dev ELB
resource "aws_security_group" "dev_elb_sg" {
  name = "dev_lb_sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.webapp_vpc.id
  tags   = var.tags
}


# Security Group for RDS DB
resource "aws_security_group" "rds_db_sg" {
  name   = "rds_db_sg"
  vpc_id = aws_vpc.webapp_vpc.id
  count  = var.create_db_subnet ? 1 : 0
  tags   = var.tags
}

resource "aws_security_group_rule" "db_sg_ingress" {
  for_each                 = var.create_db_subnet ? { for idx, ingress in var.db_ingress : idx => ingress } : {}
  type                     = "ingress"
  security_group_id        = aws_security_group.rds_db_sg[0].id
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  source_security_group_id = element(aws_security_group.webapp_sg[*].id, 0)
}

resource "aws_security_group_rule" "db_sg_egress" {
  for_each          = var.create_db_subnet ? { for idx, egress in var.db_egress : idx => egress } : {}
  type              = "egress"
  security_group_id = aws_security_group.rds_db_sg[0].id
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  from_port         = each.value.from_port
  cidr_blocks       = each.value.cidr_blocks
}



