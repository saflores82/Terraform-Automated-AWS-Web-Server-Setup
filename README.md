# Terraform-Automated-AWS-Web-Server-Setup

Automating Infrastructure Deployment and Web Server Configuration on AWS 

Creo un Cloud9 y dentro:

1-Install Terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

2-modificar el archivo ssh.pem con las credenciales del laboratorio de AWS

3-Incluir el nuevo hook de slack en el codigo PHP de la lambda_function.py

4-Después del terraform apply

5-En el main.tf linea 88, modificar el ARN del topic SNS en el php

\$snsTopicArn = 'arn:aws:sns:us-east-1:498399109096:misns';

6-En el main.tf linea 127 cambio el ARN de LaRole, en el recurso (

resource "aws_lambda_function" "process_form"

role  = "arn:aws:iam::498399109096:role/LabRole")

7-voy a la instancia ec2/security/LabInstanceRole

8-Voy a IAM y por falta de permisos debo crear a mano los Roles

/LaRole/Attached - AWSLambda_FullAccess / AWSSNSFullAccess

9-Ultimo paso: Relleno el formulario y presiono el boton submit

mediante un web hook de slack me comunico al enviar el mensaje
