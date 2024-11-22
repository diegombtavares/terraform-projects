
# Utilização de Provisioners no Terraform

Os **Provisioners** no Terraform são usados para executar scripts ou comandos em recursos após sua criação ou alteração. Eles são úteis para automatizar configurações adicionais de infraestrutura, como a instalação de pacotes, a configuração de serviços ou a execução de comandos personalizados.

## Tipos de Provisioners

Existem dois tipos principais de provisioners no Terraform:

- **`local-exec`**: Executa um comando ou script na máquina local onde o Terraform está sendo executado.
- **`remote-exec`**: Executa um comando ou script em uma máquina remota.

## 1. Provisioner `local-exec`

O provisioner `local-exec` executa um comando ou script na máquina local onde o Terraform está sendo executado.

### Exemplo de uso do `local-exec`

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo 'Instância criada com sucesso!' > /tmp/instance_created.txt"
  }
}
```

Neste exemplo, o comando `echo` será executado localmente após a criação da instância EC2, criando um arquivo `/tmp/instance_created.txt` na máquina onde o Terraform está sendo executado.

### Parâmetros do `local-exec`:
- `command`: O comando a ser executado na máquina local.

## 2. Provisioner `remote-exec`

O provisioner `remote-exec` executa um comando ou script em uma máquina remota, como uma instância EC2 ou um servidor virtual.

### Exemplo de uso do `remote-exec`

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
```

Neste exemplo, após a criação da instância EC2, o Terraform executa dois comandos via SSH na instância remota: um para atualizar os pacotes e outro para instalar o servidor web Nginx.

### Parâmetros do `remote-exec`:
- `inline`: Uma lista de comandos a serem executados na máquina remota.
- `connection`: Configurações de conexão SSH, incluindo o tipo de conexão, o usuário, a chave privada e o host.

## 3. Evitando o Uso Excessivo de Provisioners

Embora os provisioners possam ser úteis, é recomendado usá-los com cautela. O uso excessivo de provisioners pode indicar um design de infraestrutura inadequado ou redundante. Quando possível, prefira soluções de automação como o Ansible, Chef ou Puppet para gerenciar configurações, pois eles são mais apropriados para esse tipo de tarefa.

## 4. Exemplos de Provisioners Combinados

É possível combinar provisioners com outros recursos do Terraform, como variáveis e outputs, para criar soluções mais dinâmicas.

### Exemplo de Provisioner `remote-exec` com variáveis

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "Exemplo de Instância"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${var.custom_message} > /home/ubuntu/message.txt"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
```

Aqui, o provisioner utiliza a variável `custom_message` para criar um arquivo `message.txt` na instância remota.

## 5. Considerações Finais

- **Ordem de Execução**: Os provisioners são executados após a criação ou alteração do recurso. Se o recurso for destruído, os provisioners não serão executados.
- **Falhas de Provisionamento**: Se um provisioner falhar, o Terraform considera a operação como falha, e o recurso pode não ser completamente configurado ou destruído corretamente.
- **Desempenho**: Provisioners podem adicionar tempo adicional às execuções do Terraform, especialmente quando há comandos longos ou conexões de rede envolvidas.

## 6. Conclusão

Os provisioners no Terraform são ferramentas úteis para realizar configurações adicionais em recursos após sua criação. No entanto, é importante utilizá-los de maneira eficiente e preferir outras ferramentas de automação quando possível para garantir que sua infraestrutura seja escalável e gerenciável de maneira eficiente.