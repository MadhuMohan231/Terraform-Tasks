resource "aws_vpc" "vpc-tf" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "pub-subnet-tf" {
  vpc_id = aws_vpc.vpc-tf.id
  cidr_block = var.pub-sub-cidr

  tags = {
    Name = "my-pubsub"
  }
}

resource "aws_subnet" "pri-subnet-tf" {
  vpc_id = aws_vpc.vpc-tf.id
  cidr_block = var.pri-sub-cidr

  tags = {
    Name = "my-prisub"
  }
}

resource "aws_internet_gateway" "igw-tf" {
  vpc_id = aws_vpc.vpc-tf.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_eip" "eip-tf" {
  domain = "vpc"

  tags = {
    Name = "my-eip"
  }
}

resource "aws_nat_gateway" "nat-gw-tf" {
  allocation_id = aws_eip.eip-tf.id
  subnet_id = aws_subnet.pub-subnet-tf.id
  
  tags = {
    Name = "my-nat"
  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc-tf.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf.id
  }

  tags = {
    Name = "my-pubrtb"
  }
}

resource "aws_route_table" "pri-rt" {
  vpc_id = aws_vpc.vpc-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw-tf.id
  }

  tags = {
    Name = "my-prirtb"
  }
}

resource "aws_route_table_association" "pubsub-association" {
  subnet_id = aws_subnet.pub-subnet-tf.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "prisub-association" {
  subnet_id = aws_subnet.pri-subnet-tf.id
  route_table_id = aws_route_table.pri-rt.id
}

