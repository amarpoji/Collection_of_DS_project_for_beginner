# Module 07: Modules, Packages & Virtualenv — Cheatsheet

## `__name__ == '__main__'` Guard

```python
# my_module.py
def train():
    print('Training...')

if __name__ == '__main__':
    # Only runs when executed directly, not on import
    train()
```

```
python my_module.py       # Runs the guard code
python -c "import my_module"  # Does NOT run guard code
```

## Import System

```python
import module
from package.submodule import Class
from module import function as fn

# sys.path controls search order
import sys
sys.path.insert(0, '/custom/path')
```

## Package Structure

```
mypackage/
  __init__.py          # Makes it a package; controls exports
  module_a.py
  subpackage/
    __init__.py
    module_b.py
```

## `__init__.py` — What Gets Exported

```python
# mypackage/__init__.py
from .module_a import useful_function
from .subpackage.module_b import AnotherClass

__version__ = '1.0.0'
__all__ = ['useful_function', 'AnotherClass']
```

Then: `from mypackage import useful_function`

## Relative Imports (Inside Packages)

```python
# Inside mypackage/subpackage/module_b.py
from . import sibling_module       # same directory
from ..module_a import func        # parent directory
from ..subpackage import thing     # sibling subpackage
from . import AnotherClass         # from __init__.py
```

## Absolute Imports (Outside Packages)

```python
from mypackage.module_a import func
from mypackage.subpackage.module_b import AnotherClass
```

## requirements.txt

```txt
numpy>=1.21.0
pandas==1.3.0
scikit-learn>=1.0,<2.0
tensorflow~=2.9.0     # >=2.9.0, <2.10.0
requests              # any version
-e .                  # editable install of current package
```

| Specifier | Meaning |
|-----------|---------|
| `==1.0` | Exact |
| `>=1.0` | At least |
| `>1.0,<2.0` | Range |
| `~=1.2.3` | Compatible release (>=1.2.3, <1.3.0) |
| `!=1.0` | Exclude |
| `*` | Any (same as omitted) |

## pip vs conda

| pip | conda |
|-----|-------|
| `pip install numpy` | `conda install numpy` |
| `pip install -r requirements.txt` | `conda install --file requirements.txt` |
| `pip freeze > requirements.txt` | `conda env export > environment.yml` |
| `python -m venv myenv` | `conda create -n myenv python=3.10` |
| PyPI only | Any software |

## Wheel vs Source Distribution

| sdist (.tar.gz) | Wheel (.whl) |
|-----------------|-------------|
| Needs compilation | Pre-built |
| Slower install | Faster install |
| Platform-independent | Platform-specific |
| `python setup.py sdist` | `python setup.py bdist_wheel` |

## setup.py Template

```python
from setuptools import setup, find_packages

setup(
    name='my_package',
    version='0.1.0',
    packages=find_packages(),
    install_requires=['numpy>=1.21'],
    entry_points={
        'console_scripts': [
            'my-command=my_package.main:main',
        ],
    },
)
```

## Virtual Environment Commands

```bash
# venv (built-in)
python -m venv myenv
source myenv/bin/activate   # Linux/Mac
myenv\\Scripts\\activate     # Windows
deactivate

# conda
conda create -n ml_env python=3.10
conda activate ml_env
conda deactivate
conda env list
conda env export > environment.yml
```

## Common Patterns

```python
# Check if running as script
if __name__ == '__main__':
    main()

# Package-level imports for clean API
# __init__.py
from .data.loader import load_dataset
from .models import train_model

# __all__ controls what `from package import *` gives
__all__ = ['load_dataset', 'train_model']
```

## Common Pitfalls

- **Circular imports** — module A imports module B which imports module A
- **Relative imports in scripts** — only work inside packages, not in top-level scripts
- **Forgetting `__init__.py`** — Python 3.3+ has implicit namespace packages, but explicit is clearer
- **Not pinning versions** — leads to "works on my machine" problems
- **Installing packages system-wide** — always use virtual environments
