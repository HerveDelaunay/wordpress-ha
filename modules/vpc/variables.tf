variable "environment" {
  type = string
  default = "staging"
}

variable "cidr_vpc" {
  type = string
  default = "10.1.0.0/16"
}

variable "az_a" {
  default = "eu-west-3a" 
}

variable "az_b" {
  default = "eu-west-3b" 
}

variable "cidr_public_subnet_a" {
  type = string
  default = "10.1.0.0/24"
}

variable "cidr_public_subnet_b" {
  type = string
  default = "10.1.1.0/24"
}

variable "cidr_private_subnet_a" {
  type = string
  default = "10.1.2.0/24"
}

variable "cidr_private_subnet_b" {
  type = string  
  default = "10.1.3.0/24"
}