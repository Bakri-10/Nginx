# Create an EC2 instance with Nginx installation using user data (Ubuntu)
resource "aws_instance" "nginx_server" {
  ami             = var.ec2_ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.allow_ssh_http.name]

  # User data to install Nginx on the instance
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "NginxServer"
  }
}
# Create a security group to allow SSH and HTTP
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow inbound SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

