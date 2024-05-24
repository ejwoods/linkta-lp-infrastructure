variable "vpc_id" {}


resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id
  tags = {
    Name = "ecs-sg"
  }
}

# TODO: Remove HTTP rules when HTTPS is fully implemented
resource "aws_vpc_security_group_ingress_rule" "http_ingress" {
  security_group_id = aws_security_group.ecs_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# TODO: Remove HTTP rules when HTTPS is fully implemented
resource "aws_vpc_security_group_egress_rule" "http_egress" {
  security_group_id = aws_security_group.ecs_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Future setup for HTTPS traffic
# resource "aws_vpc_security_group_egress_rule" "https_egress" {
#   security_group_id = aws_security_group.ecs_sg.id
#   from_port         = 443
#   to_port           = 443
#   ip_protocol       = "tcp"
#   cidr_ipv4         = "0.0.0.0/0"
# }

# Future setup for DNS traffic
# resource "aws_vpc_security_group_egress_rule" "dns_egress" {
#   security_group_id = aws_security_group.ecs_sg.id
#   from_port         = 53
#   to_port           = 53
#   ip_protocol       = "udp"
#   cidr_ipv4         = "0.0.0.0/0"
# }
