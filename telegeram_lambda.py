import os
import json
from urllib import request, parse, error

def lambda_handler(event, context):
    url = 'https://api.telegram.org/bot%s/sendMessage' % os.environ['TOKEN']
    queue_message = event['Records'][0]['Sns']['Message']
    message = json.loads(queue_message)
    parsed_message = 'Alert: ' + message['AlarmName'] + ' on host ' + message['Trigger']['Dimensions'][0]['value'] + '\n' + 'Region:' + message['Region'] + '\n' + message['OldStateValue'] + '->' + message['NewStateValue']
    data = parse.urlencode({'chat_id': os.environ['CHAT_ID'],'text': parsed_message})


    try:
        # Send the SNS message (notification) to Telegram
        request.urlopen(url, data.encode('utf-8'))
    except error.HTTPError as e:
        print('Failed to send the SNS message below:\n%s' % message)
        response = json.load(e)
        if 'description' in response:
            print(response['description'])
        raise e
