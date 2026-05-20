# Mini Project: ML Project as a Python Package

## Problem Statement

You are building a **structured ML project** as a proper Python package. The package implements a complete ML workflow — data loading, preprocessing, model training, and prediction — organized into modules with proper imports, `__init__.py` files, and a `setup.py` for installation.

## Dataset

Create a synthetic house price dataset as part of the package:

```python
# ml_package/data/generate.py
import random

random.seed(42)

def generate_house_data(n=100):
    """Generate synthetic house price data."""
    data = []
    for i in range(n):
        house = {
            'sqft': random.randint(800, 4000),
            'bedrooms': random.randint(1, 5),
            'bathrooms': random.randint(1, 4),
            'year_built': random.randint(1950, 2023),
            'price': 0
        }
        # Price as a simple linear function of features + noise
        house['price'] = (
            house['sqft'] * 150
            + house['bedrooms'] * 10000
            + house['bathrooms'] * 15000
            + random.randint(-20000, 20000)
        )
        data.append(house)
    return data
```

## Package Structure

Create this package:

```
house_price_predictor/
  __init__.py                    # Package init, version
  data/
    __init__.py
    generate.py                  # generate_house_data()
    loader.py                    # load_data(), train_test_split()
  model/
    __init__.py
    train.py                     # train_linear_model()
    predict.py                   # predict_price()
  evaluate/
    __init__.py
    metrics.py                   # rmse(), mae()
  config.py                      # DEFAULT_CONFIG dict
  __main__.py                    # python -m house_price_predictor
  setup.py                       # Package metadata
  requirements.txt               # Dependencies
```

## Requirements

1. **Package init** — `__init__.py` should export key functions at the top level
2. **Data module** — generates synthetic data, splits into train/test
3. **Model module** — trains a simple linear model (simulate with formula, no scikit-learn needed), makes predictions
4. **Evaluate module** — computes RMSE and MAE
5. **Config** — dictionary with default hyperparameters (learning_rate, test_size, random_seed)
6. **`__main__.py`** — allows `python -m house_price_predictor` to run the full pipeline
7. **`setup.py`** — proper metadata, `find_packages()`, entry_points for CLI
8. **`requirements.txt`** — at minimum numpy

## Extension (Optional)

- Add type hints to all functions
- Create a console script `house-price-predict` via entry_points
- Add argument parsing (argparse) for data size, test size
- Write a README for the package

## Expected Output

When running `python -m house_price_predictor`:

```
House Price Predictor v0.1.0
============================
Generating 100 samples...
Loaded 100 samples
Train: 80 samples, Test: 20 samples
Training model...
Predictions made: 20
RMSE: $12,345.67
MAE: $9,876.54
```
