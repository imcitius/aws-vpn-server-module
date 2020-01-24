resource "aws_vpc" "vpn" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpn vpc"
  }
}

resource "aws_internet_gateway" "vpn_gw" {
  vpc_id = aws_vpc.vpn.id
}

resource "aws_subnet" "vpn" {
  vpc_id     = aws_vpc.vpn.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  depends_on = [
    aws_internet_gateway.vpn_gw
  ]

  tags = {
    Name = "vpn subnet"
  }
}

resource "aws_default_route_table" "route_table" {

  default_route_table_id = aws_vpc.vpn.default_route_table_id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpn_gw.id
  }
  
  tags = {
    Name = "vpn route table"
  }

}
