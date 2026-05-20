# Module 00 — Python Environment Setup

> **Estimated Time:** 4 hours  
> **Difficulty:** ⭐ Beginner  
> **Prerequisites:** Basic computer literacy

---

## 🎯 Learning Objectives

By the end of this module, you will be able to:
- Install Python using pyenv and conda
- Set up VS Code with Python extensions
- Create and manage virtual environments
- Run Jupyter Notebook and Jupyter Lab
- Install packages with pip
- Manage project dependencies with requirements.txt
- Initialize a git repository
- Write and execute your first Python script

---

## 📖 Why Environment Setup Matters

### The First Principles Question

Before we write a single line of code, we ask: **Why do we need to set up an environment?**

**Analogy:** Think of Python as a chef. The chef needs:
1. A kitchen (Python interpreter)
2. Recipes (packages like pandas, numpy)
3. A prep station (VS Code / Jupyter)
4. Separate counters for different dishes (virtual environments)

If you cook fish on a cutting board that just had strawberries, both get ruined. **Virtual environments** are your separate cutting boards — they keep project dependencies isolated so projects don't "contaminate" each other.

### Why This Matters for ML/DS/AI/DE

| Problem | Solution | Why It Matters |
|---------|----------|----------------|
| Project A needs pandas 1.5, Project B needs pandas 2.0 | Virtual environments | Without isolation, you get "dependency hell" |
| Reproducing a colleague's results | requirements.txt with pinned versions | ML results must be reproducible |
| Sharing a notebook with a team | Consistent environment | "It works on my machine" is unacceptable |
| Deploying a model to production | Docker/conda env | Production must match development |

---

## 🔧 Toolchain Overview

```
┌─────────────────────────────────────────────────────┐
│                  ML/DS Python Stack                   │
├─────────────┬──────────────┬────────────────────────┤
│  Core       │  Data & ML   │  Development Tools      │
│─────────────┼──────────────┼────────────────────────┤
│  Python 3.12│  NumPy       │  VS Code + Extensions   │
│  pip        │  Pandas      │  Jupyter Lab            │
│  venv/conda │  Scikit-learn│  Git + GitHub           │
│  pyenv      │  Matplotlib  │  Terminal               │
└─────────────┴──────────────┴────────────────────────┘
```

---

## 1. Installing Python

### Option A: pyenv (Recommended for Linux/macOS/WSL)

pyenv lets you install and switch between multiple Python versions:

```bash
# Install pyenv (Linux/macOS)
curl https://pyenv.run | bash

# Install Python 3.12
pyenv install 3.12.0

# Set global Python version
pyenv global 3.12.0

# Verify
python --version
# Output: Python 3.12.0
```

### Option B: Miniconda (Recommended for Windows / Data Scientists)

Miniconda is a minimal installer for conda — perfect for data science:

```bash
# Download from https://docs.conda.io/en/latest/miniconda.html
# Then verify
conda --version
conda list  # view installed packages
```

### ⚠️ Beginner Mistake

```bash
# ❌ WRONG: Using system Python with sudo pip
sudo pip install pandas  # Can break system tools!

# ✅ RIGHT: Using pyenv or conda Python
python -m pip install pandas  # Installs in user space
```

---

## 2. Virtual Environments

### Why Virtual Environments?

A virtual environment is an **isolated Python installation** for each project:

```
┌── Project A ──┐    ┌── Project B ──┐
│ pandas 1.5    │    │ pandas 2.0    │
│ numpy 1.24    │    │ numpy 1.26    │
│ scikit-learn  │    │ tensorflow    │
│ 1.2           │    │ 2.13          │
└───────────────┘    └───────────────┘
        │                      │
        └──────────┬───────────┘
                   │
        ┌──────────▼───────────┐
        │   System Python      │
        │   (3.12 base)        │
        └──────────────────────┘
```

### Using venv (Built-in)

```bash
# Create environment
python -m venv myenv

# Activate (Linux/macOS)
source myenv/bin/activate

# Activate (Windows)
myenv\Scripts\activate

# Deactivate
deactivate

# Delete environment
rm -rf myenv  # or delete folder manually
```

### Using conda

```bash
# Create environment with Python 3.12
conda create -n myenv python=3.12

# Activate
conda activate myenv

# Deactivate
conda deactivate

# List environments
conda env list

# Export environment
conda env export > environment.yml

# Create from file
conda env create -f environment.yml
```

---

## 3. Package Management with pip

### Basic pip Commands

```bash
# Install a package
pip install pandas

# Install specific version
pip install pandas==2.0.0

# Install multiple packages
pip install numpy pandas matplotlib scikit-learn

# Install from requirements file
pip install -r requirements.txt

# List installed packages
pip list

# Show package info
pip show pandas

# Uninstall
pip uninstall pandas

# Upgrade
pip install --upgrade pandas
```

### requirements.txt

```text
# requirements.txt
numpy==1.26.0
pandas==2.0.0
scikit-learn==1.3.0
matplotlib==3.7.0
jupyter==1.0.0
```

### ⚠️ Best Practice: Pinning Versions

```bash
# ✅ Save exact versions from current environment
pip freeze > requirements.txt

# This gives output like:
# numpy==1.26.0
# pandas==2.0.0

# ❌ Don't manually write unversioned requirements
# numpy
# pandas
# (This breaks reproducibility!)
```

---

## 4. Jupyter Notebook & Lab

### What is Jupyter?

Jupyter Notebook is an **interactive computing environment** where you can mix code, text, and visualizations:

```
┌────────────────────────────────────────┐
│  [Markdown Cell]                       │
│  # Introduction                        │
│  Here we analyze the Titanic dataset   │
├────────────────────────────────────────┤
│  [Code Cell]                           │
│  import pandas as pd                   │
│  df = pd.read_csv('titanic.csv')       │
│  df.head()                             │
├────────────────────────────────────────┤
│  [Output]                              │
│  ┌────┬──────┬──────┐                  │
│  │    │ Name │ Age  │                  │
│  ├────┼──────┼──────┤                  │
│  │ 0  │ John │ 22   │                  │
│  └────┴──────┴──────┘                  │
└────────────────────────────────────────┘
```

### Installation

```bash
# Install Jupyter
pip install jupyter notebook jupyterlab

# Start Jupyter Notebook
jupyter notebook

# Start Jupyter Lab (recommended)
jupyter lab
```

### Jupyter Lab vs Notebook

| Feature | Notebook | Lab |
|---------|----------|-----|
| Multiple tabs | ❌ | ✅ |
| File browser | ❌ | ✅ |
| Terminal in browser | ❌ | ✅ |
| Extension support | Limited | Rich |
| Modern UI | ❌ | ✅ |

**Winner:** Jupyter Lab for serious work

---

## 5. VS Code Setup

### Essential Extensions for ML/DS

| Extension | Purpose |
|-----------|---------|
| **Python** (Microsoft) | Core Python support |
| **Jupyter** (Microsoft) | Run notebooks inside VS Code |
| **Pylance** | Type checking, autocomplete |
| **GitLens** | Git integration |
| **Rainbow CSV** | CSV file viewing |
| **Markdown All in One** | Markdown editing |

### VS Code Settings

```json
{
  "python.defaultInterpreterPath": "${workspaceFolder}/venv/bin/python",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "python.formatting.provider": "black",
  "editor.formatOnSave": true,
  "jupyter.sendSelectionToInteractiveWindow": true
}
```

---

## 6. Git Basics for Data Scientists

### Why Git for Data Science?

```bash
# Initialize a project
git init

# Check status
git status

# Stage files
git add *.py requirements.txt

# Commit
git commit -m "Initial ML project setup"

# View history
git log --oneline

# Create a branch for experimentation
git checkout -b feature-engineering
```

### The .gitignore for Data Projects

```text
# .gitignore
__pycache__/
*.pyc
.env
venv/
.env/
data/raw/*.csv
data/processed/*.csv
*.ipynb_checkpoints/
.mypy_cache/
.pytest_cache/
```

---

## 7. Your First Python Script

Create a file called `hello_ds.py`:

```python
#!/usr/bin/env python3
"""My first data science script."""

import sys
from typing import NoReturn


def greet(name: str) -> str:
    """Return a greeting for the data scientist."""
    return f"Hello {name}, welcome to Data Science with Python 3.12+!"


def main() -> NoReturn:
    """Entry point."""
    name: str = sys.argv[1] if len(sys.argv) > 1 else "Data Scientist"
    print(greet(name))
    sys.exit(0)


if __name__ == "__main__":
    main()
```

Run it:
```bash
python hello_ds.py
# Output: Hello Data Scientist, welcome to Data Science with Python 3.12+!

python hello_ds.py Amar
# Output: Hello Amar, welcome to Data Science with Python 3.12+!
```

---

## 💡 Beginner Mistakes

### Mistake 1: Installing packages globally with pip
```bash
# ❌ Wrong
sudo pip install pandas

# ✅ Right
python -m venv .venv
source .venv/bin/activate
pip install pandas
```

### Mistake 2: Forgetting to activate virtual environment
```bash
# ❌ Wrong — installs to wrong environment
pip install numpy  # Might go to base Python!

# ✅ Right — activate first
source .venv/bin/activate
pip install numpy
```

### Mistake 3: Not using .gitignore
```bash
# ❌ Wrong — commits virtual environment
git add .
git commit -m "added venv"  # venv is 100MB+!

# ✅ Right — .gitignore handles it
git add .
git commit -m "initial commit"
```

### Mistake 4: Mixing pip and conda
```bash
# ❌ Wrong — can cause conflicts
conda install numpy
pip install pandas

# ✅ Right — stick with one (conda recommended for DS)
conda install numpy pandas
```

---

## 🎯 Practice Questions

1. What is the purpose of a virtual environment?
2. What's the difference between `pip install` and `conda install`?
3. Why should you pin package versions in requirements.txt?
4. What are the three layers of the ML/DS Python stack?
5. How do you activate a virtual environment on Windows vs Mac/Linux?
6. What is the purpose of `.gitignore` in a data science project?
7. Why is Jupyter Lab preferred over Jupyter Notebook for serious work?

---

## 💼 Interview Questions

**Q:** "Explain the concept of virtual environments to a non-technical stakeholder."
**A:** "Imagine each project is a kitchen. One kitchen needs a specific oven (pandas 1.5), another needs a different oven (pandas 2.0). Virtual environments are like having separate kitchens for each project — they don't share appliances, so there's no conflict. This ensures our data pipeline runs exactly the same on my machine, my colleague's machine, and in production."

**Q:** "What's in your requirements.txt and why?"
**A:** "Every package with its exact version number, pinned so installations are deterministic. We use `pip freeze` to capture the exact state. For production, we also include hashes for security."

**Q:** "How do you ensure reproducibility in a data science project?"
**A:** "Three layers: (1) requirements.txt with pinned versions, (2) virtual environment documentation, (3) Docker container for complete system-level reproducibility."

---

## ⚠️ Common Pitfalls

| Pitfall | Symptom | Solution |
|---------|---------|----------|
| Wrong Python version | `ModuleNotFoundError` | Check with `python --version` |
| pip installing to system | Permission errors | Use `--user` flag or venv |
| Conda environment corruption | Package conflicts | Create fresh environment |
| Missing .gitignore | Huge repo size | Add `.gitignore` immediately |
| Different Python versions | Syntax errors | Standardize with `.python-version` |
| Hardcoded paths | Code breaks on other machines | Use relative paths, `.env` files |

---

## 📚 Additional Resources

- **Official Docs:** [Python Packaging Guide](https://packaging.python.org/)
- **Video:** [Conda Environments for Data Science](https://www.youtube.com/watch?v=W3nUfVLGH3E)
- **Book:** "Python for Data Analysis" — Chapter 1 (Environment Setup)
- **Tutorial:** [Real Python — Python Virtual Environments](https://realpython.com/python-virtual-environments-a-primer/)
- **Tool:** [pyenv GitHub](https://github.com/pyenv/pyenv)
- **Course:** [Kaggle — Python Micro-Course](https://www.kaggle.com/learn/python)

---

## 📝 Summary

- Python environment setup is the **foundation** of every data project
- **Virtual environments** isolate project dependencies
- **pip** manages packages; **venv/conda** manages environments
- **Jupyter Lab** is the interactive environment for ML/DS work
- **VS Code** with extensions provides the IDE experience
- **Git** tracks changes and enables collaboration
- **requirements.txt** ensures reproducibility
- Always know which Python + which environment you're in
