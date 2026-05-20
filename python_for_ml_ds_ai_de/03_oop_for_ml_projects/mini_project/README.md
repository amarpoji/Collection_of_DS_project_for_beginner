# Mini Project: Building a Custom ML Model Zoo

## Problem Statement

You are building a **custom ML Model Zoo** — a collection of model classes that follow a unified interface. Your goal is to create a small framework where new models can be added without changing the training/evaluation code.

This mirrors how scikit-learn, XGBoost, and LightGBM all implement the same `fit()`/`predict()` API.

## Dataset

Use synthetic data generated inline (no external files needed):

```python
import random
random.seed(42)

# 100 samples, 3 features, binary classification
X = [[random.random() for _ in range(3)] for _ in range(100)]
y = [1 if sum(x) > 1.5 else 0 for x in X]
```

Or use the Iris dataset from sklearn if available:
```python
from sklearn.datasets import load_iris
data = load_iris()
X = data.data.tolist()
y = data.target.tolist()
```

## Deliverables

Create a single Python file `model_zoo.py` containing:

### 1. Abstract Base Class: `BaseEstimator`
- Abstract methods: `fit(X, y)`, `predict(X)`
- Concrete method: `score(X, y)` that computes accuracy

### 2. Concrete Model: `DummyClassifier`
- Inherits from `BaseEstimator`
- `fit()` stores the most common class label
- `predict()` returns that label for all samples

### 3. Concrete Model: `LogisticRegressionCustom`
- Inherits from `BaseEstimator`
- Simple gradient descent implementation (10 iterations)
- Stores `self.weights` and `self.bias`
- Sigmoid activation, binary classification

### 4. Concrete Model: `KNNClassifier`
- Inherits from `BaseEstimator`
- Stores all training data
- Predicts by majority vote of k nearest neighbors
- Configurable `k` parameter

### 5. `ModelZoo` Class (Composition, not inheritance)
- `register(name, model)` — add a model with a name
- `train_all(X, y)` — train all registered models
- `evaluate_all(X, y)` — evaluate all models and print results table
- `best_model()` — returns the model with highest score
- Implements `__len__`, `__getitem__`, `__str__`

### 6. `@dataclass` for `ExperimentConfig`
- Fields: `model_name`, `learning_rate`, `k_neighbors`, `num_iterations`, `test_size`
- A `run()` method that creates, trains, and evaluates the configured model

## Evaluation Criteria

| Criteria | Points |
|----------|--------|
| All classes follow correct OOP principles | 20 |
| `BaseEstimator` uses ABC correctly | 10 |
| All three models implemented correctly | 20 |
| `ModelZoo` uses composition correctly | 15 |
| `@dataclass` ExperimentConfig works | 10 |
| Polymorphism used (loop over models calling same methods) | 10 |
| Code runs without errors | 10 |
| Docstrings and type hints present | 5 |

## Hints & Tips

1. **Start with `BaseEstimator`** — define the interface first, then build models
2. **Test each model independently** before adding to the zoo
3. **Keep the gradient descent simple** — just 10 iterations, fixed learning rate
4. **Use `super().__init__()`** in model `__init__` methods
5. **The `ModelZoo` should NOT inherit from `BaseEstimator`** — it composes models
6. **For KNN distance**, use Euclidean distance: `sqrt(sum((a[i] - b[i])**2))`
7. **Accuracy formula**: `sum(pred == true) / len(true)`
8. **Print a formatted table** for `evaluate_all()`:
```
Model Zoo Evaluation
--------------------
DummyClassifier      : 0.520
LogisticRegressionCustom: 0.680
KNNClassifier       : 0.740
```

## Extension Ideas (Bonus)

- Add `RandomForestCustom` that trains multiple decision stumps
- Add `save_model(path)` and `load_model(path)` methods
- Make `ModelZoo` iterable with `__iter__`
- Add cross-validation support to `ExperimentConfig`
- Visualize model performance with ASCII bar chart
