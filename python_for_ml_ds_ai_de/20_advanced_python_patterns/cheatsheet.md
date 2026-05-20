# Advanced Python Patterns — Cheatsheet

## Decorators

```python
import time
from functools import wraps

# Basic decorator
def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        print(f'{func.__name__}: {time.time() - start:.3f}s')
        return result
    return wrapper

# Decorator with arguments
def retry(max_attempts=3, delay=1):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
                    time.sleep(delay)
            return None
        return wrapper
    return decorator

# Usage
@timer
def predict(data):
    return model.predict(data)

@retry(max_attempts=3, delay=0.5)
def fetch_data(url):
    return requests.get(url).json()
```

## Generators

```python
# Memory-efficient data processing
def read_in_chunks(file_path, chunk_size=1024):
    with open(file_path) as f:
        while True:
            chunk = f.read(chunk_size)
            if not chunk:
                break
            yield chunk

def batch_generator(data, batch_size=32):
    for i in range(0, len(data), batch_size):
        yield data[i:i + batch_size]

# Infinite sequence
def infinite_counter(start=0):
    while True:
        yield start
        start += 1
```

## Context Managers

```python
from contextlib import contextmanager

# Using contextlib
@contextmanager
def model_session(model_path):
    model = load_model(model_path)
    try:
        yield model
    finally:
        del model

with model_session('model.joblib') as model:
    prediction = model.predict(data)

# Class-based
class Timer:
    def __enter__(self):
        self.start = time.time()
        return self
    
    def __exit__(self, *args):
        self.elapsed = time.time() - self.start
        print(f'Elapsed: {self.elapsed:.3f}s')

with Timer() as timer:
    result = heavy_computation()
```

## Design Patterns

### Singleton
```python
class ModelRegistry:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._models = {}
        return cls._instance
```

### Factory
```python
class ModelFactory:
    @staticmethod
    def create(model_type, **kwargs):
        if model_type == 'random_forest':
            return RandomForestClassifier(**kwargs)
        elif model_type == 'xgboost':
            import xgboost as xgb
            return xgb.XGBClassifier(**kwargs)
        raise ValueError(f'Unknown model: {model_type}')
```

### Observer
```python
class MetricsTracker:
    def __init__(self):
        self._observers = []
    
    def attach(self, observer):
        self._observers.append(observer)
    
    def notify(self, metric_name, value):
        for observer in self._observers:
            observer.update(metric_name, value)

class Logger:
    def update(self, name, value):
        print(f'Metric {name}: {value}')
```

### Dependency Injection
```python
class MLPipeline:
    def __init__(self, model, preprocessor, config):
        self.model = model
        self.preprocessor = preprocessor
        self.config = config

# Easy to test with mocks
pipeline = MLPipeline(
    model=MockModel(),
    preprocessor=MockPreprocessor(),
    config=Config()
)
```

## Mixins
```python
class LoggableMixin:
    def log(self, message):
        print(f'[LOG] {message}')

class SerializableMixin:
    def to_dict(self):
        return self.__dict__
    
    @classmethod
    def from_dict(cls, data):
        return cls(**data)

class MLModel(LoggableMixin, SerializableMixin):
    def __init__(self, name, version):
        self.name = name
        self.version = version
        self.log(f'Created model {name} v{version}')
```

## Config Objects
```python
from dataclasses import dataclass, field
from typing import Optional

@dataclass
class ModelConfig:
    name: str = 'random_forest'
    n_estimators: int = 100
    max_depth: Optional[int] = None
    learning_rate: float = 0.1
    random_state: int = 42

@dataclass
class PipelineConfig:
    model: ModelConfig = field(default_factory=ModelConfig)
    batch_size: int = 32
    preprocess: bool = True
    normalize: bool = False
```

## Common Pitfalls

| Mistake | Fix |
|---------|-----|
| Modifying wrapped function metadata | Use @wraps from functools |
| Generators exhausting silently | Convert to list if needed multiple times |
| Forgetting __exit__ cleanup | Use contextlib.contextmanager |
| Overusing metaclasses | Use class decorators instead |
| Singleton in multi-threaded code | Add threading lock |
| Tight coupling in ML pipelines | Use dependency injection |
| Not using config objects | Use dataclasses + pydantic |
