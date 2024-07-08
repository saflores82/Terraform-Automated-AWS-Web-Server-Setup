output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "sns_topic_arn" {
  value = aws_sns_topic.sns_topic.arn
}