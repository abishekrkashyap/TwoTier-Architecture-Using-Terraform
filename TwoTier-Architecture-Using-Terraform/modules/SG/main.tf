# create security group for the application load balancer

resource "aws_security_group" "albSG" {
  name = "alb-SG"
  description = "enable http/https access on port 80/443"
  vpc_id = var.vpcID

ingress {
    description = "http access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

}

ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
}

tags = {
    Name = "ALB-Security Group"
}
}

# create security group for the Client

resource "aws_security_group" "clientSG" {
  name = "client-SG"
  description = "enable http/https access on port 80 for elb sg"
  vpc_id      = var.vpcID

  ingress {
    description = "http access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.albSG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Client Security Group"
  }
}

# create security group for the Database

resource "aws_security_group" "databaseSG" {
  name = "database-SG"
  description = "enable mysql access on port 3305 from client-sg"
  vpc_id      = var.vpcID

  ingress {
    description     = "mysql access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.clientSG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database Security Group"
  }
}

# create security group for the Bastion host or Jump server

resource "aws_security_group" "jumpSG" {
  name        = "jump_sg"
  description = "enable ssh access on port 22 "
  vpc_id      = var.vpcID

  ingress {
    description     = "ssh access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jump Security Group"
  }
}

