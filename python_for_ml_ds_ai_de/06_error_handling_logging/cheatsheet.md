# Module 06: Error Handling & Logging — Cheatsheet

## try/except/else/finally

```python
try:
    result = risky_operation()
except FileNotFoundError:
    print('File not found')
except (ValueError, TypeError) as e:
    print('Data error:', e)
except Exception as e:
    print('Unexpected:', e)
else:
    print('No error — result:', result)
finally:
    print('Always runs — cleanup here')
```

## Common Built-in Exceptions

| Exception | When Raised |
|-----------|-------------|
| `FileNotFoundError` | File doesn't exist |
| `ZeroDivisionError` | Division by zero |
| `ValueError` | Wrong value (e.g., int('abc')) |
| `TypeError` | Wrong type (e.g., 1 + 'a') |
| `KeyError` | Dict key not found |
| `IndexError` | List index out of range |
| `json.JSONDecodeError` | Invalid JSON |

## Custom Exceptions

```python
class MLPipelineError(Exception):
    """Base exception for ML pipeline errors."""
    pass

class DataValidationError(MLPipelineError):
    """Data failed validation checks."""
    pass

class ModelTrainingError(MLPipelineError):
    """Model training failed."""
    pass
```

## Logging Basics

```python
import logging

# Quick setup
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('my_module')

logger.debug('Debug info')    # Detailed debugging
logger.info('Normal info')     # Progress updates
logger.warning('Warning')      # Unexpected but not fatal
logger.error('Error')          # Operation failed
logger.critical('Critical')    # Pipeline cannot continue
```

## Advanced Logging: Handlers & Formatters

```python
import logging

logger = logging.getLogger('pipeline')
logger.setLevel(logging.DEBUG)

# Console: INFO+
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
ch.setFormatter(logging.Formatter('%(levelname)s: %(message)s'))

# File: DEBUG+
fh = logging.FileHandler('pipeline.log')
fh.setLevel(logging.DEBUG)
fh.setFormatter(logging.Formatter(
    '%(asctime)s | %(levelname)-8s | %(message)s'
))

logger.addHandler(ch)
logger.addHandler(fh)
```

## assert Statements

```python
# For debugging/development (can be disabled with -O flag)
assert len(data) > 0, 'Empty dataset'
assert data.shape[1] == 10, 'Expected 10 features'
assert not df.isnull().any().any(), 'Missing values found'

# For production — use explicit checks instead:
if len(data) == 0:
    raise ValueError('Empty dataset')
```

## Raising Exceptions

```python
def predict(model, features):
    if model is None:
        raise ValueError('Model is not trained')
    if len(features) == 0:
        raise ValueError('No features provided')
    return model.predict(features)
```

## ML Pipeline Pattern

```python
import logging
logger = logging.getLogger(__name__)

def train_pipeline(config_path):
    try:
        config = load_config(config_path)
        data = load_data(config['data_path'])
        model = train(data, config)
        logger.info('Pipeline completed')
        return model
    except FileNotFoundError:
        logger.critical('Data or config missing')
        raise
    except Exception as e:
        logger.error('Pipeline failed: %s', e)
        raise
```

## Log Format Specifiers

| Specifier | Meaning |
|-----------|---------|
| `%(asctime)s` | Human-readable time |
| `%(name)s` | Logger name |
| `%(levelname)s` | DEBUG/INFO/WARNING/ERROR/CRITICAL |
| `%(message)s` | The log message |
| `%(filename)s` | Source filename |
| `%(lineno)d` | Line number |

## Common Pitfalls

- **Bare `except:`** — catches KeyboardInterrupt, SystemExit too
- **Ignoring exceptions** — `except: pass` hides bugs
- **Not logging exceptions** — use `logger.exception(e)` for full traceback
- **assert in production** — use `if/raise` instead (assert can be disabled)
- **Not using `__name__`** as logger name — makes debugging harder
