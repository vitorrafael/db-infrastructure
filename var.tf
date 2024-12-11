variable "projectName" {
  description = "Nome projeto"
  type        = string
  default     = "tech-challenge-lanchonete"
}

variable "regionDefault" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "vpcCidr" {
  description = "CIDR da VPC"
  type        = string
  default     = "172.31.0.0/16"
}

variable "dbUsername" {
  description = "Usuário do banco de dados"
  type        = string
  default     = "postgres"
}

variable "dbSecret" {
  description = "Senha do banco de dados"
  type        = string
  default     = "MTIzNDU2"
}

