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
  application         = aws_elastic_beanstalk_application.congressAve.name
  tags = {
    Environment = "Production"
  }
}

resource "aws_elastic_beanstalk_environment" "congressAve-dev" {
  name                = "congressAve-app-dev"
  application         = aws_elastic_beanstalk_application.congressAve.name
  tags = {
    Environment = "Development"
  }
}

# S3
resource "aws_s3_bucket" "congressAve-s3-prod" {
  bucket = "congressAve-prod-bucket"

  tags = {
    Name        = "CongressAve bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "congressAve-s3-dev" {
  bucket = "congressAve-dev-bucket"

  tags = {
    Name        = "CongressAve dev bucket"
    Environment = "Development"
  }
}

# DynamoDB table
resource "aws_dynamodb_table" "congressAve-dynamodb-table-prod" {
  hash_key = "Id"
  name     = "CongressAve-PhotoData-Prod"
  billing_mode     = "PAY_PER_REQUEST"
  attribute {
    name = "Id"
    type = "N"
  }
  tags = {
    Name        = "CongressAve DynamoDB"
    Environment = "Production"
  }
}

resource "aws_dynamodb_table" "congressAve-dynamodb-table-dev" {
  hash_key = "Id"
  name     = "CongressAve-PhotoData-Dev"
  billing_mode     = "PAY_PER_REQUEST"
  attribute {
    name = "Id"
    type = "N"
  }
  tags = {
    Name        = "CongressAve DynamoDB"
    Environment = "Development"
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
    Environment = "Production"
  }
}

# RDS table
resource "aws_db_instance" "congressAve-relation-db-dev" {
  db_name = "congressAveDevDb"
  engine = "mysql"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "blank"
  tags = {
    Name        = "CongressAve rdsDB"
    Environment = "Development"
  }
}

#Cognito Pool
resource "aws_cognito_user_pool" "congressAve-cognito-pool-prod" {
  name = "congressAve-pool-prod"
  tags = {
    Name        = "CongressAve cognito user pool"
    Environment = "Production"
  }
}

resource "aws_cognito_user_pool" "congressAve-cognito-pool-dev" {
  name = "congressAve-pool-dev"
  tags = {
    Name        = "CongressAve cognito user pool"
    Environment = "Development"
  }
}


