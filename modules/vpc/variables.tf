variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr_range" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidr_range" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}
