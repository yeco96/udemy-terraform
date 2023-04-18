output "dns_load_balancer" {
  description = "DNS pública del load balancer"
  value       = module.load_balancer.dns_load_balancer
}


output "instancia_ids" {
  description = "instancia_ids"
  value       = module.servidores_ec2.instancia_ids
}