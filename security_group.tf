resource "aws_security_group" "elb_security_group" {
  description = "ELB Security Group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress = [
    {
      description      = "elb-ingress"
      from_port        = 80
      to_port          = 80
      protocol         = "TCP"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  egress = [
    {
      description      = "elb-egress"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = [var.vpc-cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ] 
  
}


resource "aws_security_group" "my_security_group" {
  name        = "allow_tls"
  description = "Allow SSH from all"
  vpc_id      = aws_vpc.my_vpc.id

  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 80
      protocol         = "TCP"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = [aws_security_group.elb_security_group.id]
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


