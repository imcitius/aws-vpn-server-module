resource "aws_iam_policy" "telegram_lambda" {
  name = "telegram_lambda"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "telegram_lambda" {
  name = "telegram_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "lambda_zip_file_int" {
  type        = "zip"
  output_path = "/tmp/lambda_zip_file_int.zip"
  source {
    content  = file("${path.module}/telegeram_lambda.py")
    filename = "main.py"
  }
}

resource "aws_lambda_function" "telegram_lambda" {
  filename         = data.archive_file.lambda_zip_file_int.output_path
  source_code_hash = data.archive_file.lambda_zip_file_int.output_base64sha256

  function_name = "telegram_alert"
  role          = aws_iam_role.telegram_lambda.arn
  handler       = "main.lambda_handler"

  runtime = "python3.7"

  environment {
    variables = {
      CHAT_IT = var.tg_chat_id
      TOKEN = var.tg_token
    }
  }
}

resource "aws_cloudwatch_log_group" "faceless_alerts" {
  name              = "/aws/lambda/telegram_alert"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.telegram_lambda.name
  policy_arn = aws_iam_policy.telegram_lambda.arn
}
