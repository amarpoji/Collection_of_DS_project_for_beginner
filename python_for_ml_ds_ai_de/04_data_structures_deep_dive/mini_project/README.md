# Mini Project: Data Structure Performance Analyzer

## Problem Statement

You are building a **Data Structure Performance Analyzer** — a tool that benchmarks different Python data structures on realistic ML/DS workloads and recommends the optimal choice.

Your goal is to write a script that:
1. Generates synthetic datasets of varying sizes (1K, 10K, 100K, 1M)
2. Benchmarks different data structures on identical tasks
3. Produces a performance report showing which structure wins and why
4. Recommends the optimal data structure for common ML operations

## Dataset

Generate synthetic data inline (no external files):

```python
import random
import time
import sys

random.seed(42)

def generate_dataset(n):
    """Generate n samples of (id, features, label)."""
    dataset = []
    for i in range(n):
        sample_id = i
        features = [random.random() for _ in range(10)]  # 10 features
        label = random.choice(["cat", "dog", "bird"])
        dataset.append((sample_id, features, label))
    return dataset
```

## Deliverables

Create a single Python file `perf_analyzer.py` containing:

### 1. Benchmark Functions (one per data structure)

Implement these benchmarking scenarios:

| # | Scenario | Data Structures to Compare | Metric |
|---|----------|---------------------------|--------|
| 1 | Membership test: check if 1000 IDs exist | `list` vs `set` | Time |
| 2 | Grouping data by label | `dict` vs `defaultdict` | Time + code lines |
| 3 | Counting label frequencies | `dict` vs `Counter` | Time + code lines |
| 4 | Finding top-10 features by importance | `sorted()` vs `heapq.nlargest` | Time |
| 5 | Sliding window mean of 50 recent values | `list` vs `deque` | Time |

### 2. `PerformanceReport` Class

```python
@dataclass
class BenchmarkResult:
    scenario: str
    data_size: int
    structure_a: str
    time_a: float
    structure_b: str
    time_b: float
    winner: str
    speedup: float
```

### 3. `DataStructureRecommender` Class

- Takes results from benchmarks
- Provides `best_for(scenario)` method
- Provides `summary_table()` method that prints a formatted table
- Provides `recommend(operation_type)` — given an operation (e.g., "membership", "grouping", "counting", "topk", "sliding"), returns the best data structure

### 4. Report Generation

Run all benchmarks at 3 different sizes (1K, 10K, 100K) and print a final report:

```
DATA STRUCTURE PERFORMANCE REPORT
==================================

Scenario: Membership Test (100000 items)
  list:  0.0452 sec
  set:   0.0001 sec
  WINNER: set (452x faster)

Scenario: Grouping by Label (100000 items)
  dict:  0.0089 sec
  defaultdict: 0.0067 sec
  WINNER: defaultdict (1.3x faster, less code)

...

RECOMMENDATIONS:
  membership  -> set
  grouping    -> defaultdict
  counting    -> Counter
  top-k       -> heapq.nlargest
  sliding     -> deque
```

## Evaluation Criteria

| Criteria | Points |
|----------|--------|
| All 5 benchmark scenarios implemented | 25 |
| Benchmarks run at 3 different sizes | 15 |
| `PerformanceReport` class works correctly | 15 |
| `DataStructureRecommender` with `best_for()` and `recommend()` | 15 |
| Results printed in clean report format | 10 |
| Code uses `Counter`, `defaultdict`, `deque`, `heapq` correctly | 10 |
| Code runs without errors at all sizes | 5 |
| Docstrings and type hints present | 5 |

## Hints & Tips

1. **Use `time.perf_counter()`** for accurate timing — not `time.time()`
2. **Warm up** each benchmark with a small run before timing
3. **Run each benchmark 3 times** and take the minimum time (not average) to reduce noise
4. **For membership test**, make half the test items actually present and half absent
5. **For grouping**, use the label as the key and append features to a list
6. **For counting**, use `Counter` vs manual `dict.get()` loop
7. **For top-k**, compare `sorted(lst, reverse=True)[:k]` vs `heapq.nlargest(k, lst)`
8. **For sliding window**, compare manual list management with `list.pop(0)` vs `deque.popleft()`
9. **Handle the 1M size gracefully** — if it takes too long, skip it or reduce iterations
10. **Print intermediate progress** so the user knows the script isn't stuck

## Extension Ideas (Bonus)

- Add memory usage measurement (`sys.getsizeof`) alongside time
- Visualize results as ASCII bar charts
- Add a `DataStructureWizard` CLI that asks what you want to do and recommends a structure
- Benchmark additional structures: `OrderedDict`, `ChainMap`, `array.array`
- Automatically generate a markdown report file
- Test with worst-case scenarios (e.g., all hash collisions for dict)
