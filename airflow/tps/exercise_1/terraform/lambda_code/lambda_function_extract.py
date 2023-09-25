import boto3
import urllib.request

def lambda_handler(event, context):
    s3_key = event['s3_key']
    bucket_name = event['bucket_name']
    api_endpoint = event['api_endpoint']

    s3 = boto3.client('s3')

    response = urllib.request.urlopen(urllib.request.Request(url=api_endpoint), timeout=10)

    s3.put_object(Bucket=bucket_name, Key=s3_key, Body=bytes(response.read()))

    return True