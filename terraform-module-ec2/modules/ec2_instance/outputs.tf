output "instance_ids" {
    value = aws_instance.webserver[*].id
}

output "public_ips" {
    value = aws_instance.webserver[*].public_ip
}