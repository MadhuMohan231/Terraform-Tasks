resource "aws_vpc" "vpc_tf" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "pub_subnet_tf" {
  vpc_id = aws_vpc.vpc_tf.id
  cidr_block = var.pub_sub_cidr
  tags = {
    Name = "my_pubsub"
  }
}

resource "aws_subnet" "pri_subnet_tf" {
  vpc_id = aws_vpc.vpc_tf.id
  cidr_block = var.pri_sub_cidr
  tags = {
    Name = "my_prisub"
  }
}

resource "aws_internet_gateway" "igw_tf" {
  vpc_id = aws_vpc.vpc_tf.id
  tags = {
    Name = "my_igw"
  }
}

resource "aws_eip" "eip_tf" {
  domain = "vpc"
  tags = {
    Name = "my_eip"
  }
}

resource "aws_nat_gateway" "nat_gw_tf" {
  allocation_id = aws_eip.eip_tf.id
  subnet_id = aws_subnet.pub_subnet_tf.id  
  tags = {
    Name = "my-nat"
  }
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.vpc_tf.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_tf.id
  }
  tags = {
    Name = "my_pubrtb"
  }
}

resource "aws_route_table" "pri_rtb" {
  vpc_id = aws_vpc.vpc_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_tf.id
  }
  tags = {
    Name = "my_prirtb"
  }
}

resource "aws_route_table_association" "pubsub_association" {
  subnet_id = aws_subnet.pub_subnet_tf.id
  route_table_id = aws_route_table.pub_rtb.id
}

resource "aws_route_table_association" "prisub_association" {
  subnet_id = aws_subnet.pri_subnet_tf.id
  route_table_id = aws_route_table.pri_rtb.id
}

