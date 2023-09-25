
## EC2 instance for airbyte ##

resource "aws_instance" "airbyte_instance" {

  instance_type = "t2.medium"

  ami = "ami-0fe0b2cf0e1f25c8a"
  tags = {
    "Name" = "${var.project}_${var.name}_airbyte_instance"
  }

  user_data = templatefile("${path.module}/ressources/airbyte_init.sh", {
    airbyte_version = "v0.40.27"
    }
  )
  key_name               = var.name
  iam_instance_profile   = aws_iam_instance_profile.airbyte.name
  vpc_security_group_ids = [aws_security_group.airbyte_sg.id]
}

# ## Security group for airbyte_instace ##

resource "aws_security_group" "airbyte_sg" {
  name        = "${var.project}_${var.name}_airbyte_sg"
  description = "Allow traffic"

  # ingress {
  #   description = "Airbyte UI"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["93.12.6.181/32"] # mettre son ip
  # }
  ingress {
    description = "Airbyte UI"
    from_port   = 8000
    to_port     = 8000
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


## ECR repository for airbyte custom connectors

resource "aws_ecr_repository" "airbyte_custom_connectors" {
  name                 = "${var.project}_${var.name}_airbyte_custom_connector_source_velib"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
