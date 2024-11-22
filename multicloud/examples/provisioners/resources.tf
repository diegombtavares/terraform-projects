resource "aws_security_group" "example" {
  name = "example"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "aws_tf_key"
  public_key = file("./ec2-key.pub")
}

resource "aws_instance" "ec2" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.example.id]

  # Provisionamento local para salvar o IP público da instância em um arquivo
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ec2-public-ip.txt"
  }

  # Provisionamento de arquivo: faz upload do diretório ./dump para a instância EC2
  provisioner "file" {
    source      = "./dump"
    destination = "/tmp/dump-onp"
  }

  # Provisionamento de arquivo: cria um arquivo na instância EC2
  provisioner "file" {
    content     = "EC2 AZ: ${self.availability_zone}"
    destination = "/tmp/ec2-az.txt"
  }

  # Provisionamento remoto: executa um comando dentro da instância EC2
  provisioner "remote-exec" {
    inline = [
      "echo EC2 ARN: ${self.arn} >> /tmp/arn.txt",
      "echo EC2 Public DNS: ${self.public_dns} >> /tmp/public_dns.txt",
      "echo EC2 Private IP: ${self.private_ip} >> /tmp/private_ip.txt"
    ]
  }

  # Conexão SSH para provisionamento remoto
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./ec2-key")
    host        = self.public_ip
  }
}