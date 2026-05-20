# Module 05: File Handling & OS — Cheatsheet

## Opening Files

```python
# Context manager (always use this!)
with open('file.txt', 'r') as f:
    content = f.read()
# Auto-closes, even on exceptions

# Modes: 'r' read, 'w' write (overwrite), 'a' append, 'rb'/'wb' binary
# 'r+' read+write, 'x' exclusive creation (fail if exists)
```

## Reading Methods

| Method | Returns | Use Case |
|--------|---------|----------|
| `f.read()` | Single string | Small files |
| `f.readline()` | One line | Streaming |
| `f.readlines()` | List of lines | Medium files |
| `for line in f` | Iterator | Large files (memory efficient) |

## Writing

```python
with open('out.txt', 'w') as f:
    f.write('text\n')
    f.writelines(['line1\n', 'line2\n'])
```

## pathlib (Modern, Preferred)

```python
from pathlib import Path

p = Path('data/raw/train.csv')
p.parent       # Path('data/raw')
p.name         # 'train.csv'
p.stem         # 'train'
p.suffix       # '.csv'
p.exists()     # bool
p.is_file()    # bool
p.is_dir()     # bool
p.mkdir(parents=True, exist_ok=True)
p.stat().st_size  # file size in bytes

# Path joining
data_dir = Path('data')
csv_path = data_dir / 'raw' / 'train.csv'

# Globbing
list(Path('.').glob('*.csv'))
list(Path('.').rglob('*.json'))   # recursive
```

## os Module (Traditional)

```python
import os
os.getcwd()           # current directory
os.listdir('.')       # list files
os.makedirs('a/b/c', exist_ok=True)
os.remove('file.txt')
os.rename('old', 'new')
os.path.getsize('f')  # file size
os.environ['KEY']     # env variables
```

## CSV

```python
import csv
# Reading
with open('data.csv', 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row['column_name'])

# Writing
with open('out.csv', 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['a', 'b'])
    writer.writeheader()
    writer.writerows([{'a': 1, 'b': 2}])
```

## JSON

```python
import json
# Read
with open('config.json', 'r') as f:
    data = json.load(f)
# Write
with open('config.json', 'w') as f:
    json.dump(data, f, indent=2)
```

## JSONL (ML Standard for Large Datasets)

```python
import json
# Write (one JSON object per line)
with open('data.jsonl', 'w') as f:
    for sample in samples:
        f.write(json.dumps(sample) + '\n')

# Read (memory efficient, process line by line)
with open('data.jsonl', 'r') as f:
    for line in f:
        sample = json.loads(line.strip())
```

## File Metadata

```python
from pathlib import Path
p = Path('file.txt')
s = p.stat()
s.st_size      # bytes
s.st_mtime     # Unix timestamp
s.st_ctime     # creation time

import time
time.ctime(s.st_mtime)  # human readable
```

## ML Patterns

```python
# Save model artifact + metadata
import pickle
with open('model.pkl', 'wb') as f:
    pickle.dump(model, f)

import json
meta = {'accuracy': 0.94, 'features': 128}
with open('model_meta.json', 'w') as f:
    json.dump(meta, f, indent=2)
```

## Common Pitfalls

- **Forgetting `newline=''`** in CSV writer → extra blank lines
- **Not using `with`** → file handle leaks
- **`read()` on huge files** → memory error
- **Binary mode for pickle** → 'wb'/'rb' not 'w'/'r'
- **Hardcoding paths** → use pathlib for cross-platform
