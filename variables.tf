variable "virginia_cidr" {
  description = "CIDR Virginia"
  type        = string
  sensitive   = false
  # recordar que false es un valor por defecto
  # y es como si no se lo pusiera
  # cuando sensitive es true al hacer el plan, no se mostrará los valores 
}
# solo se declaran variables en este archivo

# variable "public_subnet" {
#   description = "CIDR public subnet"
#   type        = string

# }

# variable "private_subnet" {
#   description = "CIDR private subnet"
#   type        = string

# }

variable "subnets" {
  description = "Lista de subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags del proyecto"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR for ingress traffic"
  type        = string

}

variable "ec2_specs" {
  description = "Parametros de la instancia"
  type        = map(string)
}

variable "enable_monitoring" {
  description = "Habilita el despligue de un server de monitoreo"

  # type        = bool
  type = number
}

variable "ingress_ports_list" {
  description = "Lista de puertos de ingress "
  type        = list(number)
}


# para terraform cloud

variable "access_key" {

}

variable "secret_key" {

}
