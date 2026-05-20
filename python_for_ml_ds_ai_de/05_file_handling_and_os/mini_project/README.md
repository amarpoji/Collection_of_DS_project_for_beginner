# Mini Project: CSV-to-JSONL Data Pipeline

## Problem Statement

You are building a **data ingestion pipeline** for an ML project. Your raw data comes as CSV files (tabular), but your ML framework requires JSONL format (one JSON object per line). You need to build a converter that handles this transformation with proper error handling, metadata tracking, and file organization.

## Dataset

Create a synthetic CSV dataset representing customer churn data:

```python
import csv
import random

random.seed(42)

def generate_churn_data(n=100):
    fieldnames = ['customer_id', 'age', 'monthly_spend', 'tenure_months',
                  'support_calls', 'churned']
    with open('churn_raw.csv', 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for i in range(n):
            writer.writerow({
                'customer_id': i,
                'age': random.randint(18, 70),
                'monthly_spend': round(random.uniform(10, 200), 2),
                'tenure_months': random.randint(1, 72),
                'support_calls': random.randint(0, 10),
                'churned': random.choice(['yes', 'no'])
            })
```

## Requirements

Build a script that:

1. **Reads** `churn_raw.csv` using `csv.DictReader`
2. **Transforms** each row into a JSON object with all values properly typed (int/float, not strings)
3. **Creates** the directory structure: `processed_data/` and `logs/`
4. **Writes** the transformed data to `processed_data/churn_clean.jsonl`
5. **Generates** a metadata JSON file at `processed_data/metadata.json` with:
   - Source filename, row count, date processed, column names and types
6. **Creates** a log file at `logs/pipeline.log` with timestamps for each step
7. **Validates** — check that the output JSONL has the same number of rows as the input CSV

## Extension (Optional)

- Add a `--sample N` argument that only processes the first N rows
- Add error handling for missing columns
- Generate a statistics summary (mean age, mean spend, churn rate)
- Support multiple input CSV files via glob pattern

## Expected Output

```
=== Pipeline Run Summary ===
Input file: churn_raw.csv
Rows read: 100
Rows written: 100
Output: processed_data/churn_clean.jsonl
Metadata: processed_data/metadata.json
Log: logs/pipeline.log
```
