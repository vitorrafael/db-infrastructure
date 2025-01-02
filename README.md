# db-infrastructure

DB Infrastructure-as-Code

## Formatação correta dos arquivos

Antes de efetivar, acessar a pasta que contém os arquivos do terra a alteração do código, realizar o comando `terraform fmt`.

## Imprimir outputs

Os outputs são valores que são expostos com o objetivo de compartilhar informações entre os módulos do projeto.

Como boa prática exportar apenas objetos do recurso já criados no, e não fazer referências as variaveis que foram criadas nas plataformas de serviço em nuvem.

```javascript

output "instance_ip" {
  value = aws_instance.example.name //ou invês de usar var.name
  description = "O nome da instância criada no serviço EC2"
}

```

Esses valores podem ser exibidos com o comandos `terraform apply` ou `terraform output`.

## Boas práticas TerraForm

Nesse tópico, vou citar algumas das práticas de acordo com a [Hashicorp](https://developer.hashicorp.com/terraform/language/style), para padronização e desenvolvimento dos nossos arquivos do Terraform.

### Nomenclaturas

- **Nomes com snake_case**

  Seguir o padrão snake_case melhora a consistência, legibilidade e alinhamento com práticas comuns no Terraform.

  ```javascript
  resource "aws_security_group" "web_service_sg" {
    name        = "web_service_sg"
    description = "Security group for the web service"
  }
  ```

- **Não chamar o recurso com base no recurso utilizado**

  Ao usar o tipo do recurso no nome da variável pode levar a redundâncias e dificultar a leitura. Por isso a recomendação é que seja dado nomes concisos.

  Ruim:

  ```javascript
  resource "aws_security_group" "security_group_web" {...}
  ```

  Bom:

  ```javascript
  resource "aws_security_group" "web" {...}
  ```

- **Variáveis descritivas**

  As variáveis devem indicar claramente sua finalidade e/ou tipo.

  ```javascript
  variable "instance_type" {
    description = "Tipo de instância EC2 a ser utilizada"
    type = string
    default = "t2.micro"
  }
  ```

- **Nomes afirmativos**
  Nomes negativos podem causar confusão ao usar condições.
  Ruim:
  ```javascript
  variable "disable_logs" {
    description = "Se verdadeiro, os logs estão desativados"
  }
  ```
  Bom:
  ```javascript
  variable "enable_logs" {
    description = "Se verdadeiro, os logs estão ativados"
  }
  ```

### Data Sources

Para os data sources, a recomendação de uso depende do tamanho do projeto:

- Projetos grandes: é recomendado que exista um arquivo data.tf que centralize e compartilhe os data sources entre todo o projeto.
- Projetos pequenos: é recomendado que o data source fique junto com o recurso que irá utiliza-lo.

## Recurso `for_each` versus `count`

| **Aspecto**       | **for_each**                                             | **count**                                     |
| ----------------- | -------------------------------------------------------- | --------------------------------------------- |
| **Quando usar**   | Para iterar sobre mapas ou listas com chaves únicas.     | Para iterar sobre listas simples.             |
| **Identificação** | Usa `each.key` e `each.value`.                           | Usa índices baseados em zero (`count.index`). |
| **Flexibilidade** | Mais flexível, permite identificar instâncias pelo nome. | Menos flexível, baseado apenas na ordem.      |

---

### Exemplo de `for_each`

**Descrição:** Usado para criar múltiplos recursos de acordo com valores de um mapa.

**Código:**

```javascript
resource "aws_security_group_rule" "example" {
  for_each = {
    rule1 = "22"
    rule2 = "80"
    rule3 = "443"
  }
  from_port   = each.value
  to_port     = each.value
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

O resultado da execução acima é que três regras de segurança são criadas com base nas portas definidas no mapa.

### Exemplo de `count`

Usado para criar múltiplos recursos com base em uma lista simples:

```javascript
resource "aws_instance" "example" {
  count         = 2
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

O resultado do da execução com counté que duas instâncias são criadas.

### Dependência explícita vs implícita

#### Dependência explícita (depends_on)

É recomendada que seja utilizada quando não há uma conexão direta entre recursos, mas é necessário garantir que um recurso seja criado antes de outro.

Exemplo:

```javascript
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
}


resource "aws_instance" "example_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  depends_on    = [aws_s3_bucket.example_bucket]
}
```

Nesse cenário a instância só será criada após o bucket S3.

#### Dependência implícita (automática)

A depedência implícita é criada automaticamente quando um recurso faz referência direta a outro.

Exemplo:

```javascript
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
}

resource "aws_s3_bucket_object" "example_object" {
  bucket  = aws_s3_bucket.example_bucket.id
  key     = "example-key"
  content = "example-content"
}

```

O Terraform sabe que o bucket deve ser criado antes do objeto porque há uma referência direta ao bucket.id.

#### Quando usar cada uma?

- Dependência implícita:

  - Prefira sempre que possível.
  - Melhora a clareza do código.
  - Reduz erros ao reorganizar os recursos.

- Dependência explícita:
  - Use apenas quando:
    - A dependência não for óbvia.
    - Houver requisitos específicos que exijam controle manual.
