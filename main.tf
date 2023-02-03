provider "aws" {
  region = "us-west-2"
}

# ----------------------------------------------------
# Data Source para obtener el ID de la VPC por defecto
# ----------------------------------------------------
data "aws_vpc" "default" {
  default = true
}

# -----------------------------------------------
# Data source que obtiene el id del AZ us-west-1a
# -----------------------------------------------
data "aws_subnet" "az_a" {
  availability_zone = "us-west-2a"
}

# -----------------------------------------------
# Data source que obtiene el id del AZ us-west-1a
# -----------------------------------------------
data "aws_subnet" "az_b" {
  availability_zone = "us-west-2b"
}

# ---------------------------------------
# Define una instancia EC2 con AMI Ubuntu 1
# ---------------------------------------
resource "aws_instance" "servidor_1" {
    ami = "ami-095413544ce52437d"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]
    subnet_id              = data.aws_subnet.az_a.id

  user_data = <<-EOF
              #!/bin/bash
              echo "Hola Terraformers! Soy servidor 1" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

    tags = {
        Name = "servidor_1"
    }
}


# ---------------------------------------
# Define una instancia EC2 con AMI Ubuntu 2
# ---------------------------------------
resource "aws_instance" "servidor_2" {
    ami = "ami-095413544ce52437d"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]
    subnet_id              = data.aws_subnet.az_b.id

  user_data = <<-EOF
              #!/bin/bash
              echo "Hola Terraformers! Soy servidor 2" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

    tags = {
        Name = "servidor_2"
    }
}

# ------------------------------------------------------
# Define un grupo de seguridad con acceso
# ------------------------------------------------------
resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Acceso al puerto 8080 desde el exterior"
        from_port   = 8080
        to_port     = 8080
        protocol    = "TCP"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# ----------------------------------------
# Load Balancer público con dos instancias
# ----------------------------------------
resource "aws_lb" "alb" {
  load_balancer_type = "application"
  name               = "terraformers-alb"
  security_groups    = [aws_security_group.alb.id]

  subnets = [data.aws_subnet.az_a.id, data.aws_subnet.az_b.id]
}

# ------------------------------------
# Security group para el Load Balancer
# ------------------------------------
resource "aws_security_group" "alb" {
  name   = "alb-sg"
  vpc_id = data.aws_vpc.default.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acceso al puerto 80 desde el exterior"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
  }
}