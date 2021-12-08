#! /bin/bash
sudo su
yum update
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html