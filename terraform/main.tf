provider "aws" {
  region = "us-east-1"
}

# Security Group: Allow SSH (22) and HTTP (80)
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP for better security
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type          = "t2.micro"
  key_name               = "my-key" # This must be pre-uploaded in AWS
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "jenkins-nginx"
  }

  provisioner "remote-exec" {
    inline = [
      "echo EC2 instance is up and connected via SSH"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/../my-key.pem")
      host        = self.public_ip
      timeout     = "3m"
      retries     = 10
    }
  }
}

# Output EC2 Public IP
output "instance_ip" {
  value = aws_instance.web.public_ip
  description = "Public IP of EC2 instance"
}
