# Module 03: OOP for ML Projects — Cheatsheet

## Class Definition & Instantiation

```python
class Model:
    """Docstring explaining the class."""
    
    # Class variable (shared by all instances)
    domain = "machine_learning"
    
    def __init__(self, name, lr=0.01):
        """Constructor — initializes instance attributes."""
        self.name = name          # instance attribute
        self.lr = lr
        self._trained = False     # "private" by convention
    
    def train(self, X, y):
        """Instance method — first param must be self."""
        self._trained = True
        return self               # method chaining

model = Model("lr")              # instantiation
```

## Key OOP Concepts

| Concept | Description | ML Use |
|---------|-------------|--------|
| **Class** | Blueprint for objects | Model, Dataset, Scaler |
| **Object** | Instance of a class | `model = LogisticRegression()` |
| **`__init__`** | Initializer (not constructor) | Set hyperparameters |
| **`self`** | Reference to the instance | Access own attributes |
| **Inheritance** | Child gets parent's methods | `class RF(BaseModel):` |
| **Polymorphism** | Same interface, diff impl | `model.fit()` works on any model |
| **Encapsulation** | Bundle data + methods | Dataset knows its data + split logic |

## Inheritance

```python
class BaseModel:
    def fit(self, X, y):
        raise NotImplementedError
    
    def predict(self, X):
        raise NotImplementedError

class LogisticRegression(BaseModel):
    def __init__(self, C=1.0):
        super().__init__()          # Call parent __init__
        self.C = C
    
    def fit(self, X, y):            # Override
        self.coef_ = [0.1] * len(X[0])
```

## Properties (@property)

```python
class Dataset:
    @property
    def shape(self):
        """Computed attribute — called like dataset.shape."""
        return (len(self._data), len(self._data[0]))
    
    @shape.setter
    def shape(self, value):
        """Optional setter for property."""
        raise AttributeError("Cannot set shape directly")
```

## @staticmethod vs @classmethod

```python
class DataLoader:
    format = "csv"  # class variable
    
    @classmethod
    def from_csv(cls, path):
        """Factory method — gets cls as first arg."""
        return cls(path)
    
    @staticmethod
    def validate(path):
        """Utility — gets neither cls nor self."""
        return path.endswith(".csv")
    
    def load(self):
        """Instance method — gets self."""
        pass
```

## Magic (Dunder) Methods

```python
class FeatureMatrix:
    def __len__(self): return len(self.data)          # len(obj)
    def __getitem__(self, i): return self.data[i]     # obj[i]
    def __setitem__(self, i, v): self.data[i] = v     # obj[i] = v
    def __str__(self): return "MyClass()"              # str(obj), print
    def __repr__(self): return "MyClass(data=...)"     # repr(obj), debug
    def __add__(self, other): ...                      # obj + other
    def __eq__(self, other): ...                       # obj == other
    def __contains__(self, item): ...                  # item in obj
    def __iter__(self): return iter(self.data)         # for x in obj
```

## @dataclass

```python
from dataclasses import dataclass, field

@dataclass
class Config:
    """Auto-generates __init__, __repr__, __eq__."""
    lr: float = 0.01
    batch_size: int = 32
    layers: list = field(default_factory=list)  # Avoid mutable default!
    name: str = "model"
```

## ABC (Abstract Base Classes)

```python
from abc import ABC, abstractmethod

class BaseTransformer(ABC):
    @abstractmethod
    def fit(self, X): pass
    
    @abstractmethod
    def transform(self, X): pass
    
    def fit_transform(self, X):  # Concrete method
        self.fit(X)
        return self.transform(X)
```

## Common Gotchas

| Gotcha | Wrong | Right |
|--------|-------|-------|
| Mutable defaults | `def __init__(self, data=[])` | `def __init__(self, data=None)` |
| Forgetting `self` | `def method():` | `def method(self):` |
| Missing `super().__init__()` | Child doesn't call parent init | Call `super().__init__()` |
| Class vs instance var | Set on class, mutate on instance | Be explicit about intent |
| Deep inheritance | 4+ levels of inheritance | Use composition instead |

## Design Patterns for ML

```
Model       = class with train() + predict()
Dataset     = class with split() + properties
Pipeline    = class that chains transformers + model
Registry    = class with classmethod register/get
Config      = dataclass for hyperparameters
Experiment  = dataclass for tracking results
```

## Quick Reference: Method Types

```python
class Example:
    def regular(self, x):           # Needs self
        return x + 1
    
    @classmethod
    def factory(cls, x):            # Needs cls
        return cls(x)
    
    @staticmethod
    def util(x):                    # Needs nothing
        return x * 2
    
    @property
    def computed(self):             # Looks like attribute
        return self._value * 2
```

## Minimal Model Template

```python
class MyModel:
    def __init__(self, **params):
        self.params = params
        self._fitted = False
    
    def fit(self, X, y):
        self._fitted = True
        return self
    
    def predict(self, X):
        if not self._fitted:
            raise ValueError("not fitted")
        return [0] * len(X)
    
    def score(self, X, y):
        from sklearn.metrics import accuracy_score
        return accuracy_score(y, self.predict(X))
```
