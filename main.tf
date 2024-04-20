terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_elastic_beanstalk_application" "congressAve" {
  name        = "congressAve-app"
}

# Elastic Beanstalk
resource "aws_elastic_beanstalk_environment" "congressAve-prod" {
  name                = "congressAve-app-prod"
  application         = aws_elastic_beanstalk_application.congressAve
  tags = {
    Environment = "Prod"
  }
}

resource "aws_elastic_beanstalk_environment" "congressAve-test" {
  name                = "congressAve-app-test"
  application         = aws_elastic_beanstalk_application.congressAve
  tags = {
    Environment = "Test"
  }
}

# S3
resource "aws_s3_bucket" "congressAve-s3-prod" {
  bucket = "congressAve-prod-bucket"

  tags = {
    Name        = "CongressAve bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket" "congressAve-s3-test" {
  bucket = "congressAve-test-bucket"

  tags = {
    Name        = "CongressAve test bucket"
    Environment = "Test"
  }
}

# DynamoDB table
resource "aws_dynamodb_table" "congressAve-dynamodb-table-prod" {
  hash_key = "Id"
  name     = "CongressAve-PhotoData-Prod"
  attribute {
    name = "Id"
    type = "N"
  }
  tags = {
    Name        = "CongressAve DynamoDB"
    Environment = "Prod"
  }
}

resource "aws_dynamodb_table" "congressAve-dynamodb-table-test" {
  hash_key = "Id"
  name     = "CongressAve-PhotoData-Test"
  attribute {
    name = "Id"
    type = "N"
  }
  tags = {
    Name        = "CongressAve DynamoDB"
    Environment = "Test"
  }
}

# RDS table
resource "aws_db_instance" "congressAve-relation-db-prod" {
  db_name = "congressAveProdDb"
  engine = "mysql"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "blank"
  tags = {
    Name        = "CongressAve rdsDB"
    Environment = "Prod"
  }
}

# RDS table
resource "aws_db_instance" "congressAve-relation-test-prod" {
  db_name = "congressAveTestDb"
  engine = "mysql"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "blank"
  tags = {
    Name        = "CongressAve rdsDB"
    Environment = "Test"
  }
}

#Cognito Pool
resource "aws_cognito_user_pool" "congressAve-cognito-pool-prod" {
  name = "congressAve-pool-prod"
}

resource "aws_cognito_user_pool" "congressAve-cognito-pool-test" {
  name = "congressAve-pool-test"
}


