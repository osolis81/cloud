#!/bin/bash
echo -e "Este es un mensaje" >> ~/mensaje.txt

yum update -y 
yum install httpd -y
systemctl enable httpd
systemctl start httpd
