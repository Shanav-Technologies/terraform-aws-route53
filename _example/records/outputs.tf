output "zone_id" {
  value       = aws_route53_zone.main.zone_id
  description = "The ID of the Hosted Zone."
}

output "name_servers" {
  value       = aws_route53_zone.main.name_servers
  description = "Name servers for domain configuration."
}
