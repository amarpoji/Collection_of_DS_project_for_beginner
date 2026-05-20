# Module 00 Cheatsheet — Python Environment Setup

## Python Installation

```bash
# pyenv (Linux/Mac)
curl https://pyenv.run | bash
pyenv install 3.12.0
pyenv global 3.12.0

# Miniconda
# Download from https://docs.conda.io/en/latest/miniconda.html
```

## Virtual Environments

### venv (built-in)

```bash
python -m venv .venv          # create
source .venv/bin/activate     # activate (Linux/Mac)
.venv\Scripts\activate        # activate (Windows)
deactivate                    # deactivate
rm -rf .venv                  # delete
```

### conda

```bash
conda create -n myenv python=3.12  # create
conda activate myenv               # activate
conda deactivate                   # deactivate
conda env list                     # list envs
conda env export > environment.yml # export
conda env remove -n myenv          # delete
```

## pip Commands

```bash
pip install pandas              # install
pip install pandas==2.0.0       # specific version
pip install -r requirements.txt # from file
pip freeze > requirements.txt   # save current state
pip list                        # list packages
pip show pandas                 # package info
pip uninstall pandas -y         # remove
```

## Jupyter

```bash
pip install jupyterlab notebook  # install
jupyter lab                      # start lab
jupyter notebook                 # start notebook
```

## Git Basics

```bash
git init
git add .
git commit -m "message"
git status
git log --oneline
git checkout -b new-branch
```

## VS Code Extensions (ML/DS)

- Python (Microsoft)
- Jupyter (Microsoft)
- Pylance
- GitLens
- Rainbow CSV

## First Script Template

```python
#!/usr/bin/env python3
"""Module docstring."""

from typing import NoReturn


def main() -> NoReturn:
    """Entry point."""
    print("Hello, Data Science!")
    import sys
    sys.exit(0)


if __name__ == "__main__":
    main()
```

## .gitignore for Data Projects

```gitignore
__pycache__/
*.pyc
.env
venv/
.venv/
data/raw/
*.ipynb_checkpoints/
.mypy_cache/
.pytest_cache/
```

## Key Concepts

| Concept | Why It Matters |
|---------|----------------|
| Virtual env | Isolates project dependencies |
| pip freeze | Pins exact versions for reproducibility |
| requirements.txt | Shareable dependency spec |
| .gitignore | Prevents committing large/temp files |
| pyenv | Manages multiple Python versions |
| Jupyter Lab | Interactive coding + visualization |
