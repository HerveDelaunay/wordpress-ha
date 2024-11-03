variable "vpc_id" {
  type        = string
  description = "id of the vpc"
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_public_subnets" {
  type = list(string)
}
variable "db_name" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}

variable "db_hostname" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "allow_private_ssh_id" {
  type = string
}

variable "allow_public_http_id" {
  type = string
}

variable "allow_all_outbound_id" {
  type = string
}
