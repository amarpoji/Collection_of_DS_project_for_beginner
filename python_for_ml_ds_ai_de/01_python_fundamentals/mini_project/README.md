# Mini Project: Synthetic Data Generator & Explorer

## Problem Statement

You work for a startup building a customer analytics platform. Before you have real customer data, you need to build a **synthetic data generator** that creates realistic-looking datasets. Your tool should:

1. Generate structured data with multiple data types (int, float, bool, string, categorical)
2. Provide summary statistics
3. Export data to CSV
4. Be reusable and configurable

## Dataset Description

Your generator should create synthetic datasets with the following columns:

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| `customer_id` | int | Unique identifier | Auto-incrementing |
| `age` | int | Customer age | 18-90 |
| `income` | float | Annual income | 20,000 - 200,000 |
| `is_employed` | bool | Employment status | Random True/False |
| `city` | str | City name | From a predefined list |
| `score` | float | Credit score | 300-850, normally distributed |
| `signup_date` | str | Date joined | Random dates in 2023-2024 |

Generate 1000 samples with realistic distributions (not purely uniform).

## Deliverables

1. **`synthetic_data_generator.py`** — Main module with:
   - `SyntheticDataset` class (configurable column specs, n_samples, random seed)
   - `generate()` method that creates the dataset
   - `summary()` method showing statistics (count, mean, std, min, max for numeric; value counts for categorical)
   - `to_csv(path: str)` method to export
   - `plot_histograms()` method using matplotlib (bonus)
   - Type hints, docstrings, PEP8 compliance

2. **`explore_dataset.py`** — Script that:
   - Generates the synthetic dataset
   - Prints summary statistics
   - Demonstrates list/dict/string operations from this module
   - Saves to CSV

3. **`requirements.txt`** — numpy, pandas, matplotlib, seaborn

4. **`output/`** directory — Contains the generated CSV file

## Evaluation Criteria

| Criteria | Points | Description |
|----------|--------|-------------|
| Correctness | 30% | Data types match specs, distributions are realistic |
| Code Quality | 25% | Type hints, docstrings, clean OOP design |
| Features | 20% | Summary, export, configurable generation |
| Statistics | 15% | Summary stats are accurate and well-formatted |
| Documentation | 10% | Clear README with usage examples |

## Hints

- Use `random.gauss()` or `numpy.random.normal()` for realistic distributions
- For age: use `random.randint(18, 90)` — uniform is fine
- For income: use a log-normal distribution `np.random.lognormal(mean=11.5, sigma=0.5)` — income is log-normally distributed in reality
- For credit score: use `np.random.normal(loc=650, scale=50)` and clip to [300, 850]
- Store the data internally as a list of dicts (pure Python) or as a numpy array
- Use `dataclasses` for the column specification
- For signup dates, use `datetime` and `timedelta` to generate random dates
- Add a `seed` parameter for reproducibility
