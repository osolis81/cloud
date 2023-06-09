resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  # tags = {
  #   Name = "VPC_VIRGINIA"
  #   name = "prueba"
  #   env  = "Development"
  # }
  # Son reemplazos por la nueva variable tipo maps

  # se elimina este tag, por que está ya incluido en los default tags 
  # en los providers

  # tags = var.tags
  tags = {
    "Name" = "VPC_VIRGINIA-${local.sufix}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc_virginia.id
  cidr_block = var.subnets[0]
  # cidr_block = var.public_subnet
  # este valor le asigna ips publicas  las rede publicas
  map_public_ip_on_launch = true
  # tags = {
  #   Name = "Public Subnet VIRGINIA"
  #   name = "prueba"
  #   env  = "Development"
  # }

  # tags = var.tags
  tags = {
    "Name" = "public_subnet-${local.sufix}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc_virginia.id
  # cidr_block = var.private_subnet
  cidr_block = var.subnets[1]
  # tags = {
  #   Name = "Private Subnet VIRGINIA"
  #   name = "prueba"
  #   env  = "Development"
  # }

  # tags = var.tags
  tags = {
    "Name" = "private_subnet-${local.sufix}"
  }
  # esta es un dependencia explícita
  # en donde especifico que primero se publique 
  # la subnet publica
  depends_on = [aws_subnet.public_subnet]

}

# variable "virginia_cidr" {
#  default = "10.10.0.0/16"
# }
# si se lo deja en blanco 
# preguntará en la linea de comando
# el valor que usará

# variable "ohio_cidr" {
#  default = "10.20.0.0/16"
# }

# se puede usar las variales de entorno, siempre deben comenzar TF_VAR
# export TF_VAR_virginia_cidr="10.10.0.0/16"

# Se puede usar la variable de entorne al ejecutar un plan
# terraform plan -var ohio_cidr="10.10.0.0/16"


# la forma mas común y usada es:
# es usar un archivo especifico, solo para definir las variables 
# y otro archivo para el contenido de las variables


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id

  tags = {
    Name = "igw vpc virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    # Name = "Public custome route table--${local.sufix}"
    Name = "Public crt-${local.sufix}"
  }
}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance Security Group"
  description = "Allow SSH inbound traffic and all egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

  # con dynamy blocks, las reglas del ingress ya no tendrán que repetirse varias veces
  # una vez confirmado el correcto funcionamiento aplicamos el dynami block

  dynamic "ingress" {
    for_each = var.ingress_ports_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }

  # ingress {
  #   description = "SSH over Internet"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [var.sg_ingress_cidr]
  #   # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  # }

  # ingress {
  #   description = "http over Internet"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = [var.sg_ingress_cidr]
  #   # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  # }

  # ingress {
  #   description = "https over Internet"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = [var.sg_ingress_cidr]
  #   # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Public Instance SG-${local.sufix}"
  }
}
