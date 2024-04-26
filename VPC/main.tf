resource "aws_vpc" "vpc_tf" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "pub_subnet_tf" {
  count = var.sub_value == true ? length(var.pub_sub_cidr) : 0
  vpc_id = aws_vpc.vpc_tf.id
  cidr_block = var.pub_sub_cidr[count.index]
  tags = {
    Name = "my_pubsub_${count.index + 1}"
  }
}

resource "aws_subnet" "pri_subnet_tf" {
  count = var.sub_value == true ? length(var.pri_sub_cidr) : 0
  vpc_id = aws_vpc.vpc_tf.id
  cidr_block = var.pri_sub_cidr[count.index]
  tags = {
    Name = "my_prisub_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw_tf" {
  count = var.sub_value == true ? 1 : 0
  vpc_id = aws_vpc.vpc_tf.id
  tags = {
    Name = "my_igw"
  }
}

resource "aws_eip" "eip_tf" {
  count = var.sub_value == true ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "my_eip"
  }
}

resource "aws_nat_gateway" "nat_gw_tf" {
  count = var.sub_value == true ? 1 : 0
  allocation_id = aws_eip.eip_tf[0].id
  subnet_id = aws_subnet.pub_subnet_tf[0].id  
  tags = {
    Name = "my-nat"
  }
}

resource "aws_route_table" "pub_rtb" {
  count = var.sub_value == true ? 1 : 0
  vpc_id = aws_vpc.vpc_tf.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_tf[0].id
  }
  tags = {
    Name = "my_pub_rtb"
  }
}

resource "aws_route_table" "pri_rtb" {
  count = var.sub_value == true ? 1 : 0
  vpc_id = aws_vpc.vpc_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_tf[0].id
  }
  tags = {
    Name = "my_pri_rtb"
  }
}

resource "aws_route_table_association" "pubsub_association" {
  count = var.sub_value == true ? length(var.pub_sub_cidr) : 0
  subnet_id = aws_subnet.pub_subnet_tf[count.index].id
  route_table_id = aws_route_table.pub_rtb[0].id
}

resource "aws_route_table_association" "prisub_association" {
  count = var.sub_value == true ? length(var.pri_sub_cidr) : 0
  subnet_id = aws_subnet.pri_subnet_tf[count.index].id
  route_table_id = aws_route_table.pri_rtb[0].id
}

