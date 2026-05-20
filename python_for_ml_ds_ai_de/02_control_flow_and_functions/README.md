# Module 02: Control Flow & Functions

**Duration: 18 hours** | **Focus: ML Data Iteration Patterns**

---

## Why This Module Matters

Data science and ML are fundamentally about iteration: you iterate over datasets to clean them, over hyperparameters to tune models, over training epochs to learn weights, over cross-validation folds to evaluate performance. Control flow and functions are the engines that drive these iterations.

## From First Principles

### What is Control Flow?

Control flow is the order in which individual statements are executed. By default, Python executes code top-to-bottom. Control flow statements let you:

- **Branch**: Execute different code based on conditions (`if/elif/else`)
- **Loop**: Repeat code multiple times (`for`, `while`)
- **Skip/Redirect**: Break out of loops, skip iterations, handle errors

### What are Functions?

Functions are reusable blocks of code that take inputs, perform operations, and return outputs. They're the fundamental unit of abstraction — allowing you to name a computation and reuse it.

### Why This Matters for ML

Every ML pipeline follows this pattern:
```
for each data_batch:              # loop
    for each feature:             # nested loop
        if missing_value:         # conditional
            impute_value()        # function call
    predictions = model(batch)    # function
    loss = compute_loss(y, pred)  # function
```

---

## Concepts

### if/elif/else

```python
if condition:
    # executed if condition is truthy
elif other_condition:
    # executed if first is falsy and this is truthy
else:
    # executed if all above are falsy
```

**ML pattern**: Branching on data quality, model type, or configuration.

### for Loops

```python
for item in iterable:
    # process each item
```

**ML pattern**: Iterating over datasets, epochs, hyperparameters, batches.

### while Loops

```python
while condition:
    # repeat until condition is falsy
```

**ML pattern**: Training until convergence, waiting for resources, retrying operations.

### range(), enumerate(), zip()

These three functions are **essential** for data iteration:

- `range(n)`: Generate a sequence of numbers (indices)
- `enumerate(iterable)`: Get (index, value) pairs
- `zip(*iterables)`: Combine multiple iterables element-wise

### List Comprehensions

The Pythonic way to create lists:

```python
[x**2 for x in range(10) if x % 2 == 0]
```

Prefer comprehensions over manual `for` loops with `append()`.

### Lambda Functions

Small anonymous functions for one-liner operations:

```python
lambda x: x**2
```

Useful with `sorted()`, `map()`, `filter()`, and pandas operations.

### *args and **kwargs

Collect arbitrary positional and keyword arguments:

```python
def train_model(*args, **kwargs):
    # args = positional arguments as tuple
    # kwargs = keyword arguments as dict
```

**ML pattern**: Flexible model constructors that pass arguments to sub-modules.

### Scope (LEGB Rule)

Python resolves variable names in this order:
1. **L**ocal — inside the current function
2. **E**nclosing — outer functions (nested functions)
3. **G**lobal — top-level of the module
4. **B**uilt-in — Python's built-in names

### Recursion

A function that calls itself. Used in tree-based ML algorithms (decision trees, random forests implicitly use recursive splitting).

### map, filter, reduce

| Function | Purpose | Pythonic Alternative |
|----------|---------|---------------------|
| `map(func, iterable)` | Transform each element | List comprehension |
| `filter(pred, iterable)` | Keep elements matching predicate | List comprehension with `if` |
| `reduce(func, iterable)` | Combine into single value | `sum()`, loops, or `functools.reduce()` |

---

## Real-World Analogy

Think of an ML pipeline as a factory assembly line:

- **if/elif/else** = Quality control gates ("If defective, reject; elif repairable, fix; else pass through")
- **for loop** = The conveyor belt moving items through each station
- **range()** = Numbered positions on the belt
- **enumerate()** = Position labels on each item
- **zip()** = Pairing each item with its inspection sheet
- **Functions** = Each station (clean, transform, train, evaluate)
- **List comprehensions** = A high-speed automated transformation station
- **Recursion** = A recursive sorting/grouping mechanism (like splitting a decision tree)

---

## Beginner Mistakes

1. **Modifying a list while iterating over it** — Creates hard-to-find bugs
2. **Using `range(len(lst))` when you don't need indices** — Use `for item in lst`
3. **Forgetting that `range()` is exclusive at the end** — `range(5)` gives 0,1,2,3,4
4. **Using mutable default arguments** — `def f(x=[])` creates one shared list
5. **Shadowing built-in functions** — Don't use `list`, `dict`, `sum`, `input` as variable names
6. **Infinite while loops** — Always ensure the condition will eventually become False
7. **Not understanding scope** — Variables created in a function don't exist outside it

## Best Practices

1. **Prefer comprehensions over map/filter** — More readable and Pythonic
2. **Use meaningful names** — `for record in dataset:` not `for i in x:`
3. **Keep functions small** — One function, one responsibility
4. **Use type hints** — They catch bugs and serve as documentation
5. **Return early from functions** — Avoid deep nesting
6. **Use `enumerate` with a start parameter** — `enumerate(data, start=1)` for human-readable output
7. **Prefer `any()` and `all()` over manual loops** — More declarative and faster

## Interview Notes

- Implement `zip()` from scratch
- Implement a flatten function for nested lists
- Explain when to use `for` vs. `while`
- Difference between `return`, `yield`, and `print` in a function
- How does Python's `for` loop work internally? (calls `iter()` on the object, then `next()` repeatedly)
- Explain `*args` and `**kwargs` with examples
- What is a closure? When would you use one?

## Summary

| Concept | Syntax | ML Use |
|---------|--------|--------|
| if/elif/else | `if x > 0:` | Data validation, branching logic |
| for loop | `for x in data:` | Dataset iteration |
| while loop | `while loss > 0.01:` | Training until convergence |
| range() | `range(10)` | Loop counters, epochs |
| enumerate() | `for i, x in enumerate(data)` | Indexed iteration |
| zip() | `for x, y in zip(a, b)` | Pair features with labels |
| List comp | `[f(x) for x in data]` | Feature transformation |
| Lambda | `lambda x: x**2` | Quick functions, sorting keys |
| *args/**kwargs | `def f(*args, **kwargs)` | Flexible ML pipelines |

---

## Practice Questions

1. Write a function that finds all even numbers in a list using a list comprehension.
2. Use `zip()` to combine feature names with their values into dicts.
3. Implement a function that flattens a nested list of arbitrary depth using recursion.
4. Use `enumerate()` to track which fold of cross-validation you're on.
5. Write a generator function that yields batches from a dataset.
6. Implement a simple decision tree splitting criterion using conditional logic.
7. Use `map()` and `filter()` to clean and transform a dataset.
8. Write a function with `*args` that computes multiple evaluation metrics.

## Interview Questions

1. What is the difference between `return` and `yield`?
2. How does the LEGB scope resolution work? Give an example.
3. What is a closure? Show how it can be used to create a counter.
4. Implement `zip()` using a for loop.
5. What's the difference between `for i in range(len(lst))` and `for i, v in enumerate(lst)`?
6. Explain how `map`, `filter`, and `reduce` work and their modern alternatives.
7. What happens when you modify a list while iterating over it?

## Common Pitfalls

- `range(5)` gives 0-4, not 0-5
- `for i, v in enumerate(lst)` — forgetting the second variable
- `zip()` stops at the shortest iterable (use `zip_longest` from itertools if needed)
- List comprehension does NOT create a closure (variables leak in Python 2, fixed in Python 3)
- `lambda` inside a list comprehension captures by reference, not value
- `while True:` without a `break` condition creates an infinite loop

## Additional Resources

- [Python docs: Control Flow](https://docs.python.org/3/tutorial/controlflow.html)
- [Python docs: Functions](https://docs.python.org/3/tutorial/controlflow.html#defining-functions)
- [Real Python: Python Scope & LEGB Rule](https://realpython.com/python-scope-legb-rule/)
- [Real Python: List Comprehensions](https://realpython.com/list-comprehension-python/)
- [Fluent Python: Chapter 7 - Function Decorators and Closures](https://www.oreilly.com/library/view/fluent-python/9781491946237/)
