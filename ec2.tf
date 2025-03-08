# EC2 instance For Nginx setup
resource "aws_instance" "nginxserver" {
  ami                         = "ami-03fd334507439f4d1"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_key.key_name
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.nginx-sg.id]
  associate_public_ip_address = true
user_data = <<-EOF
#!/bin/bash
echo "Updating system..."
sudo apt update -y
sudo apt upgrade -y

echo "Installing nginx"
sudo apt install nginx -y

echo "Starting nginx"
sudo systemctl start nginx
sudo systemctl enable nginx

echo "nginx is activated"
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo docker pull gitkeeper05/testingthecd:latest
sudo docker run -d --name my_container -p 8080:80 gitkeeper05/testingthecd
echo "Configuring Nginx reverse proxy"
echo 'server {
    listen 80;

    location / {
        proxy_pass http://localhost:8080;
    }
}' | sudo tee /etc/nginx/sites-available/default > /dev/null

sudo nginx -t && sudo systemctl restart nginx
EOF

  tags = {
    Name = "NginxServer"
  }
}