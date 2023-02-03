output "dns_public1" {
    description = "DNS pubblica de mi_servidor 1"
    value = "http://${aws_instance.servidor_1.public_dns}"
}

output "ip_public1" {
    description = "IP pubblica de mi_servidor 1"
    value = "http://${aws_instance.servidor_1.public_ip}:8080"
}

output "dns_public2" {
    description = "DNS pubblica de mi_servidor 2"
    value = "http://${aws_instance.servidor_2.public_dns}"
}

output "ip_public2" {
    description = "IP pubblica de mi_servidor 2"
    value = "http://${aws_instance.servidor_2.public_ip}:8080"
}