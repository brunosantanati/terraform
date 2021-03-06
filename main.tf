provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  access_key = "my-access-key" # Trocar pelo aws_access_key_id
  secret_key = "my-secret-key" # Trocar pelo aws_secret_access_key
}

provider "aws" {
  alias = "us-east-2"
  version = "~> 2.0"
  region  = "us-east-2"
  access_key = "my-access-key" # Trocar pelo aws_access_key_id
  secret_key = "my-secret-key" # Trocar pelo aws_secret_access_key
}

resource "aws_instance" "dev" {
  count = 3
  ami = var.amis["us-east-1"]
  instance_type = "t2.micro"
  key_name = var.key_name
  tags = {
    Name = "dev${count.index}"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"]
}

/*resource "aws_instance" "dev4" {
  ami = var.amis["us-east-1"]
  instance_type = "t2.micro"
  key_name = var.key_name
  tags = {
    Name = "dev4"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"]
  depends_on = [aws_s3_bucket.dev4]
}*/

resource "aws_instance" "dev5" {
  ami = var.amis["us-east-1"]
  instance_type = "t2.micro"
  key_name = var.key_name
  tags = {
    Name = "dev5"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh.id}"]
}

resource "aws_instance" "dev6" {
  provider = aws.us-east-2
  ami = var.amis["us-east-2"]
  instance_type = "t2.micro"
  key_name = var.key_name
  tags = {
    Name = "dev6"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh-us-east-2.id}"]
  depends_on = [
    aws_dynamodb_table.dynamodb-homologacao-table
  ]
}

resource "aws_instance" "dev7" {
  provider = aws.us-east-2
  ami = var.amis["us-east-2"]
  instance_type = "t2.micro"
  key_name = var.key_name
  tags = {
    Name = "dev7"
  }
  vpc_security_group_ids = ["${aws_security_group.acesso-ssh-us-east-2.id}"]
}

/*resource "aws_s3_bucket" "dev4" {
  bucket = "brunolabs-dev4"
  acl    = "private"

  tags = {
    Name        = "brunolabs-dev4"
  }
}*/

resource "aws_s3_bucket" "homologacao" {
  bucket = "brunolabs-homologacao"
  acl    = "private"

  tags = {
    Name        = "brunolabs-homologacao"
  }
}

resource "aws_dynamodb_table" "dynamodb-homologacao-table" {
  provider = aws.us-east-2
  name           = "GameScores"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }
}