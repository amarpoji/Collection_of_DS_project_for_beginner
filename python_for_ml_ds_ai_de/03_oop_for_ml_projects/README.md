# Module 03: Object-Oriented Programming for ML Projects

> **Duration:** 20 hours
> **ML Focus:** Model classes, Dataset classes, Pipeline class design

---

## Why OOP Before We Know How

Most ML tutorials start with Jupyter notebooks full of functions dumped into cells. That works for one-off experiments. But when you need to:

- Train 50 models with different hyperparameters
- Serve a model in production
- Collaborate with a team of 5 data scientists
- Reproduce results from 6 months ago

...spaghetti code fails. Object-Oriented Programming (OOP) is **organizational technology** for code — just like classes are organizational structures for data.

**Real-world analogy:** Think of a factory assembly line. Functions are individual workers doing one task. Classes are **workstations** with their own tools, materials, and instructions. OOP lets you build self-contained workstations (objects) that know how to do their job without micromanagement.

---

## Core Concepts

### 1. Classes and Objects

A **class** is a blueprint. An **object** is an instance built from that blueprint.

```
   Class: HouseBlueprint
   +----------------------------+
   | attributes (data):         |
   |   - square_footage         |
   |   - num_bedrooms           |
   |   - color                  |
   | methods (behavior):        |
   |   - paint(new_color)       |
   |   - calculate_taxes()      |
   +----------------------------+
              |
              | instantiate
              v
   Object: my_house (instance)
   +----------------------------+
   | square_footage = 2000      |
   | num_bedrooms = 3           |
   | color = "blue"             |
   +----------------------------+
```

```python
class House:
    """Blueprint for a house object."""
    
    def __init__(self, sqft, bedrooms, color):
        self.square_footage = sqft
        self.num_bedrooms = bedrooms
        self.color = color
    
    def paint(self, new_color):
        self.color = new_color
        return f"House is now {self.color}"

my_house = House(2000, 3, "blue")
print(my_house.paint("white"))  # House is now white
```

### 2. `__init__` and `self`

- `__init__` is the **constructor** — Python calls it when you create an object
- `self` is the **instance itself** — it's how methods access the object's own data
- You MUST name the first parameter `self` (convention, not keyword)

**Beginner Mistake:** Forgetting `self` in method definitions:
```python
class Bad:
    def __init__(self, x):
        self.x = x
    def get_x():       # Missing self!
        return self.x  # This will error
```

### 3. Inheritance

Inheritance lets you create a **hierarchy** of classes. The child class gets everything from the parent and can add or override.

**ML analogy:** `BaseModel` defines the interface. `LogisticRegression`, `RandomForest`, `XGBoost` all inherit from it, sharing `fit()` and `predict()` while implementing them differently.

```
           BaseEstimator
               |
      +--------+--------+
      |        |        |
   Linear   Tree   NeuralNet
   Model    Model    Model
```

```python
class BaseModel:
    def fit(self, X, y):
        raise NotImplementedError("Subclasses must implement fit")
    
    def predict(self, X):
        raise NotImplementedError("Subclasses must implement predict")

class LogisticRegression(BaseModel):
    def fit(self, X, y):
        print("Training logistic regression...")
    
    def predict(self, X):
        return [0, 1, 0]  # dummy
```

### 4. Polymorphism

"Many forms" — different classes can implement the same method name, and calling code doesn't need to know which class it's dealing with.

```python
models = [LogisticRegression(), RandomForestModel()]
for model in models:
    model.fit(X_train, y_train)  # Each does its own thing
    # Caller doesn't care which model type
```

### 5. `@property` — Computed Attributes

Properties look like attributes but behave like methods. They're **getters** that compute values on the fly.

```python
class Dataset:
    def __init__(self, data):
        self._data = data
    
    @property
    def shape(self):
        return (len(self._data), len(self._data[0]))
    
    @property
    def num_features(self):
        return self.shape[1]
```

**Use case:** Instead of storing `self.num_rows` and manually updating it when data changes, compute it from `self._data` every time. No inconsistency bugs.

### 6. `@staticmethod` vs `@classmethod` vs Instance Methods

| Type | First param | Can access | Use case |
|------|-------------|------------|----------|
| Instance method | `self` | Instance + class data | Most methods |
| `@classmethod` | `cls` | Class data only | Alternative constructors |
| `@staticmethod` | Nothing | Neither | Utility functions that belong logically to the class |

```python
class DataLoader:
    format = "CSV"  # class variable
    
    def __init__(self, filepath):
        self.filepath = filepath
    
    @classmethod
    def from_s3(cls, bucket, key):
        """Alternative constructor that downloads from S3 first."""
        path = cls._download(bucket, key)
        return cls(path)
    
    @staticmethod
    def _download(bucket, key):
        print(f"Downloading s3://{bucket}/{key}")
        return f"/local/{key}"
    
    def load(self):
        """Instance method — needs self.filepath."""
        print(f"Loading {self.filepath}")
```

### 7. Magic (Dunder) Methods

Methods with double underscores like `__init__`, `__str__`, `__repr__`, `__len__`, `__getitem__`.

These let your objects behave like built-in types.

```python
class FeatureMatrix:
    def __init__(self, data):
        self.data = data
    
    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        return self.data[idx]
    
    def __str__(self):
        return f"FeatureMatrix({len(self)} rows)"
    
    def __repr__(self):
        return f"FeatureMatrix({self.data})"

fm = FeatureMatrix([[1, 2], [3, 4]])
print(len(fm))     # 2  — uses __len__
print(fm[0])       # [1, 2] — uses __getitem__
print(str(fm))     # FeatureMatrix(2 rows) — uses __str__
```

### 8. `@dataclass` — Data Classes (Python 3.7+)

Automatically generates `__init__`, `__repr__`, `__eq__`, and more.

```python
from dataclasses import dataclass

@dataclass
class ModelConfig:
    learning_rate: float
    num_trees: int
    max_depth: int = 10
    random_state: int = 42

config = ModelConfig(0.01, 100)
print(config)  # ModelConfig(learning_rate=0.01, num_trees=100, ...)
```

**ML use case:** Configuration objects for models, training pipelines, hyperparameter search spaces.

### 9. Abstract Base Classes (ABC)

Force subclasses to implement certain methods. Like a contract.

```python
from abc import ABC, abstractmethod

class BaseTransformer(ABC):
    @abstractmethod
    def fit(self, X):
        pass
    
    @abstractmethod
    def transform(self, X):
        pass
    
    def fit_transform(self, X):
        """Concrete method built from abstract ones."""
        self.fit(X)
        return self.transform(X)

class StandardScaler(BaseTransformer):
    def fit(self, X):
        print("Computing mean and std...")
    
    def transform(self, X):
        print("Standardizing...")
        return X
```

---

## ML-Focused Examples

### ML Model Class

```python
class MLModel:
    """A reusable model wrapper with training and evaluation."""
    
    def __init__(self, name, model_type="classifier"):
        self.name = name
        self.model_type = model_type
        self.trained = False
        self.metrics = {}
    
    def train(self, X, y):
        print(f"Training {self.name}...")
        self.trained = True
        return self
    
    def predict(self, X):
        if not self.trained:
            raise ValueError("Model not trained yet")
        return [0] * len(X)
    
    def evaluate(self, X, y_true):
        y_pred = self.predict(X)
        accuracy = sum(1 for a, b in zip(y_pred, y_true) if a == b) / len(y_true)
        self.metrics["accuracy"] = accuracy
        return self.metrics
```

### Dataset Class

```python
class Dataset:
    """Encapsulates data loading, splitting, and preprocessing."""
    
    def __init__(self, X, y=None, name="dataset"):
        self.X = X
        self.y = y
        self.name = name
    
    @property
    def shape(self):
        return (len(self.X), len(self.X[0]) if self.X else 0)
    
    def train_test_split(self, test_size=0.2, random_state=42):
        n = len(self.X)
        split = int(n * (1 - test_size))
        return (Dataset(self.X[:split], self.y[:split] if self.y else None),
                Dataset(self.X[split:], self.y[split:] if self.y else None))
```

### Pipeline Class

```python
class Pipeline:
    """Chain transformations and a final model."""
    
    def __init__(self, steps):
        self.steps = steps  # list of (name, transformer_or_model)
    
    def fit(self, X, y=None):
        X_current = X
        for name, step in self.steps[:-1]:
            print(f"Step: {name}")
            X_current = step.fit_transform(X_current)
        name, model = self.steps[-1]
        print(f"Final step: {name}")
        model.fit(X_current, y)
        return self
    
    def predict(self, X):
        X_current = X
        for name, step in self.steps[:-1]:
            X_current = step.transform(X_current)
        name, model = self.steps[-1]
        return model.predict(X_current)
```

---

## Common Beginner Mistakes

1. **Forgetting `self`** — Every instance method must have `self` as first parameter
2. **Mutating default arguments** — `def __init__(self, data=[])` shares one list across all instances
3. **Using `@staticmethod` when you need `@classmethod`** — Class methods receive the class, static methods don't
4. **Deep inheritance hierarchies** — More than 2-3 levels is usually over-engineering
5. **Not using `super().__init__()`** — Forgetting to initialize parent class in inheritance
6. **Overusing getters/setters** — Python prefers direct attribute access; use `@property` only when you need computation or validation

## Best Practices

- **Favor composition over inheritance** — A `Pipeline` *has* models, it isn't a model
- **One class, one responsibility** — A class should have one reason to change
- **Use dataclasses for data containers** — Less boilerplate than manual `__init__`
- **Write docstrings for classes** — Explain what the class represents, not just what it does
- **Use ABCs for interfaces** — Makes your code extensible and testable
- **Keep `__init__` simple** — Just assign attributes, don't do heavy computation

## Interview Questions

1. Explain the difference between `@staticmethod` and `@classmethod` with examples.
2. What is method resolution order (MRO) in Python inheritance?
3. How would you design a `ModelRegistry` class that tracks all trained models?
4. What are magic methods? Name 5 and their use cases.
5. How does `@dataclass` work under the hood? What does it generate?
6. When would you use ABC over duck typing?

## Practice Questions

1. Write a `Timer` class that can be used as a context manager for timing ML training.
2. Design a `HyperparameterGrid` class that generates all combinations of hyperparameters.
3. Implement a `FeaturePipeline` with fit/transform/fit_transform using composition.
4. Create a `ModelEnsemble` class that averages predictions from multiple models.
5. Write a `Logger` mixin that adds logging to any class.

## Common Pitfalls

- `__init__` is NOT a constructor — it's an initializer. The object already exists when `__init__` runs
- Mutable class variables are shared across all instances
- Method resolution in diamond inheritance can be surprising
- Properties with setters can mask errors — test get/set separately

## Additional Resources

- [Python OOP Tutorial (Real Python)](https://realpython.com/python3-object-oriented-programming/)
- [Fluent Python — Chapter on OOP](https://www.oreilly.com/library/view/fluent-python-2nd/9781492056348/)
- [Python `dataclasses` documentation](https://docs.python.org/3/library/dataclasses.html)
- [Scikit-learn source code](https://github.com/scikit-learn/scikit-learn) — See real OOP design patterns
- [Raymond Hettinger's PyCon talk on OOP](https://www.youtube.com/watch?v=HTLu2DFOdTg)

## Summary

| Concept | Purpose | ML Use Case |
|---------|---------|-------------|
| Class/Instance | Encapsulate data + behavior | A `Model` knows its weights and how to predict |
| Inheritance | Code reuse + hierarchy | `LogisticRegression(BaseEstimator)` |
| Polymorphism | Same interface, different behavior | Loop over models, call `.predict()` |
| `@property` | Computed attributes | `dataset.shape` computed from data |
| `@dataclass` | Auto-generate boilerplate | Model config objects |
| ABC | Enforce interface contracts | Transformer base class |
| Magic methods | Make objects behave like built-ins | `len(dataset)`, `dataset[i]` |
