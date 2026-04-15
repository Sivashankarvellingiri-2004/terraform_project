resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr 
  tags = {
    name = "main-vpc"
  }
}

resource "aws_subnet" "subnets" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "subnet-${var.azs[count.index]}" }
}
 
resource "aws_internet_gateway" "demo_ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    name = "demo_ig"
  }
}

resource "aws_route_table" "main_rt" {
  vpc_id =   aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_ig.id
  }

  tags = {
    name ="main_rt"
  }
}
 
resource "aws_route_table_association" "rt_assoc" {
  count          = length(aws_subnet.subnets)
  subnet_id = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.main_rt.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
 
output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}
 
