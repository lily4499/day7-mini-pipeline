terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = "us-east-1" }

# ---- Your fixed values ----
locals {
  vpc_id      = "vpc-070#e#8#332d26eb"
  subnet_id   = "subnet-062bafb72ff1b9c71"
  sg_id       = "sg-091906568d27d3894"     # aws-lil-sg
  ami_ubuntu  = "ami-0c7217cdde317cfec"    # Ubuntu 22.04
  key_name    = "ec2-devops-key"           # AWS key pair name (not the .pem file)
}

resource "aws_instance" "app" {
  ami                         = local.ami_ubuntu
  instance_type               = "t3.medium"            # low cost
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [local.sg_id]
  associate_public_ip_address = true
  key_name                    = local.key_name

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker
  EOF

  tags = {
    Name    = "liliane-mini-ec2"
    Project = "devops-30days"
  }
}

output "public_ip" { value = aws_instance.app.public_ip }
output "url"       { value = "http://${aws_instance.app.public_ip}" }
output "ssh_cmd"   { value = "ssh -i ~/ec2.pem ubuntu@${aws_instance.app.public_ip}" }


