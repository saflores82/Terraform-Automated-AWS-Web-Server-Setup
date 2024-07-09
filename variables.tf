variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance."
  type        = string
  default     = "ami-01b799c439fd5516a" # Amazon Linux 2 AMI
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
  default     = "process_form"
}

variable "email_subscription" {
  description = "The email address to subscribe to the SNS topic."
  type        = string
  default     = "salvador.flores@tajamar365.com"
}
