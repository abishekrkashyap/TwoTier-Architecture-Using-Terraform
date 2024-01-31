resource "aws_db_subnet_group" "bookShop_subnet" {
  name = var.dataBase_SubName
  subnet_ids = [var.PRI_SUB_5_A_ID, var.PRI_SUB_6_B_ID] # Replace with your private subnet IDs
}

resource "aws_db_instance" "bookDataBase" {
  identifier              = "book-db"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  allocated_storage       = 20
  username                = var.dataBaseUserName
  password                = var.dataBasePassword
  db_name                 = var.dataBaseName
  multi_az                = true
  storage_type            = "gp2"
  storage_encrypted       = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  vpc_security_group_ids = [var.dataBase_SG_Id] # Replace with your desired security group ID

   db_subnet_group_name = aws_db_subnet_group.bookShop_subnet.name

  tags = {
    Name = "Book-DataBase"
  }
}