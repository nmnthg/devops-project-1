# Main VPC
resource "aws_vpc" "projVPC" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "${var.Name_prefix}-vpc"
    }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.projVPC.id
    tags = {
        Name = "${var.Name_prefix}-igw"
    }
}

# Public subnets (two AZs)
resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.projVPC.id
    cidr_block = "${var.public_subnet_cidr1}"
    availability_zone = "us-east-1a"
    tags = {
        Name = "${var.Name_prefix}-public-1"
    }
}
resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.projVPC.id
    cidr_block = "${var.public_subnet_cidr2}"
    availability_zone = "us-east-1b"
    tags = {
        Name = "${var.Name_prefix}-public-1"
    }
}

# Private subnets (two AZs)
resource "aws_subnet" "private_1" {
    vpc_id = aws_vpc.projVPC.id
    cidr_block = "${var.private_subnet_cidr1}"
    availability_zone = "us-east-1a"
    tags = {
        Name = "${var.Name_prefix}-private-1"
    }
}
resource "aws_subnet" "private_2" {
    vpc_id = aws_vpc.projVPC.id
    cidr_block = "${var.private_subnet_cidr2}"
    availability_zone = "us-east-1b"
    tags = {
        Name = "${var.Name_prefix}-private-2"
    }
}

# NAT gateway
resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = { Name = "${var.Name_prefix}-nat-eip" }
}
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_1.id
    tags = { 
        Name = "${var.Name_prefix}-nat" 
        }
    depends_on = [aws_internet_gateway.igw]
}


# Route tables
# Public subnet route table and assoc
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.projVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}
resource "aws_route_table_association" "public_1" {
    subnet_id      = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_2" {
    subnet_id      = aws_subnet.public_2.id
    route_table_id = aws_route_table.public.id
}
# Private subnet route table and assoc
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.projVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    }
}
resource "aws_route_table_association" "private_1" {
    subnet_id      = aws_subnet.private_1.id
    route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_2" {
    subnet_id      = aws_subnet.private_2.id
    route_table_id = aws_route_table.private.id
}

#Security Groups
# ALB-SG
resource "aws_security_group" "alb-sg" {
    name = "${var.Name_prefix}-alb-sg"
    description = "ALB security group"
    vpc_id = aws_vpc.projVPC.id
    tags = {
        Name = "${var.Name_prefix}-alb-sg"
    }
}
# ALB-SG Allow inbound on port 80 from anywhere
resource "aws_vpc_security_group_ingress_rule" "anywhere_to_alb" {
    security_group_id = aws_security_group.alb-sg.id
    description = "Allow traffic on port 80 from anywhere"
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80 
    ip_protocol = "tcp"
    to_port = 80
}
# ALB-SG Allow egress to anywhere
resource "aws_vpc_security_group_egress_rule" "alb_egress" {
    security_group_id = aws_security_group.alb-sg.id
    description = "Allow egress to anywhere"
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}
# ECS-SG
resource "aws_security_group" "ecs-sg" {
    name = "${var.Name_prefix}-ecs-sg"
    description = "ECS tasks security group"
    vpc_id = aws_vpc.projVPC.id
    tags = {
        Name = "${var.Name_prefix}-ecs-sg"
    }
}
# ECS-SG Allow inbound on port 3000 from ALB
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
    security_group_id = aws_security_group.ecs-sg.id
    description = "Allow traffic on port 3000 from ALB"
    referenced_security_group_id = aws_security_group.alb-sg.id
    from_port = "${var.container_port}"
    ip_protocol = "tcp"
    to_port = "${var.container_port}"
}
# ECS-SG Allow egress to anywhere
resource "aws_vpc_security_group_egress_rule" "ecs_egress" {
    security_group_id = aws_security_group.ecs-sg.id
    description = "Allow egress to anywhere"
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}