# Mini Project: NumPy from Scratch — Linear Regression with Gradient Descent

## Problem Statement

You will implement **linear regression using gradient descent** using ONLY NumPy — no scikit-learn, no pandas. This is the foundation of every ML algorithm: vectorized operations, matrix math, and optimization.

You will build:
1. Data generation (synthetic)
2. Train-test split
3. Feature standardization
4. Linear regression with gradient descent (vectorized!)
5. Prediction and evaluation (MSE, RMSE, R-squared)
6. Comparison with the closed-form normal equation

## Dataset

Generate a synthetic dataset with 3 features and a linear target with noise:

```python
import numpy as np

np.random.seed(42)

def generate_data(n_samples=1000, n_features=3, noise=2.0):
    """Generate synthetic linear regression data."""
    # True parameters
    true_theta = np.array([3.0, -1.5, 2.0])
    bias = 5.0

    # Feature matrix
    X = np.random.randn(n_samples, n_features)

    # Target: y = bias + X @ true_theta + noise
    y = bias + X @ true_theta + np.random.randn(n_samples) * noise

    return X, y, true_theta, bias
```

## Requirements

Build a complete linear regression implementation:

### 1. Data Preparation
- Generate 1000 samples with 3 features
- Add a bias column (column of 1s) to X
- Split into train (80%) and test (20%)
- Standardize features (not the bias column!)

### 2. Gradient Descent
Implement gradient descent **fully vectorized** (no loops over samples):
```python
def gradient_descent(X, y, learning_rate=0.01, n_iterations=1000):
    m, n = X.shape
    theta = np.zeros(n)
    loss_history = []

    for iteration in range(n_iterations):
        predictions = X @ theta
        errors = predictions - y
        gradients = (2 / m) * X.T @ errors
        theta = theta - learning_rate * gradients

        loss = np.mean(errors ** 2)
        loss_history.append(loss)

    return theta, loss_history
```

### 3. Evaluation
- Predict on test set
- Compute MSE, RMSE, and R-squared
- R-squared: `1 - (SS_res / SS_tot)` where SS_res = sum of squared residuals, SS_tot = sum of squared deviations from mean

### 4. Compare with Normal Equation
Implement the closed-form solution:
```python
def normal_equation(X, y):
    return np.linalg.inv(X.T @ X) @ X.T @ y
```

### 5. Report
Print a clear comparison table showing:
- True parameters vs learned parameters vs normal equation
- Training time for gradient descent vs normal equation
- MSE, RMSE, R-squared
- Final loss and number of iterations

## Extension (Optional)

- Add learning rate scheduling (reduce LR every N iterations)
- Add L2 regularization (Ridge regression)
- Visualize the loss curve (if matplotlib is available)
- Add early stopping when loss stops decreasing
- Compare with batch vs stochastic gradient descent

## Expected Output

```
=== Linear Regression from Scratch ===

Data: 1000 samples, 3 features
Train: 800 samples | Test: 200 samples

True parameters:     [5.00, 3.00, -1.50, 2.00]
Gradient descent:    [5.12, 2.98, -1.48, 1.99]
Normal equation:     [5.12, 2.98, -1.48, 1.99]

Metrics:
  MSE:    0.0523
  RMSE:   0.2287
  R-squared: 0.9784

Training time:
  Gradient descent: 0.0342 sec
  Normal equation:  0.0011 sec
```
