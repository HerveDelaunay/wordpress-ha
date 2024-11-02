variable "db_username" {
  type        = string
  description = "DB username"
  sensitive   = true
  default     = "db_user"
}

variable "db_password" {
  type        = string
  description = "DB password"
  default     = "password"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "DB name"
  default     = "wordpress_db"
}

variable "vpc_id" {
  type     = string
  nullable = false
}

variable "private_subnets_ids" {
  type     = list(string)
  nullable = false
}
