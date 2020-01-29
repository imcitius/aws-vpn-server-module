resource "aws_cloudwatch_metric_alarm" "cpu" {

  count = var.servers_count

  alarm_name                = "vpn-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [ "${var.aws_sns_topic}" ]

  dimensions = {
    InstanceId = element(aws_instance.vpn.*.public_ip, count.index)
  }
}

resource "aws_cloudwatch_metric_alarm" "network_in" {

  count = var.servers_count

  alarm_name                = "vpn-netin-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "NetworkIn"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "12500000"
  alarm_description         = "This metric monitors ec2 network inbound traffic"
  alarm_actions             = [ "${var.aws_sns_topic}" ]

  dimensions = {
    InstanceId = element(aws_instance.vpn.*.public_ip, count.index)
  }
}


resource "aws_cloudwatch_metric_alarm" "network_out" {

  count = var.servers_count

  alarm_name                = "vpn-netout-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "NetworkOut"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "12500000"
  alarm_description         = "This metric monitors ec2 network outbound traffic"
  alarm_actions             = [ "${var.aws_sns_topic}" ]

  dimensions = {
    InstanceId = element(aws_instance.vpn.*.public_ip, count.index)
  }
}


resource "aws_cloudwatch_metric_alarm" "health" {

  count = var.servers_count

  alarm_name                = "vpn-health-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [ "${var.aws_sns_topic}" ]

  dimensions = {
    InstanceId = element(aws_instance.vpn.*.public_ip, count.index)
  }
}
