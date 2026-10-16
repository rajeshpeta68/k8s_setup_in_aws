resource "aws_subnet" "k8s-public-subnet" {
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-2a"
  vpc_id                  = aws_vpc.k8s-vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "k8s-public-subnet"
  }

}

