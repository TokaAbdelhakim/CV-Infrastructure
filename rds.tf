# database subnet group

resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_database_subnet.id]
  description = "subnets for database instance"
}



# database instance 

resource "aws_db_instance" "database_instance" {
  allocated_storage    = 10
  engine               = "mysql"               #postgres
  instance_class       = "db.t2.micro"
  identifier           = "mypostgresql"
  name                 = "mydb"
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  username             = "admin"
  password		= "hellouser"
  multi_az             = true
  skip_final_snapshot  = true
}
