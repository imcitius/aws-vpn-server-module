locals {

    dashboard = {
        "widgets": [
            {
                "type":"metric",
                "x":0,
                "y":0,
                "width":12,
                "height":6,
                "properties":{
                    "metrics": [
                        for instance in aws_instance.vpn :
                        ["AWS/EC2","CPUUtilization","InstanceId",instance.id]
                    ],
                    "period":300,
                    "stat":"Average",
                    "region":"${var.aws_region}",
                    "title":"EC2 Instance CPU"
                }
            },
            {
                "type":"metric",
                "x":0,
                "y":0,
                "width":12,
                "height":6,
                "properties":{
                    "metrics": [
                        for instance in aws_instance.vpn :
                        ["AWS/EC2","NetworkIn","InstanceId",instance.id]
                    ],
                    "period":300,
                    "stat":"Average",
                    "region":"${var.aws_region}",
                    "title":"EC2 Instance NetIn"
                }
            },
            {
                "type":"metric",
                "x":0,
                "y":0,
                "width":12,
                "height":6,
                "properties":{
                    "metrics": [
                        for instance in aws_instance.vpn :
                        ["AWS/EC2","NetworkOut","InstanceId",instance.id]
                    ],
                    "period":300,
                    "stat":"Average",
                    "region":"${var.aws_region}",
                    "title":"EC2 Instance NetOut"
                }
            }
        ]
    }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "VPN-servers-${var.aws_region}"

  dashboard_body = jsonencode(local.dashboard)

}