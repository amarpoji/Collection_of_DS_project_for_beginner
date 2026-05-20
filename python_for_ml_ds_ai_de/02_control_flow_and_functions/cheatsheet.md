# Module 02: Control Flow & Functions - Cheatsheet

## if/elif/else

```python
# Basic conditional
if accuracy > 0.9:
    print("Excellent!")
elif accuracy > 0.7:
    print("Good")
else:
    print("Needs improvement")

# Ternary (conditional expression)
status = "pass" if score >= 0.5 else "fail"

# Truthiness check (prefer this)
if my_list:           # instead of: if len(my_list) > 0:
if not my_list:       # instead of: if len(my_list) == 0:
if value is None:     # instead of: if value == None:

# Multiple conditions
if 0 < x < 10:        # chained comparison (Pythonic!)
if x in {1, 2, 3}:    # membership check
```

## for Loops

```python
# Basic iteration
for item in dataset:
    print(item)

# Range-based
for i in range(5):          # 0, 1, 2, 3, 4
for i in range(2, 5):       # 2, 3, 4
for i in range(0, 10, 2):   # 0, 2, 4, 6, 8

# Enumerate (get index + value)
for idx, row in enumerate(dataset, start=1):
    print(f"Row {idx}: {row}")

# Zip (parallel iteration)
for features, label in zip(X, y):
    print(features, label)

# Nested loops
for epoch in range(100):
    for batch in dataloader:
        train(batch)

# Loop with else (rare but useful)
for item in data:
    if found(item):
        break
else:
    print("Item not found")  # runs only if no break
```

## while Loops

```python
# Basic
while loss > threshold:
    loss = train_step()

# Training loop pattern
epoch = 0
while epoch < max_epochs and loss > min_loss:
    loss = train_step()
    epoch += 1

# Infinite loop with break
while True:
    data = get_batch()
    if not data:
        break
    process(data)
```

## List Comprehensions

```python
# Basic
squares = [x**2 for x in range(10)]

# With condition
evens = [x for x in range(10) if x % 2 == 0]

# With if-else
labels = ["positive" if x > 0 else "negative" for x in values]

# Nested
flat = [x for sublist in matrix for x in sublist]
# Equivalent to:
# for sublist in matrix:
#     for x in sublist:
#         flat.append(x)

# Dict comprehension
square_dict = {x: x**2 for x in range(5)}

# Set comprehension
unique_evens = {x for x in numbers if x % 2 == 0}
```

## Lambda Functions

```python
# Syntax: lambda args: expression
square = lambda x: x**2
square(5)  # 25

# Common uses
sorted(data, key=lambda x: x['age'])
sorted(data, key=lambda x: x[1], reverse=True)

# With map (prefer comprehension)
list(map(lambda x: x**2, [1, 2, 3]))
# → [1, 4, 9]

# With filter (prefer comprehension)
list(filter(lambda x: x > 0, [-1, 0, 1, 2]))
# → [1, 2]
```

## *args and **kwargs

```python
def flexible_func(*args, **kwargs):
    """Accept any positional and keyword arguments."""
    print(f"Positional: {args}")    # tuple
    print(f"Keyword: {kwargs}")     # dict

flexible_func(1, 2, 3, name="ML", lr=0.01)
# Positional: (1, 2, 3)
# Keyword: {'name': 'ML', 'lr': 0.01}

# Unpacking arguments
def train(X, y, lr, epochs):
    pass

params = {"lr": 0.01, "epochs": 100}
train(X_train, y_train, **params)

# ML pattern: flexible model config
class ConfigurableModel:
    def __init__(self, **kwargs):
        self.params = kwargs
```

## Scope (LEGB Rule)

```python
# L: Local
# E: Enclosing (nested functions)
# G: Global
# B: Built-in

x = "global"  # Global scope

def outer():
    x = "enclosing"  # Enclosing scope
    
    def inner():
        x = "local"   # Local scope
        print(x)      # "local"
    
    inner()
    print(x)           # "enclosing"

outer()
print(x)               # "global"

# The `global` keyword
counter = 0
def increment():
    global counter
    counter += 1

# The `nonlocal` keyword (for nested functions)
def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment
```

## map/filter/reduce

```python
# map: transform each element
map(lambda x: x**2, [1, 2, 3])    # → [1, 4, 9]
# Prefer: [x**2 for x in [1, 2, 3]]

# filter: keep matching elements
filter(lambda x: x > 0, [-1, 0, 1])  # → [1]
# Prefer: [x for x in [-1, 0, 1] if x > 0]

# reduce: combine into single value
from functools import reduce
reduce(lambda a, b: a + b, [1, 2, 3, 4])  # → 10
# Prefer: sum([1, 2, 3, 4])
```

## Recursion

```python
def factorial(n: int) -> int:
    """Recursive factorial with base case."""
    if n <= 1:
        return 1
    return n * factorial(n - 1)

# Flatten nested lists
def flatten(nested: list) -> list:
    """Flatten arbitrarily nested lists."""
    result = []
    for item in nested:
        if isinstance(item, list):
            result.extend(flatten(item))
        else:
            result.append(item)
    return result

# Recursive tree traversal (ML use)
def depth(tree: dict | None) -> int:
    """Compute depth of a decision tree structure."""
    if tree is None:
        return 0
    return 1 + max(depth(tree.get('left')), depth(tree.get('right')))
```

## ML Data Iteration Patterns

```python
# Mini-batch iteration
def batch_iterator(data: list, batch_size: int = 32):
    """Yield batches from a dataset."""
    for i in range(0, len(data), batch_size):
        yield data[i:i + batch_size]

# Cross-validation folds
def k_fold_indices(n: int, k: int = 5):
    """Generate train/test index pairs for k-fold CV."""
    indices = list(range(n))
    fold_size = n // k
    for i in range(k):
        test_start = i * fold_size
        test_end = (i + 1) * fold_size if i < k - 1 else n
        test_idx = indices[test_start:test_end]
        train_idx = [j for j in indices if j not in test_idx]
        yield train_idx, test_idx

# Feature engineering pipeline
def engineer_features(data: list[dict]) -> list[dict]:
    """Apply multiple feature transformations."""
    transformations = [
        lambda r: {**r, 'age_squared': r['age']**2},
        lambda r: {**r, 'income_log': math.log(r['income'] + 1)},
        lambda r: {**r, 'age_income_ratio': r['age'] / r['income']},
    ]
    for transform in transformations:
        data = [transform(row) for row in data]
    return data
```

## Gotchas

| Gotcha | Explanation | Fix |
|--------|-------------|-----|
| `for i in range(len(lst))` | Unnecessary when you don't need index | `for item in lst` |
| Modifying list during iteration | Skips elements, causes bugs | Iterate over copy: `for x in lst[:]` |
| `lambda` in loop captures last value | All lambdas reference same `i` | Use default arg: `lambda x, i=i: f(x, i)` |
| `zip()` shortest truncation | Stops at shortest iterable | `zip_longest(*iterables, fillvalue=None)` |
| `range(5)` gives 0-4 | Off-by-one errors | Remember exclusive end |
| `while` loop infinite | Forgetting to update condition | Always increment/track progress |
| `x = 0` inside function creates local | Can't modify global without `global` | Use `global x` or return value |
