- Criação de um bucket para armazenamento do terraform tf.state

Criação do bucket via CLI:

aws s3api create-bucket --bucket tcb-devops-state-demo-x999x --region us-east-1

- Utilização do dynamodb para interagir com o terraform lock

Criação do dynamoDB:

aws dynamodb create-table \
  --table-name tcb-devops-state-lock-table \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-1
