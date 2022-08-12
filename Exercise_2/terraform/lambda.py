import random
import string

def hello_world(event, context):
  message = 'Hello {} !'.format(event['name'])
  randStr =  ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(10))
  return {
    'statusCode': 200,
    'body': message +' this is your identity: ' + randStr
  }