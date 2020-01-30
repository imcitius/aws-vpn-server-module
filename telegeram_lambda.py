import os
import json
from urllib import request, parse, error

def lambda_handler(event, context):
    url = 'https://api.telegram.org/bot%s/sendMessage' % os.environ['TOKEN']
    message = event['Records'][0]['Sns']['Message']
    # parsed_message = """
    # Alarm Name: """ + message.AlarmName + """\n""" + message.OldStateValue + 
    # """->""" + message.OldStateValue + """ on host """ + message.Trigger.Dimensions.value
    data = parse.urlencode({'chat_id': os.environ['CHAT_ID'],'text': message})

    try:
        # Send the SNS message (notification) to Telegram
        request.urlopen(url, data.encode('utf-8'))
    except error.HTTPError as e:
        print('Failed to send the SNS message below:\n%s' % message)
        response = json.load(e)
        if 'description' in response:
            print(response['description'])
        raise e
