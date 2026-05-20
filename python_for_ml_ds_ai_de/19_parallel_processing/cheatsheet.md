# Parallel Processing — Cheatsheet

## threading vs multiprocessing vs asyncio

| Feature | threading | multiprocessing | asyncio |
|---------|-----------|----------------|---------|
| Best for | IO-bound tasks | CPU-bound tasks | IO-bound (many connections) |
| Parallelism | Concurrency only (GIL) | True parallelism | Cooperative concurrency |
| Memory | Shared (same process) | Separate (each process) | Shared (single-threaded) |
| Overhead | Low | High | Very low |
| GIL affected | Yes | No (separate interpreters) | Yes |
| Use case | File I/O, network calls | ML training, CPU processing | Web servers, async APIs |

## GIL (Global Interpreter Lock)

```python
# GIL prevents true parallelism in threads for CPU-bound code
# Only one thread executes Python bytecode at a time
# C extensions (NumPy, pandas) release the GIL during computation
# Solution for CPU-bound: use multiprocessing

# Python 3.13+: free-threaded mode (--disable-gil)
```

## Threading

```python
import threading
import time

def worker(name, delay):
    time.sleep(delay)
    print(f'Worker {name} done')

threads = []
for i in range(5):
    t = threading.Thread(target=worker, args=(i, 0.5))
    t.start()
    threads.append(t)

for t in threads:
    t.join()
```

## concurrent.futures

### ThreadPoolExecutor (IO-bound)

```python
from concurrent.futures import ThreadPoolExecutor, as_completed
import time

def fetch_url(url):
    time.sleep(0.1)  # Simulate IO
    return f'Data from {url}'

urls = ['url1', 'url2', 'url3', 'url4', 'url5']

with ThreadPoolExecutor(max_workers=3) as executor:
    futures = [executor.submit(fetch_url, url) for url in urls]
    for future in as_completed(futures):
        print(future.result())
```

### ProcessPoolExecutor (CPU-bound)

```python
from concurrent.futures import ProcessPoolExecutor

def cpu_intensive(n):
    return sum(i * i for i in range(n))

with ProcessPoolExecutor(max_workers=4) as executor:
    results = list(executor.map(cpu_intensive, [1000000, 2000000]))
```

## Multiprocessing Pool

```python
from multiprocessing import Pool, cpu_count

def square(x):
    return x * x

with Pool(processes=cpu_count()) as pool:
    results = pool.map(square, range(100))
    # pool.starmap for multiple arguments
    # pool.imap for lazy iteration
```

## Shared Memory

```python
from multiprocessing import Value, Array, shared_memory
import numpy as np

# Using Value
counter = Value('i', 0)

# Using shared_memory (numpy)
import multiprocessing.shared_memory as shm
shm = shared_memory.SharedMemory(name='ml_data', create=True, size=1000 * 8)
arr = np.ndarray((1000,), dtype=np.float64, buffer=shm.buf)
```

## AsyncIO

```python
import asyncio

async def fetch_data(url):
    await asyncio.sleep(0.1)  # Simulate async IO
    return f'Data from {url}'

async def main():
    tasks = [fetch_data(f'url{i}') for i in range(5)]
    results = await asyncio.gather(*tasks)
    return results

results = asyncio.run(main())
```

## ML Parallel Processing

```python
# sklearn already parallelizes internally
from sklearn.ensemble import RandomForestClassifier

model = RandomForestClassifier(n_jobs=-1)  # Uses all cores

# Parallel preprocessing
from concurrent.futures import ProcessPoolExecutor
import pandas as pd

def preprocess_chunk(chunk):
    return chunk.dropna()

df = pd.DataFrame({'a': [1, None, 3], 'b': [4, 5, None]})
chunks = [df.iloc[i::4] for i in range(4)]

with ProcessPoolExecutor() as executor:
    processed = list(executor.map(preprocess_chunk, chunks))

# Batch inference
def predict_batch(model, batch):
    return model.predict(batch)

with ProcessPoolExecutor() as executor:
    predictions = list(executor.map(
        lambda b: predict_batch(model, b), batches
    ))
```

## Decision Framework

```
Is the task IO-bound or CPU-bound?
├── IO-bound (network, disk, API calls)
│   ├── Many concurrent connections?  -> asyncio
│   └── Few connections?              -> threading / ThreadPoolExecutor
└── CPU-bound (computation, ML training)
    ├── Pure Python?                   -> multiprocessing / ProcessPoolExecutor
    └── Uses NumPy/C extensions?      -> Let library handle it (n_jobs=-1)
```

## Common Pitfalls

| Mistake | Fix |
|---------|-----|
| Using threads for CPU-bound work | Use multiprocessing instead |
| Ignoring GIL with CPU-bound threads | Measure before optimizing |
| Creating too many processes | Use cpu_count() as guide |
| Not protecting shared data | Use locks or avoid sharing |
| Mixing asyncio and blocking code | Use asyncio.to_thread() or loop.run_in_executor() |
| Over-engineering parallelism | Start single-threaded, profile, then parallelize |
