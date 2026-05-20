# Mini Project: ML Feature Pipeline with Airflow

**Module 18 — Data Engineering Basics**

## Objective

Build an automated data pipeline that extracts data from an API, transforms it into ML features, validates data quality, stores the features in Parquet format, and uploads to cloud storage. Use Apache Airflow for orchestration.

## Dataset

**OpenWeatherMap API** (free tier) — fetch weather data for multiple cities. Transform raw weather data into features for a predictive model (e.g., predicting temperature or precipitation).

## Tasks

### Part 1: API Data Extraction (3 hours)

1. Sign up for a free OpenWeatherMap API key (or use any free weather API)
2. Create a Python script that:
   - Fetches current weather for 5+ cities
   - Handles rate limiting (60 calls/min free tier)
   - Implements error handling with retry logic
   - Returns structured data (city, temp, humidity, pressure, wind speed, etc.)
3. Save raw data as JSON files with timestamps

### Part 2: Data Transformation (3 hours)

1. Create a transformation script that:
   - Reads raw JSON data
   - Converts temperatures from Kelvin to Celsius/Fahrenheit
   - Creates derived features (temp_humidity_index, wind_chill, etc.)
   - Normalizes numerical features
   - Adds datetime features (hour, day_of_week, month, season)
   - One-hot encodes categorical variables (weather condition, city)
2. Save transformed data as Parquet with snappy compression

### Part 3: Data Quality Checks (3 hours)

1. Create a Great Expectations expectation suite:
   - No null values in key columns
   - Temperature within reasonable range (-50 to 50 C)
   - Humidity between 0 and 100
   - Wind speed >= 0
   - All expected columns present
2. Run validation on the transformed data
3. Log validation results and fail pipeline if checks don't pass

### Part 4: Cloud Storage Integration (2 hours)

1. Use boto3 with moto mocking to simulate S3 storage:
   - Create a bucket for ML features
   - Upload Parquet files with versioned keys
   - Implement a function to list available feature files
   - Add file metadata tags (date, feature_version, quality_score)

### Part 5: Airflow DAG (5 hours)

1. Create an Airflow DAG `ml_feature_pipeline`:
   - Schedule: daily at 2 AM
   - Task 1: `extract_weather_data` — fetch from API
   - Task 2: `transform_to_features` — engineer features
   - Task 3: `validate_data_quality` — Great Expectations checks
   - Task 4: `upload_to_s3` — store Parquet files
   - Task 5: `log_pipeline_metrics` — record run stats
2. Add proper dependencies between tasks
3. Configure retries and alerting
4. Use TaskFlow API (decorators) where possible

### Part 6: Pipeline Monitoring (2 hours)

1. Add logging throughout the pipeline
2. Create a simple alerting mechanism (print to console, but design for email/Slack)
3. Track row counts, processing times, and failure rates
4. Create a summary report after each run

### Part 7: Test the Pipeline (2 hours)

1. Write unit tests for each transformation function
2. Write integration tests for the full pipeline with mocked API
3. Verify data quality checks catch invalid data
4. Test retry logic on simulated failures

## Deliverables

1. **weather_api.py** — API extraction with rate limiting
2. **feature_engineering.py** — transformation logic
3. **data_quality.py** — Great Expectations validation
4. **s3_storage.py** — S3 upload/download (with moto)
5. **ml_feature_pipeline.py** — Airflow DAG
6. **test_pipeline.py** — unit and integration tests
7. **requirements.txt** — dependencies
8. **README.md** — setup and usage

## Evaluation Criteria

| Criteria | Weight |
|----------|--------|
| API extraction with rate limiting | 15% |
| Feature engineering quality | 20% |
| Data quality checks | 15% |
| Airflow DAG design | 25% |
| Testing coverage | 15% |
| Documentation and organization | 10% |

## Resources

- OpenWeatherMap API: https://openweathermap.org/api
- Apache Airflow docs: https://airflow.apache.org/docs/
- Great Expectations docs: https://docs.greatexpectations.io/
- boto3 docs: https://boto3.amazonaws.com/v1/documentation/api/latest/
- Parquet: https://parquet.apache.org/

## Stretch Goals

- Deploy Airflow to Docker using docker-compose
- Add data lineage tracking with OpenLineage
- Implement incremental extraction (only new data)
- Add a Slack/email notification on pipeline failure
- Create a data catalog for the feature store
- Implement feature backfill for historical data
