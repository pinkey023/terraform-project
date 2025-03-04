provider "aws" {
region = "ap-south-1"
access_key = ""
secret_key = ""
}
resource "aws_instance" "one" {
ami = "ami-0d951b011aa0b2c19"
key_name = "honey"
instance_type = "t2.micro"
availability_zone = "ap-south-1a"
vpc_security_group_ids = [aws_security_group.five.id]
user_data = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "hai this is my app created by terraform in server-1" >/var/www/html
EOF
tags = {
Name = "webserver-1"
}
}
resource "aws_instance" "two" {
ami = "ami-0d951b011aa0b2c19"
key_name = "honey"
instance_type = "t2.micro"
availability_zone = "ap-south-1b"
vpc_security_group_ids = [aws_security_group.five.id]
user_data = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "hai this is my app created by terraform in server-2" >/var/www/html
EOF
tags = {
Name = "webserver-2"
}
}
resource "aws_instance" "three" {
ami = "ami-0d951b011aa0b2c19"
key_name = "honey"
instance_type = "t2.micro"
availability_zone = "ap-south-1a"
vpc_security_group_ids = [aws_security_group.five.id]
tags = {
Name = "appserver-1"
}
}
resource "aws_instance" "four" {
ami = "ami-0d951b011aa0b2c19"
key_name = "honey"
instance_type = "t2.micro"
availability_zone = "ap-south-1b"
vpc_security_group_ids = [aws_security_group.five.id]
tags = {
Name = "appserver-2"
}
}
resource "aws_security_group" "five" {
name = "pinkey-sg"
ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_s3_bucket" "six" {
bucket = "mintu00113344"
}
resource "aws_iam_user" "seven" {
for_each = var.user_names
name = each.value
}
variable "user_names" {
description = "*"
type = set(string)
default = ["user-1", "user-2", "user-3", "user-4"]
}
resource "aws_ebs_volume" "eight" {
size = 40
availability_zone = "ap-south-1a"
tags = {
Name = "vol-1"
}
}
resource "aws_elb" "bar" {

  availability_zones = ["ap-south-1a", "ap-south-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                 = ["${aws_instance.one.id}", "${aws_instance.two.id}"]
  cross_zone_load_balancing = true
  idle_timeout              = 400
  tags = {
    Name = "raham-tf-elb"
  }
}
