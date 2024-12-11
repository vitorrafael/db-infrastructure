# Configuração do banco de dados RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier = "lanchonete-database" # Nome do banco de dados

  # Tamanho de GB
  allocated_storage     = 10
  max_allocated_storage = 30 #máximo permitido

  # Tipo e versão do banco
  engine         = "postgres"
  engine_version = "14.5"

  # Classe da instância atualizada de acordo com o instance type usando para o k8s - t3a.medium
  instance_class = "db.t3.medium"

  # Mesmo nome e senha que estava no projeto
  username = var.dbUsername #TODO - mudar para o terraform.tfvars
  password = var.dbSecret   #TODO - mudar para o terraform.tfvars

  parameter_group_name = "default.postgres14" # Grupo de parâmetros padrão
  publicly_accessible  = false                # Restringir acesso público

  # O valor de id, será criado quando o serviço para criar essa estrutura for executada
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  #TODO - falta configurar
  #db_subnet_group_name   = aws_db_subnet_group.default.id

  # Configuração de backup
  backup_retention_period = 7             # Retenção de backups (em dias)
  backup_window           = "02:00-03:00" # Janela para backups

  # Janela de manutenção
  maintenance_window = "Mon:03:00-Mon:04:00"

  tags = {
    Name = "PostgresDatabase"
    Env  = "Production"
  }

  # irá interagir com o lambda, se sim configurar o IAM roles
}