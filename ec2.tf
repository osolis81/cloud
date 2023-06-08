# ami-0715c1897453cabd1

# el for each a diferencia del count solo puede ser usado por variables tipo set y maps
variable "instancias" {
  description = "Nombre de las instancias"
  # otra funcion es que si usamos en vez de set un list, por que teoricamente puede existir codigo usando 
  # en otro lugar del levantamiento del recurso, se puede convertir la lista en set
  type = list(string)
  # type        = set(string)
  # si borramos el server apache, internamente terraform pasa a mantener el mismo indice, es decir
  # mysql pasa a ser el indice cero, y jumperserver el indice uno

  # default = ["apache", "mysql", "jumpserver"]
  default = ["apache"]
}


resource "aws_instance" "public_instance" {
  # la funcion length leerá la cantidad de elementos que tiene la variable y asignará a count
  # count                  = length(var.instancias)
  # for_each               = var.instancias
  for_each               = toset(var.instancias) # usando de otra manera aqui transformamos una lista a un set
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("scripts/userdata.sh")
  tags = {
    # "Name" = var.instancias[count.index]
    # para usar con variabe tipo set
    # "Name" = each.value
    "Name" = "${each.value}-${local.sufix}"
  }
}

# variales que sirvieron para utilizar el codigo de terraform console y poder usar sus funciones
# se lo apaga desde aqui 
/*
variable "cadena" {
  type    = string
  default = "ami-123,AMI-AAv,ami-12f"

}

variable "palabras" {
  type    = list(string)
  default = ["Hola", "como", "estan"]

}

variable "entornos" {
  type = map(string)
  default = {
    "prod" = "10.10.0.0/16"
    "dev"  = "172.16.0.0/16"
  }
}
*/

resource "aws_instance" "monitoring_instance" {
  # ejemplo de como usar la condición con booleans
  # count                  = var.enable_monitoring ? 1 : 0

  # ejemplo de como usar la condición con numeros
  # se puede usar varias condiciones !=0, !(2!=3), !((1==1)&&!(2==1)), (1==1)||(2==1)

  count = var.enable_monitoring == 1 ? 1 : 0

  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("scripts/userdata.sh")
  tags = {
    # "Name" = var.instancias[count.index]
    "Name" = "Monitoreo-${local.sufix}"
  }
}
