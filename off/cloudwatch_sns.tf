resource "aws_sns_topic" "telegram_alerts" {
  name = "telegram_alerts"
}

resource "aws_sns_topic_subscription" "telegram_alerts" {
  topic_arn = aws_sns_topic.telegram_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.telegram_lambda.arn
}