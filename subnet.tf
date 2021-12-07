resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_database_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_db_subnet_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
}
