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

resource "aws_lambda_function" "telegram_lambda" {
  filename         = data.archive_file.lambda_zip_file_int.output_path
  source_code_hash = data.archive_file.lambda_zip_file_int.output_base64sha256

  function_name = "telegram_lambda"
  role          = var.aws_iam_role_iam_for_lambda
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
