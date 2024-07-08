variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "key_pair_name" {
  description = "The name of the key pair to use for SSH access."
  default     = "my-key-pair"
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance."
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
}

variable "sns_topic_name" {
  description = "The name of the SNS topic."
  default     = "test-topic"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  default     = "process_form"
}

variable "slack_webhook_url" {
  description = "The Slack webhook URL for notifications."
  default     = "https://hooks.slack.com/services/your/slack/webhook"
}
