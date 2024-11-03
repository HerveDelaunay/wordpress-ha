output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "alb_dns_name" {
  value       = module.wordpress.alb_dns_name
  description = "dns name of the alb, reachable via http"
}
