resource "aws_security_group" "my_security_group" {
  name        = "allow_tls"
  description = "Allow SSH from all"
  vpc_id      = aws_vpc.my_vpc.id

  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.my_vpc.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  egress = [
    {
      description      = "SSH"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

}
