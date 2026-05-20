# Module 05: File Handling & OS

> **Duration:** 12 hours
> **ML Focus:** Reading datasets from files, saving model artifacts, working with data science file formats

---

## Why File I/O Matters in ML/DS

In machine learning, data lives in files. Every ML project starts with:

- Reading CSV/JSON/JSONL datasets
- Loading model weights and configurations
- Saving trained models, predictions, and logs
- Organizing project directories and artifacts

Without solid file I/O skills, you cannot build real ML pipelines.

---

## 1. Opening and Reading Files

### The `open()` Function

```python
file = open('data.csv', 'r')
content = file.read()
file.close()  # Don't forget!
```

**Modes:**
- `'r'` — Read (text, default)
- `'w'` — Write (overwrites!)
- `'a'` — Append
- `'rb'` / `'wb'` — Binary read/write
- `'r+'` — Read and write

### Context Managers (`with` statement)

```python
with open('data.csv', 'r') as f:
    content = f.read()
# File automatically closes, even on exceptions
```

**Why?** Without `with`, an exception before `f.close()` leaks file handles and can corrupt data.

### Reading Methods

| Method | What it does | Use when |
|--------|-------------|----------|
| `read()` | Entire file as string | Small files |
| `readline()` | One line at a time | Streaming |
| `readlines()` | List of all lines | Line-by-line processing |
| `for line in f` | Iterator (memory efficient) | Large files |

---

## 2. Writing Files

```python
with open('output.txt', 'w') as f:
    f.write('Hello\n')
    f.writelines(['line1\n', 'line2\n'])
```

**Binary mode** for model artifacts:
```python
with open('model.pkl', 'wb') as f:
    pickle.dump(model, f)
```

---

## 3. The `pathlib` Module (Modern Approach)

```python
from pathlib import Path

data_dir = Path('data')
csv_path = data_dir / 'train.csv'  # Clean path joining

# Common operations
csv_path.exists()         # Check if file exists
csv_path.is_file()        # Is it a file?
csv_path.is_dir()         # Is it a directory?
csv_path.name             # 'train.csv'
csv_path.stem             # 'train'
csv_path.suffix           # '.csv'
csv_path.parent           # Path('data')
csv_path.mkdir(parents=True, exist_ok=True)
```

**Why pathlib?** Cross-platform, readable, method chaining. No more `os.path.join()` spaghetti.

---

## 4. The `os` Module (Traditional Approach)

```python
import os

os.getcwd()          # Current working directory
os.listdir('.')      # List files in directory
os.makedirs('data/raw', exist_ok=True)
os.remove('old.csv')
os.rename('temp.csv', 'final.csv')
os.environ['API_KEY']  # Environment variables
```

---

## 5. CSV Handling

### Using csv module (standard library)

```python
import csv

# Reading
with open('data.csv', 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row['feature_1'], row['label'])

# Writing
with open('predictions.csv', 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['id', 'prediction'])
    writer.writeheader()
    writer.writerow({'id': 1, 'prediction': 0.95})
```

### Using pandas (data science standard)

```python
import pandas as pd
df = pd.read_csv('data.csv')
df.to_csv('clean.csv', index=False)
```

---

## 6. JSON Handling

```python
import json

# Reading
with open('config.json', 'r') as f:
    config = json.load(f)

# Writing
config = {'learning_rate': 0.01, 'epochs': 100}
with open('config.json', 'w') as f:
    json.dump(config, f, indent=2)

# Pretty printing
print(json.dumps(config, indent=2))
```

---

## 7. JSONL (JSON Lines) — ML Standard

Each line is a separate JSON object. Ideal for large datasets.

```python
import json

# Writing dataset
with open('dataset.jsonl', 'w') as f:
    for sample in samples:
        f.write(json.dumps(sample) + '\n')

# Reading dataset (memory efficient)
with open('dataset.jsonl', 'r') as f:
    for line in f:
        sample = json.loads(line.strip())
        # process sample
```

**Why JSONL for ML?**
- Append-only (add samples without rewriting)
- Streamable (process line by line)
- Human-readable
- Compatible with distributed processing

---

## 8. Working with Directories

```python
from pathlib import Path

# Create directory tree
Path('models/linear_regression/v1').mkdir(parents=True, exist_ok=True)

# List all CSV files
for f in Path('data').glob('*.csv'):
    print(f.name)

# Recursive glob
for f in Path('.').rglob('*.json'):
    print(f)

# Filter by modification time
files = sorted(Path('logs').iterdir(), key=lambda p: p.stat().st_mtime)
latest = files[-1]
```

---

## 9. File Metadata

```python
from pathlib import Path
import os
import time

p = Path('model.pkl')
stat = p.stat()

stat.st_size        # File size in bytes
stat.st_mtime       # Last modified (Unix timestamp)
stat.st_ctime       # Creation time (Unix timestamp)
os.path.getsize(p)  # Same as st_size

# Human-readable sizes
def format_size(bytes):
    for unit in ['B', 'KB', 'MB', 'GB']:
        if bytes < 1024:
            return f'{bytes:.1f} {unit}'
        bytes /= 1024
    return f'{bytes:.1f} TB'
```

---

## ML-Specific Patterns

### Saving model artifacts
```python
import pickle
import json
from pathlib import Path

# Save model
with open('models/model_v1.pkl', 'wb') as f:
    pickle.dump(model, f)

# Save metadata alongside
metadata = {'accuracy': 0.94, 'features': 128}
with open('models/model_v1_meta.json', 'w') as f:
    json.dump(metadata, f, indent=2)
```

### Reading training data
```python
from pathlib import Path

def load_dataset(data_dir):
    data_dir = Path(data_dir)
    X_train = load_csv(data_dir / 'X_train.csv')
    y_train = load_csv(data_dir / 'y_train.csv')
    return X_train, y_train
```

---

## Key Takeaways

1. **Always use `with`** for file operations — automatic cleanup
2. **Use `pathlib`** for path manipulation (cross-platform, readable)
3. **JSONL** is the ML standard for large datasets
4. **Binary mode** (`'wb'`/`'rb'`) for model artifacts (pickle, joblib)
5. **Check file existence** before operations to avoid errors
6. **Organize artifacts** with metadata files alongside models
