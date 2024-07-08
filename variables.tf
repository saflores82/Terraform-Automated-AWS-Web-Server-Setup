variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance."
  default     = "ami-01b799c439fd5516a" # Amazon Linux 2 AMI
}

variable "lambda_subscription" {
  description = "The name of the SNS topic."
  default     = "test-topic"
}

variable "email_subscription" {
  description = "The name of the SNS topic."
  type        = string
  default     = "test-topic"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  default     = "process_form"
}

