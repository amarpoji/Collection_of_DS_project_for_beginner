# Mini Project: Testing an ML Pipeline

**Goal**: Write comprehensive tests for a complete ML pipeline including data loading, preprocessing, feature engineering, model training, and inference.

## Scenario

You work on a team building a housing price prediction system. Your colleague has written a pipeline in `ml_pipeline.py`, but it has no tests. Your job is to write tests that catch bugs, ensure correctness, and enable confident refactoring.

## Project Structure

```
mini_project/
  ml_pipeline.py       # The pipeline to test (provided below)
  tests/
    test_data.py       # Tests for data loading & validation
    test_features.py   # Tests for feature engineering
    test_model.py      # Tests for model training & inference
    test_pipeline.py   # Integration tests for the full pipeline
  conftest.py          # Shared fixtures
  requirements.txt     # Test dependencies
```

## Pipeline to Test (`ml_pipeline.py`)

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
import joblib

class DataLoader:
    def load_csv(self, path):
        return pd.read_csv(path)

    def validate_data(self, df):
        required_cols = ["sqft", "bedrooms", "bathrooms", "price"]
        for col in required_cols:
            if col not in df.columns:
                raise ValueError(f"Missing column: {col}")
        if df.isnull().any().any():
            raise ValueError("Data contains missing values")
        return True

class FeatureEngineer:
    def create_features(self, df):
        df = df.copy()
        df["rooms_per_bath"] = df["bedrooms"] / df["bathrooms"]
        df["price_per_sqft"] = df["price"] / df["sqft"]
        return df

    def split_and_scale(self, df, target_col="price"):
        X = df.drop(columns=[target_col])
        y = df[target_col]
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        scaler = StandardScaler()
        X_train_scaled = scaler.fit_transform(X_train)
        X_test_scaled = scaler.transform(X_test)
        return X_train_scaled, X_test_scaled, y_train, y_test, scaler

class ModelTrainer:
    def train(self, X_train, y_train):
        model = RandomForestRegressor(n_estimators=100, random_state=42)
        model.fit(X_train, y_train)
        return model

    def evaluate(self, model, X_test, y_test):
        preds = model.predict(X_test)
        mse = mean_squared_error(y_test, preds)
        rmse = np.sqrt(mse)
        return {"mse": mse, "rmse": rmse}

class Pipeline:
    def __init__(self):
        self.loader = DataLoader()
        self.engineer = FeatureEngineer()
        self.trainer = ModelTrainer()

    def run(self, data_path):
        df = self.loader.load_csv(data_path)
        self.loader.validate_data(df)
        df = self.engineer.create_features(df)
        X_train, X_test, y_train, y_test, scaler = (
            self.engineer.split_and_scale(df)
        )
        model = self.trainer.train(X_train, y_train)
        metrics = self.trainer.evaluate(model, X_test, y_test)
        return model, scaler, metrics
```

## Requirements

### Part 1: Test Data Loading (test_data.py)
- Test that `load_csv` returns a DataFrame
- Test that `validate_data` raises error for missing columns
- Test that `validate_data` raises error for missing values
- Test `validate_data` passes on clean data

### Part 2: Test Feature Engineering (test_features.py)
- Test that `create_features` adds expected columns
- Test that `rooms_per_bath` calculation is correct
- Test that `split_and_scale` returns correct shapes
- Test that scaling produces zero-mean data (approx)

### Part 3: Test Model Training (test_model.py)
- Mock the RandomForestRegressor to test train() without actual training
- Test that train() returns a model object
- Test evaluate() returns expected metrics structure
- Test that predict output shape matches input

### Part 4: Integration Tests (test_pipeline.py)
- Use a fixture to create a temporary CSV with sample data
- Test full pipeline run returns (model, scaler, metrics)
- Test that metrics contain "mse" and "rmse"

### Part 5: Edge Cases & Debugging
- Test with empty DataFrame
- Test with single row of data
- Test with extreme values (very large/small numbers)
- Write a debug log tracing through a failed pipeline run

## Deliverables

1. All test files passing with pytest
2. Minimum 80% code coverage (run `pytest --cov=.`)
3. At least one test using `monkeypatch` to override a slow operation
4. At least one parametrized test
5. A debug log file from a test failure investigation

## Extension Ideas

- Add CI configuration (.github/workflows/test.yml)
- Test with property-based testing (hypothesis library)
- Add performance tests ensuring pipeline completes under time limit
- Test model serialization/deserialization
