resource "aws_db_instance" "postgres_instance" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "14.9"
  identifier             = "lanchonete-database" # Nome do banco de dados
  instance_class         = "db.t3.medium"
  username               = var.dbUsername
  password               = var.dbSecret
  parameter_group_name   = "default.postgres14" # Grupo de parâmetros padrão
  publicly_accessible    = false                # Restringir acesso público
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  db_name             = var.databaseName
  skip_final_snapshot = true

  # Configuração de backup
  maintenance_window      = "Tue:00:00-Tue:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 30

  tags = {
    Name = "PostgresDatabase"
    Env  = "Production"
  }
}