virginia_cidr = "10.10.0.0/16"

# solo se asignan los valores de las variables para que terraform las detecte y asigne el realizar el plan
# public_subnet  = "10.10.0.0/24"
# private_subnet = "10.10.1.0/24"

subnets = ["10.10.0.0/24", "10.10.1.0/24"]

tags = {
  "env"         = "dev"
  "owner"       = "practica"
  "cloud"       = "AWS"
  "IAC"         = "Terraform"
  "IAC_version" = "1.4.6"
  "project"     = "cerberus"
  "region"      = "virginia"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  "ami"           = "ami-0715c1897453cabd1"
  "instance_type" = "t2.micro"
}

# enable_monitoring = true

enable_monitoring = 0

ingress_ports_list = [22, 80, 443]
