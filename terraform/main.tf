provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = "my-key"               # Must be uploaded in AWS EC2 → Key Pairs
  tags = {
    Name = "jenkins-nginx"
  }

  provisioner "remote-exec" {
    inline = [
      "echo EC2 created"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("../my-key.pem")
      host        = self.public_ip
    }
  }
}
