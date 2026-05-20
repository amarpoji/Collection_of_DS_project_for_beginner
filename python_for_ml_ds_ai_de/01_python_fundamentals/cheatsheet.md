# Module 01: Python Fundamentals - Cheatsheet

## Variables & Types

```python
# Dynamic typing: variables can hold any type
x: int = 42           # type hint (optional, for clarity)
y: float = 3.14159
z: str = "hello"
b: bool = True
n: None = None

# Type checking
type(x)               # <class 'int'>
isinstance(y, float)  # True

# Type conversion (casting)
int("42")             # 42
float("3.14")         # 3.14
str(42)               # "42"
bool(1)               # True
bool([])              # False (empty → falsy)
```

## Numbers

```python
# Integers (unbounded)
a = 42
b = -7
c = 0

# Floats (IEEE 754 double precision)
pi = 3.14159
small = 1e-10         # scientific notation
inf = float('inf')
nan = float('nan')

# Operations
a + b                 # addition
a - b                 # subtraction
a * b                 # multiplication
a / b                 # true division (returns float)
a // b                # floor division (returns int)
a % b                 # modulo
a ** b                # exponentiation

# Division always returns float in Python 3
5 / 2   # 2.5
5 // 2  # 2
-5 // 2 # -3 (floor, not truncate!)

# Rounding
round(3.14159, 2)     # 3.14
abs(-5)               # 5

# FP precision warning
0.1 + 0.2 == 0.3      # False! (0.30000000000000004)
round(0.1 + 0.2, 1) == 0.3  # True
```

## Strings

```python
# Creation
s1 = 'single quotes'
s2 = "double quotes"
s3 = """multi
line"""
s4 = r'raw\nstring'   # raw string, \n is literal

# f-strings (Python 3.6+, prefer this)
name = "accuracy"
value = 0.953
f"{name}: {value:.1%}"           # "accuracy: 95.3%"
f"{value:.4f}"                   # "0.9530"
f"{value:>10}"                   # right-align in 10 chars

# Methods
s = "  hello world  "
s.upper()             # "  HELLO WORLD  "
s.lower()             # "  hello world  "
s.strip()             # "hello world"
s.split()             # ["hello", "world"]
s.replace("world", "ML")  # "  hello ML  "
", ".join(["a", "b"])      # "a, b"
s.startswith("hel")   # True
s.find("world")       # 8 (index, -1 if not found)

# Indexing & slicing
s = "python"
s[0]      # 'p'
s[-1]     # 'n'
s[1:4]    # 'yth'
s[:3]     # 'pyt'
s[3:]     # 'hon'
s[::-1]   # 'nohtyp' (reverse)

# Strings are immutable!
s[0] = 'P'  # TypeError!
```

## Booleans & None

```python
# Boolean operators
True and False    # False
True or False     # True
not True          # False

# Truthiness — falsy values:
# False, None, 0, 0.0, "", [], {}, set()
bool([])          # False
bool([1, 2])      # True

# None
x = None
x is None         # True (use 'is', not ==)
x is not None     # False

# Short-circuit evaluation
def get_data():
    return []

data = get_data() or []  # returns [] if function returns falsy
```

## Lists

```python
# Creation
lst = [1, 2, 3, 4, 5]
mixed = [1, "hello", 3.14, True]
nested = [[1, 2], [3, 4]]

# Indexing
lst[0]        # 1
lst[-1]       # 5

# Slicing
lst[1:3]      # [2, 3]
lst[::2]      # [1, 3, 5]
lst[::-1]     # [5, 4, 3, 2, 1]

# Methods — MUTABLE!
lst.append(6)       # [1,2,3,4,5,6]
lst.extend([7,8])   # [1,2,3,4,5,6,7,8]
lst.insert(0, 0)    # [0,1,2,...]
lst.remove(3)       # removes first 3
lst.pop()           # removes & returns last
lst.pop(0)          # removes & returns index 0
lst.sort()          # in-place sort
lst.reverse()       # in-place reverse
lst.index(4)        # index of first 4
lst.count(2)        # how many 2's

# List as stack
stack = []
stack.append(1)     # push
stack.pop()         # pop (1)

# List as queue (use collections.deque for efficiency)
from collections import deque
q = deque([1, 2, 3])
q.popleft()         # 1
```

## Tuples

```python
# Immutable ordered collection
t = (1, 2, 3)
single = (1,)     # trailing comma required!
coordinates = (10.5, 20.3)

# Unpacking
x, y, z = t       # x=1, y=2, z=3
first, *rest = t  # first=1, rest=[2,3]

# Methods (only 2)
t.count(1)        # count occurrences
t.index(2)        # index of value
```

## Dicts

```python
# Creation
d = {"name": "Alice", "age": 30}
d = dict(name="Alice", age=30)
d = dict(zip(["a", "b"], [1, 2]))

# Access
d["name"]         # "Alice" (KeyError if missing)
d.get("name")     # "Alice"
d.get("salary", 0)  # 0 (default if missing)
d.setdefault("city", "NYC")  # set if missing

# Modification
d["age"] = 31     # update
d["salary"] = 50000  # add new key

# Delete
del d["age"]
d.pop("name")     # remove & return value
d.pop("nonexistent", None)  # safe removal

# Iteration
for key in d:                  # keys
for key in d.keys():           # explicit keys
for val in d.values():         # values
for k, v in d.items():         # key-value pairs

# Dict comprehensions
squares = {x: x**2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# Merging (Python 3.9+)
d1 = {"a": 1, "b": 2}
d2 = {"b": 3, "c": 4}
merged = d1 | d2   # {"a": 1, "b": 3, "c": 4}
```

## Sets

```python
# Unordered collection of unique, hashable items
s = {1, 2, 3, 3, 3}  # {1, 2, 3}
s = set([1, 2, 2, 3])  # {1, 2, 3}

# Operations
s.add(4)
s.remove(4)       # KeyError if missing
s.discard(4)      # no error if missing
s.pop()           # remove & return arbitrary element

# Set operations
a = {1, 2, 3}
b = {3, 4, 5}

a | b   # union: {1,2,3,4,5}
a & b   # intersection: {3}
a - b   # difference: {1,2}
a ^ b   # symmetric diff: {1,2,4,5}
a <= b  # subset check
a >= b  # superset check

# Set comprehension
evens = {x for x in range(10) if x % 2 == 0}
```

## Common ML Data Patterns

```python
# Dataset as list of dicts
dataset = [
    {"age": 25, "salary": 50000, "purchased": True},
    {"age": 30, "salary": 60000, "purchased": False},
    {"age": 35, "salary": 70000, "purchased": True},
]

# Extract a feature column
ages = [row["age"] for row in dataset]
# [25, 30, 35]

# Feature matrix (list of lists)
X = [[row["age"], row["salary"]] for row in dataset]
# [[25, 50000], [30, 60000], [35, 70000]]

# Target vector
y = [row["purchased"] for row in dataset]
# [True, False, True]

# Feature names
features = list(dataset[0].keys())
# ["age", "salary", "purchased"]

# One-hot encoding manually
categories = ["cat", "dog", "bird", "cat"]
unique = list(set(categories))  # ["bird", "cat", "dog"]
one_hot = [[1 if c == u else 0 for u in unique] for c in categories]
```

## Gotchas

| Issue | Fix |
|-------|-----|
| `a = b = []` creates shared reference | `a = []; b = []` |
| `def f(x=[])` shares default | `def f(x=None): x = x or []` |
| `(1)` is int, not tuple | `(1,)` |
| `0.1 + 0.2 != 0.3` | Use `math.isclose()` or `round()` |
| `list.remove()` removes only first match | Loop or list comprehension for all |
| Modifying list while iterating | Iterate over `list[:]` copy |
| `==` vs `is` for None | Use `x is None` |
| `d.keys()` returns view (not copy) in Python 3 | `list(d.keys())` if you need a copy |
