# Module 18: Data Engineering Basics

**Duration: 20 hours**

## Overview

This module covers the fundamentals of data engineering for ML pipelines. You will learn ETL vs ELT patterns, working with REST APIs, data serialization formats (Parquet, Avro, Arrow), Apache Airflow for orchestration, data quality checks with Great Expectations, cloud storage interactions, and pipeline monitoring. The ML focus is building reliable data pipelines that feed ML models.

## Learning Objectives

By the end of this module, you will be able to:
- Understand and implement ETL and ELT patterns
- Extract data from REST APIs with proper rate limiting
- Work with Parquet, Avro, and Arrow data formats
- Create and run Apache Airflow DAGs
- Implement data quality checks with Great Expectations
- Interact with S3-compatible storage using boto3
- Monitor and troubleshoot data pipelines

## Prerequisites

- Python Fundamentals (Module 1-2)
- Pandas (Module 9)
- File Handling (Module 5)

## Topics

### 1. ETL vs ELT Patterns (2 hours)
- Extract, Transform, Load concepts
- When to use ETL vs ELT
- Batch vs streaming data pipelines
- Pipeline design patterns for ML features

### 2. Working with APIs (2 hours)
- requests library fundamentals
- GET/POST requests with authentication
- Pagination handling
- Rate limiting and exponential backoff
- Webhook basics

### 3. Data Formats (3 hours)
- Parquet: columnar storage, compression, schema
- Avro: row-based, schema evolution
- Arrow: in-memory columnar format
- When to use each format
- pandas integration with each format

### 4. Apache Airflow Concepts (4 hours)
- Airflow architecture overview
- DAGs, tasks, and operators
- Task dependencies and execution order
- Sensors for external events
- Scheduling and backfill

### 5. Basic Airflow DAG Creation (3 hours)
- Creating your first DAG
- PythonOperator and BashOperator
- Passing data between tasks (XCom)
- TaskFlow API (decorators)
- DAG parameters and default arguments

### 6. Data Quality Checks (3 hours)
- Great Expectations overview
- Expectation types (column, table, batch)
- Creating expectation suites
- Running validation
- Integrating quality checks into pipelines

### 7. Cloud Storage with boto3 (2 hours)
- S3 concepts: buckets, objects, keys
- Uploading and downloading files
- Working with mock S3 (moto)
- Presigned URLs

### 8. Pipeline Monitoring (1 hour)
- Logging in data pipelines
- Alerting on failures
- Pipeline metrics and SLAs
- Data lineage basics

## ML Focus
- Building data pipelines that produce ML training features
- Data quality checks for ML datasets
- Reliable data extraction from external APIs
- Efficient data storage formats for ML workloads
- Orchestrating ML data pipelines with Airflow
