resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key" {
  key_name   = "my_key"  # Name for the key pair in AWS
  public_key = tls_private_key.example.public_key_openssh
}

