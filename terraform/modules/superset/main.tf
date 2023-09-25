
## EC2 instance for superset ##

resource "aws_instance" "superset_instance" {

  instance_type = "t2.medium"

  ami = "ami-0fe0b2cf0e1f25c8a"
  tags = {
    "Name" = "${var.project}_${var.name}_superset_instance"
  }

  user_data = file("${path.module}/ressources/superset_init.sh")
  key_name               = var.name
  vpc_security_group_ids = [aws_security_group.superset_sg.id]
}

# ## Security group for superset_instace ##

resource "aws_security_group" "superset_sg" {
  name        = "${var.project}_${var.name}_superset_sg"
  description = "Allow traffic"

  # ingress {
  #   description = "superset UI"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["93.12.6.181/32"] # mettre son ip
  # }
  ingress {
    description = "superset UI"
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = [format("%s/%s","${var.ip}",32)]
  }
  ingress {
    description = "allow ssh"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [format("%s/%s","${var.ip}",32)]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
