resource "aws_cloudwatch_metric_alarm" "cpu" {

  count = var.servers_count

  alarm_name                = "vpn-cpu-alarm-${count.index}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  // check `evaluation_periods` count of `period` seconds
  period                    = "60"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [aws_sns_topic.telegram_alerts.arn]
  ok_actions                = [aws_sns_topic.telegram_alerts.arn]
  insufficient_data_actions = []
  actions_enabled           = true
  treat_missing_data        = "ignore"

  dimensions = {
    InstanceId = element(aws_instance.vpn.*.id, count.index)
  }
}

resource "aws_cloudwatch_metric_alarm" "network_in" {

  count = var.servers_count

  alarm_name                = "vpn-netin-alarm-${count.index}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = "60"
  evaluation_periods        = "1"
  metric_name               = "NetworkIn"
  namespace                 = "AWS/EC2"
  statistic                 = "Average"
  threshold                 = "10000000"
  alarm_description         = "This metric monitors ec2 network inbound traffic"
  alarm_actions             = [aws_sns_topic.telegram_alerts.arn]
  ok_actions                = [aws_sns_topic.telegram_alerts.arn]
  insufficient_data_actions = []
  actions_enabled           = true
  treat_missing_data        = "ignore"

  dimensions = {
    InstanceId = element(aws_instance.vpn.*.id, count.index)
  }
}


resource "aws_cloudwatch_metric_alarm" "network_out" {

  count = var.servers_count

  alarm_name                = "vpn-netout-alarm-${count.index}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = "60"
  evaluation_periods        = "1"
  metric_name               = "NetworkOut"
  namespace                 = "AWS/EC2"
  statistic                 = "Average"
  threshold                 = "10000000"
  alarm_description         = "This metric monitors ec2 network outbound traffic"
  alarm_actions             = [aws_sns_topic.telegram_alerts.arn]
  ok_actions                = [aws_sns_topic.telegram_alerts.arn]
  insufficient_data_actions = []
  actions_enabled           = true
  treat_missing_data        = "ignore"

  dimensions = {
    InstanceId = element(aws_instance.vpn.*.id, count.index)
  }
}


resource "aws_cloudwatch_metric_alarm" "health" {

  count = var.servers_count

  alarm_name                = "vpn-health-alarm-${count.index}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = "60"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [aws_sns_topic.telegram_alerts.arn]
  ok_actions                = [aws_sns_topic.telegram_alerts.arn]
  insufficient_data_actions = []
  actions_enabled           = true
  treat_missing_data        = "ignore"

  dimensions = {
    InstanceId = element(aws_instance.vpn.*.id, count.index)
  }
}
