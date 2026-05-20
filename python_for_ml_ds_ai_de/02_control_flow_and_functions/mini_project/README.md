# Mini Project: ML Pipeline Builder

## Problem Statement

You're building an ML pipeline for a customer churn prediction system. The pipeline needs to be flexible — different projects need different preprocessing steps, different models, and different evaluation metrics. Your task is to build a **Pipeline Builder** that chains together configurable steps using functions, iterators, and generators.

## Dataset Description

Use a synthetic customer dataset with these columns:

| Column | Type | Description |
|--------|------|-------------|
| `customer_id` | int | Unique identifier |
| `age` | float | Age (25-70) |
| `income` | float | Annual income (30k-200k) |
| `tenure_months` | int | Months as customer (1-60) |
| `num_transactions` | int | Monthly transactions (0-50) |
| `avg_transaction_value` | float | Average transaction ($) |
| `is_active` | int | 0/1 - recently active |
| `support_calls` | int | Number of support calls (0-20) |
| `churned` | int | **Target**: 0 = stayed, 1 = churned |

Generate 2000 synthetic samples.

## Deliverables

1. **`pipeline_builder.py`** — Pipeline framework with:
   - `Pipeline` class that chains transformation functions
   - `add_step(name, func)` method to add steps
   - `run(data)` method that iterates through steps
   - Generator-based lazy evaluation option
   - Support for `**kwargs` in steps for configuration

2. **`preprocessing.py`** — Preprocessing functions:
   - `filter_outliers(data, columns, z_thresh=3.0)` using list comprehension + filter
   - `normalize(data, columns)` using min-max scaling via list comprehension
   - `one_hot_encode(data, column)` encoding function
   - `train_test_split(data, test_size, seed)` using random shuffle

3. **`evaluation.py`** — Evaluation functions:
   - `accuracy(y_true, y_pred)`
   - `precision(y_true, y_pred)`
   - `recall(y_true, y_pred)`
   - `f1_score(y_true, y_pred)`
   - `classification_report(y_true, y_pred)` — uses zip and conditional logic

4. **`run_pipeline.py`** — Main script that:
   - Generates synthetic data
   - Creates a pipeline with preprocessing steps
   - Splits data
   - Trains a simple rule-based classifier (no sklearn required)
   - Evaluates and prints a formatted report
   - Uses `enumerate()`, `zip()`, list comprehensions, and conditional logic throughout

5. **`requirements.txt`** — numpy, pandas

6. **`README.md`** — Pipeline usage documentation with examples

## Evaluation Criteria

| Criteria | Points | Description |
|----------|--------|-------------|
| Functionality | 30% | Pipeline runs end-to-end, produces correct metrics |
| Code Quality | 25% | Type hints, docstrings, PEP8, modern Python |
| Design | 20% | Clean pipeline architecture, composable steps |
| Generators | 15% | Efficient data iteration patterns |
| Documentation | 10% | Clear README with examples |

## Hints

- Use `functools.partial` to create parameterized pipeline steps
- Implement `batch_iterator` as a generator for processing large datasets
- For the rule-based classifier: use if/elif logic on key features (e.g., churn if support_calls > 5 AND tenure < 12)
- Use `*args` and `**kwargs` in pipeline steps for flexibility
- Preprocessing functions should return new dicts, not modify in-place
- Use `enumerate()` to track pipeline step progress
- Use `zip()` to pair y_true with y_pred for metric computation
- For cross-validation, implement a K-fold split generator using `yield`
