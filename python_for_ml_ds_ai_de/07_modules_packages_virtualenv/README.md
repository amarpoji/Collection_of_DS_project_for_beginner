# Module 07: Modules, Packages & Virtualenv

> **Duration:** 8 hours
> **ML Focus:** Structuring ML projects as packages, creating reusable ML modules

---

## Why Modules Matter in ML

Real ML projects are not single notebooks — they are composed of many files:
- `data_loader.py` — loading and preprocessing
- `model.py` — model definition and training
- `evaluate.py` — evaluation metrics
- `config.py` — hyperparameters and settings
- `main.py` — orchestrating the pipeline

Proper module and package structure makes your ML code reusable, testable, and shareable.

---

## 1. The Python Import System

```python
# Import a module
import numpy
import numpy as np
from numpy import array
from sklearn.model_selection import train_test_split
```

**How Python finds modules:**
1. Current directory first
2. `PYTHONPATH` environment variable
3. Standard library paths
4. Site-packages (installed packages)

```python
import sys
print(sys.path)  # Shows all search paths
```

---

## 2. `__name__ == "__main__"` Guard

```python
# my_module.py
def train_model():
    print('Training...')

if __name__ == '__main__':
    # Only runs when executed directly, NOT when imported
    train_model()
```

**Why?** When you `import my_module`, you don't want it to start training automatically. The guard prevents code from running on import.

```
# Terminal
$ python my_module.py     # __name__ == '__main__' → runs
$ python -c "import my_module"  # __name__ == 'my_module' → doesn't run
```

---

## 3. Creating Packages

A package is a directory with `__init__.py`:

```
ml_project/
  __init__.py          # Makes this a package
  data/
    __init__.py
    loader.py
    preprocessing.py
  models/
    __init__.py
    linear_regression.py
    random_forest.py
  utils/
    __init__.py
    metrics.py
```

### `__init__.py` contents

```python
# ml_project/__init__.py
from .data.loader import load_dataset
from .models.linear_regression import LinearRegression

__version__ = '0.1.0'
```

This allows: `import ml_project` and `ml_project.load_dataset(...)`

### Package-level imports

```python
# Inside ml_project/models/__init__.py
from .linear_regression import LinearRegression
from .random_forest import RandomForest

__all__ = ['LinearRegression', 'RandomForest']
```

---

## 4. Relative vs Absolute Imports

### Absolute imports (recommended)

```python
from ml_project.data.loader import load_dataset
from ml_project.models.linear_regression import LinearRegression
```

### Relative imports (use within a package)

```python
# Inside ml_project/models/linear_regression.py
from ..data.loader import load_dataset     # Go up one level
from .base_model import BaseModel          # Same directory
```

**Rules:**
- Single dot `.` = current package
- Double dot `..` = parent package
- Cannot use relative imports in scripts run directly (only in packages)

---

## 5. pip vs conda

| Aspect | pip | conda |
|--------|-----|-------|
| Scope | Python packages only | Any software (Python, R, C libs) |
| Dependency resolution | pip's resolver | SAT solver (more thorough) |
| Environment | venv/virtualenv | Built-in |
| Binary packages | Wheels | Pre-built binaries |
| Repo | PyPI | Anaconda / conda-forge |

```bash
# pip
pip install numpy pandas scikit-learn
pip install -r requirements.txt

# conda
conda install numpy pandas scikit-learn
conda create -n ml_env python=3.10
```

---

## 6. requirements.txt Format

```txt
# requirements.txt — format specifiers
numpy>=1.21.0          # At least this version
pandas==1.3.0          # Exact version
scikit-learn>=1.0,<2.0 # Version range
tensorflow~=2.9.0      # Compatible release (>=2.9.0, <2.10.0)
requests               # Any version
-e .                   # Install current package in editable mode

# With extras
ml_package[dev]        # Install with dev dependencies
```

**Version specifiers:**
| Specifier | Meaning |
|-----------|---------|
| `==1.0` | Exactly 1.0 |
| `>=1.0` | At least 1.0 |
| `<=1.0` | At most 1.0 |
| `>1.0,<2.0` | Between 1.0 and 2.0 |
| `~=1.2.3` | Compatible release (>=1.2.3, <1.3.0) |
| `!=1.0` | Exclude version |

---

## 7. wheel vs source distribution

| Format | Extension | Build required? | Install faster? |
|--------|-----------|-----------------|-----------------|
| Source dist (sdist) | `.tar.gz` | Yes | No |
| Wheel | `.whl` | No | Yes |

```bash
# Build distributions
python setup.py sdist bdist_wheel

# Or with modern tools
pip install build
python -m build
```

**Wheel is preferred:** Pre-built, faster install, no compilation needed on install.

---

## ML-Specific Patterns

### Structuring an ML project as a package

```
churn_prediction/
  __init__.py
  __version__.py
  data/
    __init__.py
    loader.py
    preprocessing.py
  models/
    __init__.py
    train.py
    predict.py
  evaluate/
    __init__.py
    metrics.py
  config.py
  main.py
  requirements.txt
  setup.py
  README.md
```

### setup.py

```python
from setuptools import setup, find_packages

setup(
    name='churn_prediction',
    version='0.1.0',
    packages=find_packages(),
    install_requires=[
        'numpy>=1.21.0',
        'pandas>=1.3.0',
        'scikit-learn>=1.0',
    ],
    entry_points={
        'console_scripts': [
            'train-model=churn_prediction.main:train',
            'predict=churn_prediction.main:predict',
        ],
    },
)
```

---

## Key Takeaways

1. **`__name__ == '__main__'`** prevents code from running on import
2. **`__init__.py`** makes a directory a package — controls what gets exported
3. **Use absolute imports** for clarity, relative imports for internal package references
4. **`requirements.txt`** pins dependencies for reproducibility
5. **Wheels (.whl)** are preferred over source distributions for faster installs
6. **Structure ML projects as packages** for reusability and testing
7. **Use pip for Python packages**, conda for complex environments with non-Python deps
