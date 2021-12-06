data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # imageowner
}

resource "aws_key_pair" "ssh-key"{
   key_name   = "ssh-key"
   public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxD+yhoRCfvd/4IVjtGdvj09wuRdwNat/AHOiB/AqELL6k0RL6qxMATPJB/c67SCoaWT1sclw8Ikbjr6NoI3OZnqNfug0CLXukBk7b7pLZOuW+nfkrCuYpPwZONqk237KbRM8jMUqp6Ro0oEPaxkno+/tKVXfABL73t6MG7hfditcS9WMGJ5pOMZnL5FsdOggzeHaANT7kv5I6Gyx36809/ywJath6bGjFKBVxuqSli5zc2l8A3fmXqEial/KEFy3ufNiFTF1Plt+OQDBHjBxVvykMWpRQI/giqdZgScpzmuoXkhjWxXvFd3mHWNzPivJLF0EeiUB2DmNZ3OHFLhEXVzGmq1KiB7+HYF6ZWvAXDVvYqhtHG23bypF7HBqJ6fVgpLPzZpz5CaYG4P2FqAHONG4f9AZnpxXrmqMP6wtzrfoSHYnpjVV5LFo/R7eFsRnX+zVGCfqx5OpEcONpkiUIofDiLTLCNBuHoJLwnYIWtZYp6F4d/KkJOxJYQF/teaU="
}
