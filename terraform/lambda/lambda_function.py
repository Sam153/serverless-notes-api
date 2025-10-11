import json
if 'httpMethod' in event:
return event['httpMethod']
rc = event.get('requestContext', {})
if isinstance(rc, dict):
http = rc.get('http') or rc.get('httpMethod')
if isinstance(http, dict) and 'method' in http:
return http['method']
return None




def lambda_handler(event, context):
method = _get_method(event)


if method == 'POST':
body = event.get('body')
if isinstance(body, str):
body = json.loads(body)
item = {
'id': str(body.get('id')),
'note': body.get('note')
}
table.put_item(Item=item)
return {
'statusCode': 201,
'body': json.dumps({'message': 'Note created', 'item': item})
}


if method == 'GET':
qs = event.get('queryStringParameters') or {}
note_id = qs.get('id') if isinstance(qs, dict) else None
if note_id:
resp = table.get_item(Key={'id': note_id})
return {
'statusCode': 200,
'body': json.dumps(resp.get('Item', {}))
}
resp = table.scan()
return {
'statusCode': 200,
'body': json.dumps(resp.get('Items', []))
}


return {
'statusCode': 400,
'body': json.dumps({'message': 'Unsupported method'})
}