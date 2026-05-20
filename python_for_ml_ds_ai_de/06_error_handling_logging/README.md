# Module 06: Error Handling & Logging

> **Duration:** 10 hours
> **ML Focus:** Robust ML pipelines, logging training progress, debugging data issues

---

## Why Error Handling Matters in ML

ML pipelines fail in unique ways:
- Data files are missing or corrupted
- Feature columns don't match expectations
- Models fail to converge or produce NaN values
- Training runs for hours then crashes at 99%

Without proper error handling and logging, debugging these failures is painful. With them, you know exactly what went wrong and where.

---

## 1. try/except/else/finally

### Basic Structure

```python
try:
    # Risky code
    result = risky_operation()
except SomeException:
    # Handle specific error
    print('Something went wrong')
else:
    # Runs only if no exception
    print('Success!')
finally:
    # Always runs (cleanup)
    cleanup()
```

### Catching Specific Exceptions

```python
try:
    data = load_dataset('missing.csv')
except FileNotFoundError:
    print('File not found — check path')
except pd.errors.EmptyDataError:
    print('File is empty')
except Exception as e:
    print('Unexpected error:', e)
```

**Golden rule:** Never use bare `except:` — you'll catch KeyboardInterrupt and SystemExit too.

---

## 2. Custom Exceptions

Define domain-specific exceptions for your ML pipeline:

```python
class DataValidationError(Exception):
    """Raised when data fails validation checks."""
    pass

class ModelTrainingError(Exception):
    """Raised when model training fails."""
    pass

def validate_features(data, expected_columns):
    missing = [c for c in expected_columns if c not in data.columns]
    if missing:
        raise DataValidationError(
            'Missing columns: ' + ', '.join(missing)
        )
```

**Why?** You can catch specific errors in your pipeline and handle them differently:
- `DataValidationError` → try alternative data source
- `ModelTrainingError` → log and skip to next experiment
- Custom exceptions carry domain meaning

---

## 3. The `logging` Module

### Basic Setup

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)
logger.info('Starting training pipeline')
logger.warning('Low data quality detected')
logger.error('Training failed with NaN loss')
```

### Logging Levels

| Level | When to use |
|-------|-------------|
| `DEBUG` | Detailed debug info (feature values, iterations) |
| `INFO` | Normal progress (epoch complete, model saved) |
| `WARNING` | Something unexpected but not fatal |
| `ERROR` | Operation failed, pipeline may continue |
| `CRITICAL` | Pipeline cannot continue |

### Handlers and Formatters

```python
import logging

logger = logging.getLogger('ml_pipeline')
logger.setLevel(logging.DEBUG)

# Console handler
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)

# File handler
fh = logging.FileHandler('pipeline.log')
fh.setLevel(logging.DEBUG)

# Formatter
formatter = logging.Formatter(
    '%(asctime)s | %(levelname)-8s | %(message)s'
)
ch.setFormatter(formatter)
fh.setFormatter(formatter)

logger.addHandler(ch)
logger.addHandler(fh)
```

---

## 4. assert Statements

```python
def preprocess_data(df):
    assert not df.empty, 'Dataset is empty'
    assert 'label' in df.columns, 'Missing label column'
    assert df['age'].min() >= 0, 'Negative ages found'

    # Processing continues...
    return processed_df
```

**Key points:**
- `assert` can be disabled with `python -O` — don't use for validation that must always run
- Use for sanity checks and debugging
- For production validation, use explicit `if` + `raise`

---

## 5. Raising Exceptions

```python
def check_data_quality(df):
    if df.isnull().sum().sum() > len(df) * 0.5:
        raise ValueError(
            'Too many missing values: '
            + str(df.isnull().sum().sum())
        )
    if df['label'].nunique() < 2:
        raise ValueError(
            'Need at least 2 classes, found '
            + str(df['label'].nunique())
        )
```

---

## ML-Specific Patterns

### Robust training loop with logging

```python
import logging
import time

logger = logging.getLogger(__name__)

def train_model(model, X_train, y_train, epochs=10):
    logger.info('Starting training with %d epochs', epochs)

    for epoch in range(epochs):
        try:
            loss = model.train_epoch(X_train, y_train)
            logger.info('Epoch %d/%d — loss: %.4f', epoch + 1, epochs, loss)

            if loss is None or loss != loss:  # NaN check
                raise ModelTrainingError('Loss is NaN')

        except ModelTrainingError as e:
            logger.critical('Training failed: %s', e)
            raise
        except Exception as e:
            logger.error('Unexpected error at epoch %d: %s', epoch, e)
            continue

    logger.info('Training completed successfully')
    return model
```

### Safe file loading

```python
def safe_load_dataset(path, fallback_path=None):
    try:
        logger.info('Loading dataset from %s', path)
        data = pd.read_csv(path)
        logger.info('Loaded %d rows', len(data))
        return data
    except FileNotFoundError:
        logger.warning('File not found: %s', path)
        if fallback_path:
            logger.info('Trying fallback: %s', fallback_path)
            return safe_load_dataset(fallback_path)
        raise
    except pd.errors.EmptyDataError:
        logger.error('Empty dataset at %s', path)
        raise
```

---

## Key Takeaways

1. **Use specific exception types** — catch `FileNotFoundError`, not `Exception`
2. **Create custom exceptions** for domain-specific failures
3. **Use `logging` not `print`** — log levels, timestamps, file output
4. **Use `assert` for debugging** but use `if/raise` for production validation
5. **Log training progress** at INFO level, debug info at DEBUG level
6. **Always include timestamps** in log messages
7. **The `finally` block** is for cleanup (close files, release resources)
