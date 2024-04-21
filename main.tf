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

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-2a"

  tags = {
    Name = "Default subnet for us-east-2a"
  }
}

resource "aws_elastic_beanstalk_application" "congressAve" {
  name        = "congressAve-app"
}

# Elastic Beanstalk
resource "aws_elastic_beanstalk_environment" "congressAve-prod" {
  name                = "congressAve-app-prod"
  application         = aws_elastic_beanstalk_application.congressAve.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.2.2 running Corretto 21"
  # Auto Scaling launch configuration
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }
  tags = {
    Environment = "Production"
  }
}

resource "aws_elastic_beanstalk_environment" "congressAve-dev" {
  name                = "congressAve-app-dev"
  application         = aws_elastic_beanstalk_application.congressAve.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.2.2 running Corretto 21"
  # Auto Scaling launch configuration
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }
  tags = {
    Environment = "Development"
  }
}

# S3
resource "aws_s3_bucket" "congressAve-s3-prod" {
  bucket = "congressave-prod-bucket"

  tags = {
    Name        = "CongressAve bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "congressAve-s3-dev" {
  bucket = "congressave-dev-bucket"

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
  allocated_storage    = 10
  username = "admin"
  password = "blankpassword"
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
  allocated_storage    = 10
  username = "admin"
  password = "blankpassword"
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


