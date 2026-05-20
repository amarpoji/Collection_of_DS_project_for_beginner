# Module 04: Data Structures Deep Dive — Cheatsheet

## Performance at a Glance

| Structure | Get | Set/Add | Delete | Search | Memory |
|-----------|-----|---------|--------|--------|--------|
| `list` | O(1) idx | O(1)* append | O(n) pop(0) | O(n) | Low |
| `dict` | O(1) key | O(1) key | O(1) key | O(1) key | Medium |
| `set` | O(1) | O(1) | O(1) | O(1) | Medium |
| `tuple` | O(1) idx | N/A | N/A | O(n) | Low |
| `deque` | O(1) ends | O(1) both | O(1) both | O(n) | Medium |
| `heapq` | O(1) min | O(log n) | O(log n) min | O(n) | Low |
| `bisect` | O(log n) | O(n) ins | O(n) | O(log n) | Low |

## Lists

```python
# Creation
lst = [1, 2, 3]
lst = list(range(10))
lst = [x**2 for x in range(10)]  # list comprehension

# Operations
lst.append(4)       # O(1)* — amortized
lst.insert(0, 0)    # O(n) — slow!
lst.pop()           # O(1) — from end
lst.pop(0)          # O(n) — slow!
lst.sort()          # O(n log n)
x in lst            # O(n) — linear scan
lst[i]              # O(1)
lst[i:j]            # O(k) slice

# ML pattern: collect metrics
losses = []
for epoch in range(100):
    losses.append(compute_loss())
avg = sum(losses) / len(losses)
```

## Dictionaries

```python
# Creation
d = {"a": 1, "b": 2}
d = dict(a=1, b=2)
d = {k: v for k, v in zip(keys, values)}  # dict comprehension

# Operations
d["c"] = 3          # O(1)
x = d.get("z", 0)   # O(1) — safe get with default
del d["a"]          # O(1)
"a" in d            # O(1)
d.keys()            # view, not copy
d.values()          # view
d.items()           # view

# ML pattern: config
config = {"lr": 0.01, "batch_size": 32, "epochs": 10}

# ML pattern: counting
counts = {}
for label in labels:
    counts[label] = counts.get(label, 0) + 1
```

## Sets

```python
# Creation
s = {1, 2, 3}
s = set([1, 2, 2, 3])      # dedup: {1, 2, 3}

# Operations
s.add(4)                    # O(1)
s.remove(4)                 # O(1) — raises KeyError
s.discard(4)                # O(1) — no error if missing
x in s                      # O(1) — FAST

# Set algebra
a & b   # intersection
a | b   # union
a - b   # difference
a ^ b   # symmetric diff
a <= b  # subset check

# ML pattern: detect data leakage
train_ids = set(train_indices)
test_ids = set(test_indices)
leakage = train_ids & test_ids
if leakage:
    print("LEAKAGE:", leakage)
```

## Tuples

```python
# Creation
t = (1, 2, 3)
t = 1, 2, 3     # tuple packing (parens optional)
t = ()          # empty
t = (1,)        # single element — NOTE comma

# Can be dict keys (unlike lists)
cache = {}
cache[(0.5, 0.3)] = "class_a"

# Multiple return values
def stats(data):
    return (len(data), sum(data) / len(data))
```

## collections.Counter

```python
from collections import Counter

c = Counter(["a", "b", "a", "c", "b", "a"])
c["a"]              # 3
c.most_common(2)    # [("a", 3), ("b", 2)]
c.update(["a", "d"])  # add more
c["z"]              # 0 (no KeyError!)
list(c.elements())  # expand to list
c.total()           # sum of all counts (3.10+)
```

## collections.defaultdict

```python
from collections import defaultdict

# List factory — for grouping
groups = defaultdict(list)
groups["cat"].append(0.5)   # no KeyError

# Int factory — for counting
counts = defaultdict(int)
counts["cat"] += 1           # starts at 0

# Nested
nested = defaultdict(lambda: defaultdict(list))
nested["model"]["loss"].append(0.5)

# Custom factory
default = defaultdict(lambda: "missing")
```

## collections.deque

```python
from collections import deque

dq = deque(maxlen=100)      # fixed-size sliding window
dq.append(1)                # O(1) right
dq.appendleft(2)            # O(1) left
dq.pop()                    # O(1) right
dq.popleft()                # O(1) left — fast!
dq[0]                       # O(1) index ends
dq.rotate(3)                # rotate right
list(dq)                    # convert to list

# ML: sliding window statistics
window = deque(maxlen=50)
for reading in data_stream:
    window.append(reading)
    avg = sum(window) / len(window)
```

## heapq

```python
import heapq

# Basic heap operations
heap = []
heapq.heappush(heap, 5)     # O(log n)
heapq.heappop(heap)         # O(log n) — returns smallest
heap[0]                     # O(1) — peek smallest

# Convert list to heap
heapq.heapify(lst)          # O(n)

# Top-K (extremely useful for ML)
top_5 = heapq.nlargest(5, scores)      # O(n log k)
bottom_3 = heapq.nsmallest(3, scores)  # O(n log k)

# With key function
top_features = heapq.nlargest(5, importance_dict, key=importance_dict.get)
```

## bisect

```python
import bisect

# Binary search on sorted list
sorted_lst = [0.1, 0.3, 0.5, 0.7, 0.9]
i = bisect.bisect_left(sorted_lst, 0.45)   # find insertion point
j = bisect.bisect_right(sorted_lst, 0.45)  # rightmost insertion

# Insert while keeping sorted
bisect.insort(sorted_lst, 0.45)  # O(n) for insert + O(log n) for find

# Range queries
left = bisect.bisect_left(sorted_lst, 0.3)
right = bisect.bisect_right(sorted_lst, 0.7)
in_range = sorted_lst[left:right]
```

## Gotchas to Remember

| Gotcha | Problem | Fix |
|--------|---------|-----|
| List as dict key | `TypeError: unhashable type` | Use tuple |
| Mutating dict while iterating | `RuntimeError: dictionary changed size` | Iterate over `list(d.items())` |
| `list.pop(0)` is O(n) | Slow for queues | Use `deque.popleft()` |
| `x in list` is O(n) | Slow for large lists | Use `set` |
| `OrderedDict` in Python 3.7+ | Redundant — regular dicts are ordered | Just use `dict` |
| Default mutable arg | `def f(x=[])` shares list | Use `def f(x=None)` |
| `Counter` missing key | Returns 0, not error | That's actually fine! |
| `deque` not thread-safe | Race conditions | Use `queue.Queue` |

## Quick Decision Tree

```
What are you doing?
├── Looking up by position?  → list
├── Looking up by key/name?  → dict
├── Checking membership?     → set
├── Counting things?         → Counter
├── Grouping by key?         → defaultdict
├── Sliding window?          → deque (maxlen=N)
├── Top-K items?             → heapq.nlargest
├── Sorted range query?      → bisect
└── Fixed immutable record?  → tuple
```
