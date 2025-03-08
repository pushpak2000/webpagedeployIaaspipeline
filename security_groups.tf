resource "aws_security_group" "nginx-sg" {
  vpc_id = aws_vpc.my_vpc.id

  #Inbound rule for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from any IP
  }


  #Outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-sg"
  }
}

variable "ssh_public_key" {
  description = "SSH public key to create the key pair"
  type        = string
}

resource "aws_key_pair" "my_key" {
  key_name   = "my_key"  # Name of the key pair in AWS
  public_key = var.ssh_public_key  # Use the value passed from GitHub Actions (via the secret)
}