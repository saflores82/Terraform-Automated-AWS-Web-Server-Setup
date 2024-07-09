output "instance_public_ip" {
  description = "The public IP of the web server instance."
  value       = aws_instance.web_server.public_ip
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic."
  value       = aws_sns_topic.sns_topic.arn
}
