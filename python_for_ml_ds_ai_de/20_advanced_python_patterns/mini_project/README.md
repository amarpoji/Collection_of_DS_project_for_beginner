# Mini Project: Production ML System

**Module 20 — Advanced Python Patterns**

## Objective

Build a production-grade ML system that uses advanced Python patterns: decorators for retry/logging/timing, generators for data streaming, context managers for resource management, factory for model creation, singleton for model registry, observer for metrics, and dependency injection for testable components.

## Dataset

**California Housing** (from sklearn) — build a production ML pipeline that trains, tunes, serves, and monitors models.

## Tasks

### Part 1: Config Objects with Dataclasses (2 hours)

1. Create a `TrainingConfig` dataclass with:
   - model_type: str (random_forest, gradient_boosting, ridge)
   - hyperparameters: dict
   - test_size: float (default 0.2)
   - random_state: int (default 42)
   - cv_folds: int (default 5)
   - feature_columns: list

2. Create an `InferenceConfig` dataclass with:
   - model_version: str
   - batch_size: int
   - return_proba: bool (default True)
   - cache_predictions: bool (default False)

3. Create a `PipelineConfig` that composes both

### Part 2: Decorators for ML Pipeline (2 hours)

1. Create a `@timer` decorator that logs execution time
2. Create a `@log_calls` decorator that logs function name, args, and return value
3. Create a `@retry` decorator with:
   - configurable max_attempts and delay
   - exponential backoff
   - logging on each attempt
   - configurable exception types to catch

4. Apply all three decorators to ML pipeline functions

### Part 3: Generators for Data Processing (1 hour)

1. Create a `DataStreamer` generator that:
   - Reads data in chunks from a DataFrame
   - Applies preprocessing per chunk
   - Yields processed batches for training
2. Create a `batch_generator` for streaming predictions
3. Create a generator that augments data on-the-fly

### Part 4: Context Managers (1 hour)

1. Create a `ModelSession` context manager that:
   - Loads model on enter
   - Makes model available for predictions
   - Cleans up (frees memory) on exit
2. Create a `Timer` context manager for timing code blocks
3. Create a `ExperimentTracker` context manager that logs to MLflow

### Part 5: Design Patterns (4 hours)

1. **Singleton** — `ModelRegistry` that stores loaded models by version
2. **Factory** — `ModelFactory` that creates models based on config
3. **Observer** — `MetricsTracker` that notifies observers when metrics are logged
4. **Strategy** — different preprocessing strategies (MinMaxScaler, StandardScaler, RobustScaler)

### Part 6: Dependency Injection (2 hours)

1. Create a `MLPipeline` class that takes dependencies via constructor:
   - model (from factory)
   - preprocessor (strategy)
   - config object
   - metrics tracker (observer)

2. Write unit tests with mocked components

### Part 7: Complete Pipeline (4 hours)

Create a complete production ML pipeline that:
1. Loads configuration from dataclasses
2. Creates model via factory pattern
3. Trains with decorated functions (timer, log, retry)
4. Streams data through generators
5. Uses context managers for resource management
6. Registers model in singleton registry
7. Tracks metrics with observer pattern
8. Supports dependency injection for testing

## Deliverables

1. **config.py** — dataclass configurations
2. **decorators.py** — @timer, @log_calls, @retry
3. **generators.py** — data streaming generators
4. **context_managers.py** — ModelSession, Timer, ExperimentTracker
5. **patterns.py** — Singleton, Factory, Observer, Strategy
6. **ml_pipeline.py** — complete pipeline with DI
7. **test_ml_pipeline.py** — unit tests with mocks
8. **main.py** — entry point demonstrating the full system

## Evaluation Criteria

| Criteria | Weight |
|----------|--------|
| Correct implementation of each pattern | 30% |
| Integration of patterns into cohesive pipeline | 25% |
| Code quality and Pythonic style | 20% |
| Testing with dependency injection | 15% |
| Documentation and examples | 10% |

## Resources

- Python Decorators: https://realpython.com/primer-on-python-decorators/
- Python Generators: https://realpython.com/introduction-to-python-generators/
- Design Patterns in Python: https://refactoring.guru/design-patterns/python
- dataclasses: https://docs.python.org/3/library/dataclasses.html
- contextlib: https://docs.python.org/3/library/contextlib.html

## Stretch Goals

- Implement a decorator-based pipeline DSL (decorator chaining)
- Add async support with async context managers
- Create a plugin architecture using metaclasses
- Implement a CRTP (Curiously Recurring Template Pattern) in Python
- Build a CLI interface for the pipeline using argparse/click
