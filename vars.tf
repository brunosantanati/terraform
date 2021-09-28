variable "amis" {
  type = map

  default = {
      "us-east-1" = "ami-0747bdcabd34c712a"
      "us-east-2" = "ami-00dfe2c7ce89a450b"
  }
}