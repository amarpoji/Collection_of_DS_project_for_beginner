# Mini Project: Robust ML Training Pipeline with Logging

## Problem Statement

You are building a **robust ML training pipeline** that gracefully handles common failure modes. Your pipeline will load data, validate it, train a model, and log everything — handling errors at each stage without crashing until absolutely necessary.

## Dataset

Create a synthetic dataset simulating customer churn data with intentional quality issues:

```python
import csv
import random

random.seed(42)

def generate_dataset(path, n=50, corrupt=False):
    fieldnames = ['id', 'age', 'income', 'spend', 'churned']
    with open(path, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for i in range(n):
            row = {
                'id': i,
                'age': str(random.randint(18, 70)),
                'income': str(round(random.uniform(20000, 120000), 2)),
                'spend': str(round(random.uniform(0, 5000), 2)),
                'churned': random.choice(['0', '1'])
            }
            if corrupt and random.random() < 0.1:
                # Introduce corruption
                field = random.choice(['age', 'income', 'spend'])
                row[field] = 'N/A'
            writer.writerow(row)
```

Generate both a clean and a corrupted dataset.

## Requirements

Build a pipeline script that:

1. **Loads CSV data** — with try/except for missing files and empty files
2. **Validates data** — with a custom `DataValidationError` exception for:
   - Missing required columns
   - Non-numeric values in numeric columns
   - Negative values where not expected
   - More than 50% missing data in any column
3. **Cleans data** — attempts to fix issues (convert types, fill missing)
4. **Logs everything** — using the logging module:
   - `INFO` for normal progress (loaded N rows, cleaned M values)
   - `WARNING` for quality issues (high missing rate, type conversion)
   - `ERROR` for failures that skip or fall back
   - `CRITICAL` for pipeline-aborting errors
5. **Saves artifacts** — writes cleaned data to `output/clean_churn.csv`
6. **Generates a summary report** — saved to `output/pipeline_summary.json` with:
   - Input file, rows loaded, rows after cleaning, errors encountered

## Extension (Optional)

- Add a second fallback data source if primary fails
- Log to both console (INFO+) and file (DEBUG+)
- Add timing information for each pipeline stage
- Implement retry logic with exponential backoff for transient errors

## Expected Log Output (Console)

```
INFO: Pipeline started — input: churn_data.csv
INFO: Loaded 50 rows from churn_data.csv
WARNING: Column 'income' has 5 non-numeric values
INFO: Cleaned 3 values — converted to float
INFO: Cleaned dataset: 50 rows, 0 missing
ERROR: Validation failed — negative spend values found
INFO: Pipeline completed — output/clean_churn.csv
```
