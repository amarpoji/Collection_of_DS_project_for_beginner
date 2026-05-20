# Data Engineering Basics — Cheatsheet

## ETL vs ELT

```
ETL: Extract -> Transform -> Load
ELT: Extract -> Load -> Transform

ETL: Traditional, data warehouse-focused
ELT: Modern, data lake-focused, best for big data
```

## Working with APIs (requests)

```python
import requests
import time

# Basic GET
response = requests.get('https://api.example.com/data', 
                        headers={'Authorization': 'Bearer token'})
data = response.json()

# Rate limiting
def rate_limited_request(url, max_calls=10, period=60):
    for i in range(max_calls):
        response = requests.get(url)
        yield response.json()
        time.sleep(period / max_calls)

# Exponential backoff
def fetch_with_retry(url, max_retries=3):
    for attempt in range(max_retries):
        try:
            response = requests.get(url, timeout=5)
            response.raise_for_status()
            return response.json()
        except requests.RequestException:
            if attempt == max_retries - 1:
                raise
            time.sleep(2 ** attempt)  # 1s, 2s, 4s
```

## Data Formats

### Parquet
```python
import pandas as pd

# Write
df.to_parquet('data.parquet', compression='snappy')
# Read
df = pd.read_parquet('data.parquet')
```

### Avro
```python
import fastavro

schema = {
    'type': 'record',
    'name': 'User',
    'fields': [
        {'name': 'name', 'type': 'string'},
        {'name': 'age', 'type': 'int'}
    ]
}
records = [{'name': 'Alice', 'age': 30}]

with open('data.avro', 'wb') as f:
    fastavro.writer(f, schema, records)
```

### Arrow (PyArrow)
```python
import pyarrow as pa
import pyarrow.parquet as pq

table = pa.table({'x': [1, 2, 3], 'y': [4, 5, 6]})
pq.write_table(table, 'data.parquet')
```

## Apache Airflow

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'data_team',
    'depends_on_past': False,
    'email_on_failure': True,
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

dag = DAG(
    'ml_feature_pipeline',
    default_args=default_args,
    description='ML feature engineering pipeline',
    schedule_interval='@daily',
    start_date=datetime(2024, 1, 1),
    catchup=False
)

def extract_data():
    return {'data': 'raw_data'}

def transform_data(ti):
    raw = ti.xcom_pull(task_ids='extract')
    return {'features': 'processed_' + raw['data']}

t1 = PythonOperator(task_id='extract', python_callable=extract_data, dag=dag)
t2 = PythonOperator(task_id='transform', python_callable=transform_data, dag=dag)
t1 >> t2
```

### TaskFlow API (newer)
```python
from airflow.decorators import dag, task

@dag(schedule='@daily', start_date=datetime(2024, 1, 1), catchup=False)
def ml_pipeline():
    @task
    def extract():
        return {'data': 'raw'}
    
    @task
    def transform(raw_data):
        return {'features': raw_data['data'] + '_processed'}
    
    transform(extract())

ml_pipeline()
```

## Great Expectations

```python
import great_expectations as gx

# Create context
context = gx.get_context()

# Create expectation suite
suite = context.add_expectation_suite('my_suite')

# Add expectations
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToNotBeNull(column='age')
)
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToBeBetween(
        column='age', min_value=0, max_value=120
    )
)
suite.add_expectation(
    gx.expectations.ExpectTableRowCountToBeBetween(
        min_value=100, max_value=100000
    )
)
```

## Cloud Storage (boto3 / moto)

```python
import boto3
from moto import mock_s3

@mock_s3
def test_s3():
    client = boto3.client('s3', region_name='us-east-1')
    client.create_bucket(Bucket='my-bucket')
    client.put_object(Bucket='my-bucket', Key='data.csv', Body=b'col1,col2\\n1,2')
    response = client.get_object(Bucket='my-bucket', Key='data.csv')
    print(response['Body'].read().decode('utf-8'))
```

## Pipeline Monitoring

```python
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('pipeline')

def monitor_pipeline(func):
    def wrapper(*args, **kwargs):
        logger.info(f'Starting {func.__name__}')
        try:
            result = func(*args, **kwargs)
            logger.info(f'Finished {func.__name__}')
            return result
        except Exception as e:
            logger.error(f'Failed {func.__name__}: {e}')
            raise
    return wrapper
```

## Common Pitfalls

| Mistake | Fix |
|---------|-----|
| Not handling API rate limits | Implement exponential backoff |
| Using CSV for large datasets | Use Parquet with compression |
| Not retrying failed tasks | Configure retries in Airflow |
| Missing data quality checks | Add Great Expectations validation |
| Hardcoding S3 paths | Use config or environment variables |
| Ignoring schema evolution | Use Avro with schema registry |
| Not monitoring pipelines | Add logging and alerting |
