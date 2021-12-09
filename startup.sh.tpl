#! /bin/bash
sudo su
yum update -y
yum install -y httpd
yum install mysql
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y git
cd /var/www/html/
git clone https://github.com/its-ammu/intern-assignment.git .
echo ${rds_host} > host.txt
mysql -h ${rds_host} -u admin -ppassword < todo.sql
systemctl start httpd
systemctl enable httpd