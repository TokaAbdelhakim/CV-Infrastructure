resource "aws_elb" "my_elb" {
  name               = "my-elb"
  cross_zone_load_balancing   = true
  subnets             = [aws_subnet.public_subnet.id]
  security_groups = [aws_security_group.elb_security_group.id]
  
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    # number of checks before instance declared healthy 
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }
  
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300
 }

output "elb-dns-name" {
  value = aws_elb.my_elb.dns_name
}

