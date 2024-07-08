provider "aws" {
  region = var.aws_region
}
data "archive_file" "zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "vockey"
  security_groups = [aws_security_group.web_sg.name]
  connection{
   type         = "ssh"
   user         = "ec2-user"
   private_key  = file("ssh.pem")
   host         = self.public_ip
  
}
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd php php-cli php-json php-mbstring
              service httpd start
              chkconfig httpd on
              cd /var/www/html
              php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
              php composer-setup.php
              php -r "unlink('composer-setup.php');"
              php composer.phar require aws/aws-sdk-php
              cat <<EOM > /var/www/html/index.html
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Contact Form</title>
              </head>
              <body>
                  <h1>Contact Form</h1>
                  <form action="submit.php" method="POST">
                      <label for="name">Name:</label><br>
                      <input type="text" id="name" name="name" required><br>
                      <label for="email">Email:</label><br>
                      <input type="email" id="email" name="email" required><br>
                      <label for="message">Message:</label><br>
                      <textarea id="message" name="message" rows="4" required></textarea><br>
                      <input type="submit" value="Submit">
                  </form>
              </body>
              </html>
              EOM
              cat <<EOM > /var/www/html/submit.php
              <?php
              require 'vendor/autoload.php';
              use Aws\\Sns\\SnsClient;
              use Aws\\Exception\\AwsException;
              if (\$_SERVER["REQUEST_METHOD"] == "POST") {
                  \$name = \$_POST["name"];
                  \$email = \$_POST["email"];
                  \$message = \$_POST["message"];
                  \$snsTopicArn = 'arn:aws:sns:us-east-1:472465447779:misns';
                  \$snsClient = new SnsClient([
                      'version' => 'latest',
                      'region' => 'us-east-1'
                  ]);
                  \$messageToSend = json_encode([
                      'email' => \$email,
                      'name' => \$name,
                      'message' => \$message
                  ]);
                  try {
                      \$snsClient->publish([
                          'TopicArn' => \$snsTopicArn,
                          'Message' => \$messageToSend
                      ]);
                      echo "Message sent successfully.";
                  } catch (AwsException \$e) {
                      echo "Error sending message: " . \$e->getMessage();
                  }
              } else {
                  http_response_code(405);
                  echo "Method Not Allowed";
              }
              ?>
              EOM
              cat <<EOM > /var/www/html/info.php
              <?php phpinfo(); ?>
              EOM
              echo "AddType application/x-httpd-php .php" >> /etc/httpd/conf/httpd.conf
              service httpd restart
              EOF

  tags = {
    Name = "WebServer"
  }
}

resource "aws_lambda_function" "process_form" {
  function_name     = var.lambda_function_name
  role              = "arn:aws:iam::472465447779:role/LabRole"
  handler           = "lambda_function.lambda_handler"
  runtime           = "python3.12"

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  
  timeout = 60

}


resource "aws_sns_topic" "sns_topic" {
  name = "misns"
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.process_form.arn
}
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = "salvador.flores@tajamar365.com"
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.example.arn
}