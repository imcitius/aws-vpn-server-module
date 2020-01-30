resource "aws_sns_topic" "telegram_alerts" {
  name = "TelegramAlerts"
}

resource "aws_sns_topic_subscription" "telegram_alerts" {
  topic_arn = aws_sns_topic.telegram_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.telegram_lambda.arn
}

data "archive_file" "lambda_zip_file_int" {
  type        = "zip"
  output_path = "/tmp/lambda_zip_file_int.zip"
  source {
    content  = file("${path.module}/telegeram_lambda.py")
    filename = "main.py"
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
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

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_lambda_function" "telegram_lambda" {
  filename         = data.archive_file.lambda_zip_file_int.output_path
  source_code_hash = data.archive_file.lambda_zip_file_int.output_base64sha256

  function_name = "telegram_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main.lambda_handler"

  runtime = "python3.8"

  environment {
    variables = {
      CHAT_ID = var.tg_chat_id
      TOKEN = var.tg_token
    }
  }
}

resource "aws_lambda_permission" "with_sns" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.telegram_lambda.arn
    principal = "sns.amazonaws.com"
    source_arn = aws_sns_topic.telegram_alerts.arn
}