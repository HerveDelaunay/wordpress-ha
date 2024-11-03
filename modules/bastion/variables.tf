variable "allow_public_ssh_sg_id" {
  type = string
}

variable "allow_all_outbound_sg_id" {
  type = string
}

variable "vpc_public_subnets" {
  type = list(string)
}
