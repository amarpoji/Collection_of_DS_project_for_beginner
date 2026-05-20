# Module 04: Data Structures Deep Dive

> **Duration:** 16 hours
> **ML Focus:** Choosing the right data structure, performance analysis for large datasets

---

## Why Data Structures Before Algorithms

In ML/DS work, most of your time is not spent on algorithms — it's spent on **data manipulation**. The choice of data structure determines whether your code:

- Runs in 2 seconds or 2 hours
- Uses 1 GB of RAM or 16 GB
- Is readable or incomprehensible

**Real-world analogy:** A list is a bookshelf where you store books in order. A dict is a librarian who instantly knows exactly where every book is. A set is a bouncer who checks IDs at the door — keeps duplicates out.

---

## 1. Lists — The Workhorse

### Internals

- Python lists are **dynamic arrays** (not linked lists!)
- Elements are stored in contiguous memory with **pointers to Python objects**
- **Amortized O(1) append**: When the array is full, Python allocates ~1.125x more space and copies everything over
- This means occasional expensive resizes, but most appends are instant

```
Memory layout:
[ptr0] [ptr1] [ptr2] [ptr3] [   ] [   ]  <- allocated space
  |      |      |      |
  v      v      v      v
 obj0   obj1   obj2   obj3          <- actual objects (anywhere in heap)
```

### When to use lists

- Ordered collection of items
- Need indexing by position
- Iterating in order
- ML: feature lists, prediction outputs, training history

### Performance characteristics

| Operation | Complexity | Notes |
|-----------|------------|-------|
| Index | O(1) | Fastest operation |
| Append | O(1)* | Amortized |
| Insert at start | O(n) | All elements shift |
| Search (in) | O(n) | Linear scan |
| Slice | O(k) | k = slice length |
| Sort | O(n log n) | Timsort algorithm |

### Common ML patterns

```python
# Collecting metrics during training
loss_history = []
for epoch in range(100):
    loss = train_step()
    loss_history.append(loss)  # O(1) amortized

# Feature lists
feature_names = ["age", "income", "score"]
sample = [25, 50000, 0.85]

# List comprehension for preprocessing
processed = [normalize(x) for x in raw_data]
```

---

## 2. Dictionaries — Hash Tables

### Internals

- Dictionaries use **hash tables**
- Each key is hashed, and the hash determines where the (key, value) pair is stored
- **O(1) average** lookup, insert, delete
- Python 3.6+ preserves insertion order (language guarantee in 3.7+)
- Hash collisions are handled with open addressing

```
Hash table structure (simplified):
Index | Key | Value
------|-----|------
  0   | --- | ---
  1   | --- | ---
  2   | "age" | 25    <- hash("age") % size = 2
  3   | --- | ---
  4   | "name" | "Alice"  <- hash("name") % size = 4
```

### When to use dicts

- Mapping between keys and values
- Fast lookups by name/label
- Counting occurrences
- ML: feature-value mappings, hyperparameter configs, model parameters

### Performance characteristics

| Operation | Average | Worst Case |
|-----------|---------|------------|
| Get/Set key | O(1) | O(n) — all keys collide |
| Delete key | O(1) | O(n) |
| Iterate | O(n) | O(n) |
| Key check | O(1) | O(n) |

### Common ML patterns

```python
# Hyperparameter configuration
config = {
    "learning_rate": 0.01,
    "batch_size": 32,
    "num_layers": 3
}

# Counting categories
label_counts = {}
for label in all_labels:
    label_counts[label] = label_counts.get(label, 0) + 1

# Feature-value mapping
sample = {"age": 25, "income": 50000, "education": "masters"}
```

---

## 3. Sets — Unique Elements

- Like dicts but only keys (no values)
- Same hash table implementation
- **O(1)** membership testing
- Perfect for deduplication and set operations

### Set operations in ML

```python
train_ids = set(range(1000))
test_ids = set(range(800, 1200))

overlap = train_ids & test_ids  # Intersection: {800..999}
all_ids = train_ids | test_ids  # Union
only_train = train_ids - test_ids  # Difference
symmetric = train_ids ^ test_ids  # Symmetric difference

# Check if sample_id is valid
if sample_id in valid_ids:  # O(1) — way faster than list
    process(sample_id)
```

---

## 4. Tuples — Immutable Sequences

- Like lists but **immutable** — cannot be modified after creation
- Can be used as dictionary keys (lists cannot)
- Slightly faster than lists for iteration and access
- Perfect for **fixed records** like coordinates, database rows

```python
# ML use: storing fixed-dimension vectors as dict keys
feature_cache = {}
feature_cache[(0.5, 0.3, 0.8)] = "class_a"  # tuple as key

# Return multiple values
def get_dataset_stats(data):
    return (len(data), len(data[0]), sum(sum(row) for row in data))
```

---

## 5. Collections Module

### Counter — Count Hashable Objects

```python
from collections import Counter

# Class distribution in a dataset
labels = ["cat", "dog", "cat", "bird", "dog", "cat"]
counts = Counter(labels)
print(counts)  # Counter({'cat': 3, 'dog': 2, 'bird': 1})

# Most common
print(counts.most_common(2))  # [('cat', 3), ('dog', 2)]

# ML: check for class imbalance
if min(counts.values()) / max(counts.values()) < 0.1:
    print("Severe class imbalance detected")
```

### defaultdict — Auto-default Values

```python
from collections import defaultdict

# Group samples by label
groups = defaultdict(list)
for features, label in dataset:
    groups[label].append(features)

# Nested dicts
metrics = defaultdict(lambda: defaultdict(list))
metrics["model_a"]["accuracy"].append(0.95)
```

### deque — Double-Ended Queue

```python
from collections import deque

# O(1) append/pop from both ends
recent_losses = deque(maxlen=100)  # sliding window
for loss in training_loop:
    recent_losses.append(loss)  # auto-drops oldest

# Fast sliding window operations
window = deque([1, 2, 3], maxlen=3)
window.append(4)  # deque([2, 3, 4])
```

### OrderedDict — Remembers Insertion Order

```python
from collections import OrderedDict

# Python 3.7+ dicts preserve order, but OrderedDict offers:
# - move_to_end(key) — reorder
# - popitem(last=False) — FIFO behavior

model_dict = OrderedDict()
model_dict["lr"] = LogisticRegression()
model_dict["rf"] = RandomForest()
model_dict.move_to_end("lr")  # Move to end
```

---

## 6. heapq — Priority Queues

```python
import heapq

# Find top-k largest values (e.g., top features)
scores = [0.1, 0.8, 0.3, 0.9, 0.4, 0.7]
top_3 = heapq.nlargest(3, scores)  # [0.9, 0.8, 0.7]

# ML: feature importance ranking
importance = {"age": 0.4, "income": 0.8, "education": 0.2}
top_features = heapq.nlargest(2, importance, key=importance.get)
```

## 7. bisect — Binary Search on Sorted Lists

```python
import bisect

# Maintain sorted list (e.g., threshold values)
thresholds = [0.1, 0.3, 0.5, 0.7, 0.9]
pos = bisect.bisect_left(thresholds, 0.45)  # index 2
print(pos)  # 2 — insert at position 2 to keep sorted

# ML: find probability bin for calibration
prob = 0.67
bin_idx = bisect.bisect_left(thresholds, prob)  # 4
```

---

## Choosing the Right Data Structure

```python
# For this ML task, which is fastest?

# TASK: Check if 10,000 IDs are in a set of 1,000,000 valid IDs
valid_ids_set = set(valid_ids)      # <--- WINNER (O(1) each)
valid_ids_list = list(valid_ids)    # O(n) each — 1000x slower

# TASK: Count word frequencies in 10,000 documents
word_counts = Counter()             # <--- WINNER (built for this)
# vs
word_counts = {}                    # Works, but more code

# TASK: Maintain 100 most recent training losses
loss_history = deque(maxlen=100)    # <--- WINNER (O(1) push, auto-drop)
# vs
loss_history = []                   # Manual cleanup needed

# TASK: Find top-10 features by importance score
top_features = heapq.nlargest(10, features, key=scores.get)  # WINNER
# vs
sorted(features, key=scores.get, reverse=True)[:10]  # Sorts ALL
```

---

## Beginner Mistakes

1. **Using lists for membership tests** — `if x in list_with_100k_items` is O(n), use a set
2. **Mutating a dict while iterating** — `for k in d: del d[k]` raises RuntimeError
3. **Forgetting Counter is a dict** — missing keys return 0, not error
4. **Using list as dict key** — TypeError: unhashable type: 'list'. Use tuple
5. **Not understanding amortized O(1)** — occasional list resize is normal
6. **Using `OrderedDict` when a regular dict works** — Python 3.7+ dicts are ordered

## Best Practices

- **Use sets for deduplication** — `unique = set(data)` is simpler and faster than loops
- **Use `defaultdict` for grouping** — cleaner than checking `if key in dict`
- **Use `Counter` for counting** — less code, more readable
- **Use `deque(maxlen=N)` for sliding windows** — automatic memory management
- **Use `heapq.nlargest/nsmallest`** — O(n log k) instead of O(n log n) for sorting all

## Interview Questions

1. How does Python's dict handle hash collisions?
2. What's the time complexity of `list.append()`? Why is it "amortized O(1)"?
3. Why can't you use a list as a dictionary key?
4. How would you find the top 100 most frequent items in a 10GB file?
5. What's the difference between `Counter` and `defaultdict(int)`?
6. When would you use `bisect` instead of sorting and searching?

## Practice Questions

1. Given a list of 1 million numbers, find the 10 most frequent values.
2. Implement a sliding window median using `deque` and `bisect`.
3. Compare the performance of `list` vs `set` for membership testing with 100k elements.
4. Use `defaultdict` to group a list of (category, value) pairs by category.
5. Implement a simple LRU cache using `OrderedDict`.

## Common Pitfalls

- **`dict.keys()` returns a view, not a list** — it's dynamic, not a snapshot
- **`set` elements must be hashable** — lists and dicts won't work
- **`deque` is not thread-safe** — use `queue.Queue` for threading
- **`heapq` implements min-heaps** — use `-value` or `nlargest` for max-heap

## Additional Resources

- [Python TimeComplexity wiki](https://wiki.python.org/moin/TimeComplexity)
- [CPython dict implementation (GitHub)](https://github.com/python/cpython/blob/main/Objects/dictobject.c)
- [Fluent Python — Chapter on Dictionaries](https://www.oreilly.com/library/view/fluent-python-2nd/9781492056348/)
- [Raymond Hettinger — Modern Python Dictionaries](https://www.youtube.com/watch?v=p33CVV29OG8)

## Summary

| Structure | Lookup | Insert | Memory | Use Case |
|-----------|--------|--------|--------|----------|
| List | O(n) | O(1)* | Low | Ordered sequences |
| Dict | O(1) | O(1) | Medium | Key-value mappings |
| Set | O(1) | O(1) | Medium | Dedup, membership |
| Tuple | O(1) read | N/A | Low | Fixed records |
| Counter | O(1) | O(1) | Medium | Counting |
| defaultdict | O(1) | O(1) | Medium | Grouping |
| deque | O(1) ends | O(1) | Medium | Sliding windows |
| heapq | O(log n) top | O(log n) | Low | Priority queues |
| bisect | O(log n) | O(n) ins | Low | Sorted insertion |
