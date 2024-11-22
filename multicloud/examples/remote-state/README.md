
# Configuração do Backend do Terraform com S3 e DynamoDB

Este guia descreve o processo de criação de um bucket no S3 para armazenar o estado do Terraform (`.tfstate`) e a criação de uma tabela no DynamoDB para controlar o locking do estado, garantindo que várias execuções do Terraform não interfiram entre si.

## 1. Criação do Bucket no S3

O Terraform usa o Amazon S3 para armazenar o estado remoto. Ao utilizar um bucket do S3, você garante que o estado do Terraform seja armazenado de forma centralizada e segura.

### Comando para criar o bucket no S3

Execute o comando abaixo para criar o bucket no S3. Substitua `tcb-devops-state-demo-x999x` por um nome único de sua escolha.

```bash
aws s3api create-bucket   --bucket tcb-devops-state-demo-x999x   --region us-east-1
```

- `--bucket`: Define o nome do bucket. O nome precisa ser único globalmente no S3.
- `--region`: Define a região onde o bucket será criado (no caso, `us-east-1`).

## 2. Criação da Tabela no DynamoDB para Locking

O DynamoDB será usado para gerenciar o **lock** do estado do Terraform. O lock impede que várias instâncias do Terraform modifiquem o estado simultaneamente, evitando conflitos de concorrência.

### Comando para criar a tabela no DynamoDB

Execute o comando abaixo para criar a tabela no DynamoDB. Substitua `tcb-devops-state-lock-table` por um nome de sua escolha para a tabela.

```bash
aws dynamodb create-table   --table-name tcb-devops-state-lock-table   --attribute-definitions AttributeName=LockID,AttributeType=S   --key-schema AttributeName=LockID,KeyType=HASH   --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5   --region us-east-1
```

- `--table-name`: Define o nome da tabela.
- `--attribute-definitions`: Define os atributos da tabela. O DynamoDB usa o `LockID` como chave primária, com o tipo de dado `String` (`S`).
- `--key-schema`: Define a chave primária da tabela. O `LockID` será a chave de hash.
- `--provisioned-throughput`: Define a capacidade provisionada da tabela. Neste exemplo, configuramos para 5 unidades de leitura e 5 de escrita.

### Detalhes sobre a tabela

A tabela criada no DynamoDB será usada para armazenar o lock do estado, garantindo que apenas uma execução do Terraform possa modificar o estado ao mesmo tempo.

## 3. Configuração do Terraform

Após criar o bucket no S3 e a tabela no DynamoDB, é necessário configurar o backend no Terraform. Adicione as seguintes configurações ao seu arquivo `main.tf` ou `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket = "tcb-devops-state-demo-x999x"
    key    = "path/to/your/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tcb-devops-state-lock-table"
    encrypt = true
  }
}
```

- `bucket`: Nome do bucket S3 que você criou.
- `key`: Caminho onde o estado será armazenado dentro do bucket.
- `region`: Região onde o bucket S3 está localizado.
- `dynamodb_table`: Nome da tabela DynamoDB usada para o lock do estado.
- `encrypt`: Habilita a criptografia do estado no S3.

## 4. Inicialização do Terraform

Com a configuração do backend definida, inicialize o Terraform para configurar o backend remoto:

```bash
terraform init
```

Este comando configura o backend do Terraform e permite que ele comece a interagir com o S3 e o DynamoDB para armazenar o estado e controlar o lock.