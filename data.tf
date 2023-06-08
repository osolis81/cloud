# el recurso aws_kay_pair, se lo encuentra en la 
# documentacion de terraform
# si ya existe un ami u otro recurso se los lee y se asigna al nuevo recurso
data "aws_key_pair" "key" {
  key_name = "mykey"
}
