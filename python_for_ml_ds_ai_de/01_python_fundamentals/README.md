# Module 01 — Python Fundamentals

> **Estimated Time:** 20 hours  
> **Difficulty:** ⭐⭐ Beginner  
> **Prerequisites:** Module 00 (Environment Setup)

---

## 🎯 Learning Objectives

By the end of this module, you will be able to:
- Understand Python's type system (dynamic typing, strong typing)
- Use numbers, strings, booleans, and None correctly
- Work with lists, tuples, dicts, and sets
- Format strings professionally with f-strings
- Handle type conversions safely
- Write clean, PEP8-compliant variable names
- Represent data science data using built-in types

---

## 📖 Understanding Python from First Principles

### What is Python?

Python is a **high-level, dynamically-typed, interpreted language**.

Let's break that down:

- **High-level** — You don't manage memory or CPU registers. Python handles that.
- **Dynamically-typed** — Variables don't have fixed types. The type is determined at runtime.
- **Interpreted** — Code runs line by line, not compiled ahead of time.

**Analogy:** Think of Python as a **smart assistant**:
- High-level: You say "bake a cake" not "preheat to 350°F, mix flour..."
- Dynamic: You can hand them flour, then later hand them eggs — they adapt
- Interpreted: They read the recipe one step at a time, executing as they go

### Python's Design Philosophy (The Zen of Python)

```python
import this
```

Key principles:
- **Beautiful is better than ugly** — Code should be readable
- **Explicit is better than implicit** — Be clear about intent
- **Simple is better than complex** — Don't over-engineer
- **Readability counts** — Code is written for humans, not machines

---

## 1. Variables and Types

### Variables as Labels, Not Boxes

In many languages (C, Java), a variable is a **box** that holds a value. In Python, a variable is a **label** you stick on an object.

```
# Python: labels on objects
┌──────┐     ┌───────────┐
│  x   │────▶│   42      │
└──────┘     │ (integer) │
             └───────────┘
┌──────┐     ┌───────────┐
│  y   │────▶│  "hello"  │
└──────┘     │ (string)  │
             └───────────┘
```

This means you can re-label an object:

```python
x = 42      # x labels the integer 42
x = "hello"  # x now labels the string "hello"
            # The integer 42 still exists, just no label on it
```

### Built-in Types

```python
# Numeric Types
age: int = 25              # Integer (unbounded)
pi: float = 3.14159         # Floating point
complex_num: complex = 3 + 4j  # Complex number

# Sequence Types
name: str = "Alice"         # String
coordinates: list = [10, 20]  # List (mutable)
rgb: tuple = (255, 128, 0)   # Tuple (immutable)

# Mapping Type
person: dict = {"name": "Bob", "age": 30}  # Dictionary

# Set Types
unique_ids: set = {1, 2, 3}  # Set (unique, unordered)

# Boolean Type
is_active: bool = True       # True or False

# None Type
result: None = None          # Absence of value
```

### Type System: Dynamic but Strong

```python
# Dynamic: variable can change type
x = 10        # x is int
x = "hello"   # x is now str (no error)

# Strong: Python won't silently convert
"hello" + 42  # TypeError! (unlike JavaScript which gives "hello42")
```

---

## 2. Numbers: int, float, complex

### Integers (int)

Python integers have **arbitrary precision** — they can be as large as memory allows:

```python
# Regular integers
count: int = 100
negative: int = -5

# Integer operations
print(10 + 3)    # 13  (addition)
print(10 - 3)    # 7   (subtraction)
print(10 * 3)    # 30  (multiplication)
print(10 / 3)    # 3.333...  (division → float!)
print(10 // 3)   # 3   (floor division)
print(10 % 3)    # 1   (modulo/remainder)
print(10 ** 3)   # 1000  (exponentiation)

# Big integers
big = 10 ** 100  # This works! A googol
print(big)
```

### Floating Point (float)

```python
# Float representation
pi: float = 3.14159
scientific: float = 1.5e-4  # 0.00015

# ⚠️ The Floating Point Problem
print(0.1 + 0.2)  # 0.30000000000000004 (not 0.3!)
print(0.1 + 0.2 == 0.3)  # False!

# Why? Computers represent numbers in binary.
# 0.1 in binary is an infinite repeating fraction (like 1/3 in decimal)
# Solution: use decimal for money, or allow tolerance
from math import isclose
print(isclose(0.1 + 0.2, 0.3))  # True
```

### 💡 Real-World ML Implication

```python
# Feature scaling can accumulate floating-point errors
import numpy as np
values = np.array([0.1, 0.2, 0.3, 0.4])
print(np.sum(values))  # May not be exactly 1.0
# Always use isclose() or np.allclose() for float comparisons
```

---

## 3. Strings

### String Fundamentals

```python
# Creating strings
single: str = 'Hello'
double: str = "World"
multi: str = """This is a
multi-line string"""

# Strings are sequences (indexable, sliceable)
text: str = "Python"
print(text[0])    # 'P'
print(text[-1])   # 'n'
print(text[1:4])  # 'yth'

# ⚠️ Strings are immutable
text[0] = 'J'  # TypeError!
# Instead, create a new string
new_text: str = 'J' + text[1:]  # 'Jython'
```

### String Methods for Data Cleaning

```python
raw_text: str = "  Hello, WORLD!  "

# Cleaning
print(raw_text.strip())          # "Hello, WORLD!"
print(raw_text.lower())          # "  hello, world!  "
print(raw_text.upper())          # "  HELLO, WORLD!  "
print(raw_text.title())          # "  Hello, World!  "

# Splitting (core for CSV/data parsing)
csv_row: str = "John,25,Engineer"
fields: list = csv_row.split(",")
print(fields)  # ['John', '25', 'Engineer']

# Joining (reverse of split)
print(", ".join(["a", "b", "c"]))  # "a, b, c"

# Checking
print("world" in raw_text.lower())  # True
print(raw_text.startswith("  He"))  # True
```

### f-strings (Python 3.6+, Best Practice)

```python
name: str = "Alice"
age: int = 30
salary: float = 75000.50

# ❌ Old ways (avoid)
print("Name: " + name + ", Age: " + str(age))
print("Name: %s, Age: %d" % (name, age))
print("Name: {}, Age: {}".format(name, age))

# ✅ Modern f-strings (readable, fast)
print(f"Name: {name}, Age: {age}")
print(f"Salary: ${salary:,.2f}")     # "$75,000.50"
print(f"Binary: {age:b}")            # "11110"
print(f"Percent: {0.856:.1%}")       # "85.6%"
```

---

## 4. Booleans and None

### Boolean Logic

```python
# The three boolean operators
a: bool = True
b: bool = False

print(a and b)   # False (both must be True)
print(a or b)    # True  (at least one is True)
print(not a)     # False (inverts)

# Truthiness — values that act like True/False
# Falsy values: 0, 0.0, "", [], (), {}, None, False
# Everything else is truthy

if 0:       # This branch won't execute
    print("won't run")

if "hello":  # This branch will execute
    print("truthy!")

# This is useful for:
name: str = ""
if not name:
    print("Name is empty!")  # This runs
```

### None — The Absence of Value

```python
# None is Python's null/nil
result: None = None

# ⚠️ Check with 'is', not '=='
if result is None:
    print("No result yet")

if result == None:  # Works but wrong style
    print("Don't do this")

# None is falsy, so this also works:
if not result:
    print("result is falsy (None, 0, or empty)")
```

---

## 5. Lists

Lists are **ordered, mutable sequences** — the workhorse of data science.

```python
# Creating lists
numbers: list = [1, 2, 3, 4, 5]
mixed: list = [1, "hello", 3.14, True]
nested: list = [[1, 2], [3, 4], [5, 6]]  # Like a matrix

# Indexing and slicing
print(numbers[0])     # 1
print(numbers[-1])    # 5
print(numbers[1:3])   # [2, 3]
print(numbers[::2])   # [1, 3, 5]  (every 2nd element)

# List operations
numbers.append(6)         # [1, 2, 3, 4, 5, 6]
numbers.insert(0, 0)      # [0, 1, 2, 3, 4, 5, 6]
numbers.remove(3)         # removes first 3
popped = numbers.pop()    # removes and returns last
numbers.sort()            # in-place sort
numbers.reverse()         # in-place reverse

# ⚠️ Shallow copy trap
original = [1, 2, 3]
wrong = original          # Both point to SAME list
wrong.append(4)
print(original)           # [1, 2, 3, 4] — modified!

right = original.copy()   # Creates a new list
# or: right = original[:]
```

---

## 6. Tuples

Tuples are **ordered, immutable sequences** — like lists that can't change.

```python
# Creating tuples
point: tuple = (10, 20)
single: tuple = (1,)     # Note the comma!
empty: tuple = ()

# Why tuples?
# 1. They can be dictionary keys (lists can't)
locations = {(40.71, -74.00): "New York"}

# 2. For fixed data (coordinates, RGB values)
rgb_red: tuple = (255, 0, 0)

# 3. Function returns multiple values
def min_max(data: list) -> tuple:
    """Return (min, max) of data."""
    return min(data), max(data)

result = min_max([3, 1, 4, 1, 5])
print(result)       # (1, 5)
minimum, maximum = result  # Tuple unpacking
```

---

## 7. Dictionaries

Dictionaries are **key-value mappings** — essential for data work.

```python
# Creating dictionaries
person: dict = {
    "name": "Alice",
    "age": 30,
    "skills": ["Python", "ML", "SQL"]
}

# Accessing
print(person["name"])          # "Alice"
print(person.get("salary"))    # None (no KeyError)
print(person.get("salary", 0))  # 0 (default value)

# Modifying
person["age"] = 31            # Update
person["location"] = "NYC"    # Add new key
del person["location"]        # Remove key

# Iterating
for key, value in person.items():
    print(f"{key}: {value}")

# Dictionary comprehension (very useful in DS)
squares = {x: x**2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# ⚠️ Keys must be immutable (strings, numbers, tuples)
# Lists and dicts cannot be keys
```

---

## 8. Sets

Sets are **unordered collections of unique elements**.

```python
# Creating sets
unique: set = {1, 2, 3, 3, 3}
print(unique)  # {1, 2, 3} — duplicates removed!

# Set operations (core for data comparison)
a: set = {1, 2, 3, 4}
b: set = {3, 4, 5, 6}

print(a | b)   # Union:     {1, 2, 3, 4, 5, 6}
print(a & b)   # Intersection: {3, 4}
print(a - b)   # Difference: {1, 2}
print(a ^ b)   # Symmetric diff: {1, 2, 5, 6}

# Practical: finding unique users
user_ids = [101, 102, 103, 101, 104, 102]
unique_users = set(user_ids)
print(f"Unique users: {len(unique_users)}")  # 4
```

---

## 💡 Beginner Mistakes

### Mistake 1: Modifying a list while iterating

```python
# ❌ Wrong
items = [1, 2, 3, 4, 5]
for item in items:
    if item % 2 == 0:
        items.remove(item)
# items = [1, 3, 5] — works here, but unreliable!

# ✅ Right — create a new list
items = [1, 2, 3, 4, 5]
items = [item for item in items if item % 2 != 0]
```

### Mistake 2: Using mutable default arguments

```python
# ❌ Wrong — default list is shared across calls!
def add_item(item, items=[]):
    items.append(item)
    return items

print(add_item(1))  # [1]
print(add_item(2))  # [1, 2] — not [2]!

# ✅ Right
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

### Mistake 3: Comparing floats directly

```python
# ❌ Wrong
if 0.1 + 0.2 == 0.3:
    print("equal")  # Never prints!

# ✅ Right
from math import isclose
if isclose(0.1 + 0.2, 0.3):
    print("approximately equal")
```

---

## 🎯 Practice Questions

1. Why is `0.1 + 0.2 != 0.3` in Python?
2. What's the difference between `list.append()` and `list.extend()`?
3. When would you use a tuple instead of a list?
4. Why can't a list be a dictionary key?
5. What does `is` check vs `==`?
6. How do you safely access a dictionary key that might not exist?
7. What's the output of `print(type(10/2))`? Why?

---

## 💼 Interview Questions

**Q:** "Explain the difference between `is` and `==` in Python."
**A:** "`==` checks value equality — are these two objects the same value? `is` checks identity equality — are these two variables pointing to the same object in memory? For example, `[1, 2] == [1, 2]` is True (same values), but `[1, 2] is [1, 2]` is False (two different list objects). Use `is` for None, True, False comparisons; use `==` for everything else."

**Q:** "What's the difference between a list, tuple, and set?"
**A:** "Lists are ordered, mutable sequences — use when order matters and you need to change elements. Tuples are ordered, immutable sequences — use for fixed data like coordinates or function returns. Sets are unordered collections of unique elements — use for membership testing and removing duplicates. In data science, lists hold raw data, tuples hold fixed coordinates/keys, and sets find unique values."

**Q:** "What does 'pass by object reference' mean?"
**A:** "Python passes arguments to functions by object reference — the variable inside the function references the same object as outside. If the object is mutable (list, dict), changes inside the function affect the caller's object. If immutable (int, str, tuple), any change creates a new local object, so the caller's value is unaffected."

---

## ⚠️ Common Pitfalls

| Pitfall | Why | Fix |
|---------|-----|-----|
| `float` equality | Binary representation error | Use `math.isclose()` |
| Mutable default args | Default object is created once | Use `None` as default |
| Modifying list during iteration | Indexes shift | Create new list |
| `==` vs `is` for None | `==` can be overloaded | Always use `is None` |
| String immutability | Strings can't be changed in-place | Create new string |
| List copy with `=` | Both point to same list | Use `.copy()` or `[:]` |

---

## 📚 Additional Resources

- **Official:** [Python.org Tutorial](https://docs.python.org/3/tutorial/)
- **Book:** "Python Crash Course" — Chapters 1-6
- **Book:** "Python for Data Analysis" — Chapter 2 (Python Language Basics)
- **Interactive:** [Real Python Tutorials](https://realpython.com/)
- **Practice:** [HackerRank Python Track](https://www.hackerrank.com/domains/python)
- **Video:** Corey Schafer's Python Beginner Series

---

## 📝 Module Summary

- Python is **dynamically-typed**, **strongly-typed**, and **interpreted**
- Variables are **labels** on objects, not boxes
- Key types: `int`, `float`, `str`, `bool`, `None`, `list`, `tuple`, `dict`, `set`
- **Lists** are mutable ordered sequences — workhorses of data science
- **Tuples** are immutable — use for fixed data and dict keys
- **Dicts** store key-value pairs — core for structured data
- **Sets** hold unique elements — great for deduplication
- **f-strings** are the modern way to format strings
- Be careful with **float comparisons**, **mutable defaults**, and **list copies**
