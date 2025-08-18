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