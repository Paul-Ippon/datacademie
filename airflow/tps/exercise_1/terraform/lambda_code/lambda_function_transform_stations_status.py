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
        fieldnames = ['station_id', 'is_installed', 'is_renting', 'is_returning', 'last_reported', 'num_bikes_available', 'num_docks_available', 'ebike_available', 'mechanical_available', 'lastUpdatedOther', 'ttl']

        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

        writer.writeheader()

        # Écrire chaque station en tant que ligne de données dans le fichier CSV
        for station in stations:
            writer.writerow({
                'station_id': station['station_id'],
                'is_installed': station['is_installed'],
                'is_renting': station['is_renting'],
                'is_returning': station['is_returning'],
                'last_reported': station['last_reported'],
                'num_bikes_available': station['num_bikes_available'],
                'num_docks_available': station['num_docks_available'],
                'ebike_available': station['num_bikes_available_types'][1]['ebike'],
                'mechanical_available': station['num_bikes_available_types'][0]['mechanical'],
                'lastUpdatedOther': json_content['lastUpdatedOther'],
                'ttl': json_content['ttl']
            })

    s3.upload_file('/tmp/data.csv', destination['bucket'], destination['key'])

    return True