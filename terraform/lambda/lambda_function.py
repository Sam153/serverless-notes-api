import json
import boto3
import os

# Initialize DynamoDB table
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

# Helper function to get HTTP method
def _get_method(event):
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
            body = body.strip()
            if body:
                body = json.loads(body)
            else:
                body = {}
        elif body is None:
            body = {}

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
