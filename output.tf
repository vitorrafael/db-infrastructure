output "rds_endpoint" {
  value       = aws_db_instance.postgres-instance.endpoint
  description = "RDS Instance Endpoint"
}

output "rds_security_group_id" {
  value       = aws_security_group.db_sg.id
  description = "RDS Instance Security Group ID"
}
