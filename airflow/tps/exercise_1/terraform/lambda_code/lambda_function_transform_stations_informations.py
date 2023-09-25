import json
import csv
import boto3

def lambda_handler(event, context):
    source = event['source']
    destination = event['destination']

    s3 = boto3.client('s3')

    data = s3.get_object(Bucket=source['bucket'], Key=source['key'])
    file_content = data['Body'].read().decode('utf-8')

    json_content = json.loads(file_content)

    stations = json_content['data']['stations']

    with open('/tmp/data.csv', mode='w+') as csv_file:
        fieldnames = ['station_id', 'stationCode', 'name', 'capacity', 'rental_methods', 'lat', 'lon', 'lastUpdatedOther', 'ttl']
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()

        # Écrire chaque station en tant que ligne de données dans le fichier CSV
        for station in stations:
            writer.writerow({
                'station_id': station['station_id'],
                'stationCode': station['stationCode'],
                'name': station['name'],
                'capacity': station['capacity'],
                'rental_methods': ','.join(station['rental_methods']) if 'rental_methods' in station else None,
                'lat': station['lat'],
                'lon': station['lon'],
                'lastUpdatedOther': json_content['lastUpdatedOther'],
                'ttl': json_content['ttl']
            })

    s3.upload_file('/tmp/data.csv', destination['bucket'], destination['key'])

    return True