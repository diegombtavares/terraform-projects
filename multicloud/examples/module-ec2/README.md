# Guia de Instalação do Terraform no Linux

## Passo 1: Baixar o Binário do Terraform

Execute o seguinte comando para baixar a versão mais recente do Terraform:

```bash
curl -O https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)_linux_amd64.zip
```

```bash
sudo apt install unzip -y
```

```bash
unzip awscliv2.zip
```

```bash
sudo ./aws/install
```
