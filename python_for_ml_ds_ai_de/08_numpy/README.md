# Module 08: NumPy — Numerical Computing for ML

> **Duration:** 20 hours
> **ML Focus:** Numerical computing for ML, performance comparison vs Python lists, linear algebra operations

---

## Why NumPy? It's the Foundation of All ML

Every ML library (pandas, scikit-learn, TensorFlow, PyTorch) is built on NumPy. Its **vectorized operations** make Python code 10-100x faster for numerical computing.

**Without NumPy:** Python loops over every element (slow).
**With NumPy:** C-optimized operations on entire arrays at once (fast).

---

## 1. ndarray Creation

```python
import numpy as np

# From lists
arr = np.array([1, 2, 3, 4, 5])           # 1D array
matrix = np.array([[1, 2], [3, 4]])       # 2D array

# Common initializations
zeros = np.zeros((3, 4))                  # All zeros
ones = np.ones((2, 3))                    # All ones
full = np.full((2, 2), 7)                 # All 7s
eye = np.eye(3)                           # Identity matrix

# Sequences
arange = np.arange(0, 10, 2)              # [0, 2, 4, 6, 8]
linspace = np.linspace(0, 1, 5)           # [0.0, 0.25, 0.5, 0.75, 1.0]

# Random (ML critical)
random_vals = np.random.randn(1000)       # Standard normal distribution
random_uniform = np.random.rand(100)      # Uniform [0, 1)
random_int = np.random.randint(0, 10, 20) # Random integers
```

---

## 2. Shape and Reshape

```python
arr = np.arange(12)
print(arr.shape)           # (12,)

# Reshape to 2D
matrix = arr.reshape(3, 4)  # 3 rows, 4 columns
# or
matrix = arr.reshape(3, -1) # -1 means "infer this dimension"

# Flatten back
flat = matrix.flatten()     # Returns copy
flat = matrix.ravel()       # Returns view (faster, but changes affect original)

# Transpose
transposed = matrix.T       # Swap rows and columns
```

**Why reshape matters:** ML data is often a matrix of shape `(n_samples, n_features)`.

---

## 3. Broadcasting — The Secret Superpower

Broadcasting lets NumPy perform operations on arrays of different shapes.

```python
# Add a scalar to every element
arr = np.array([1, 2, 3])
result = arr + 10           # [11, 12, 13]

# Add a 1D array to each row of a 2D array
matrix = np.array([[1, 2, 3],
                   [4, 5, 6]])
row_mean = np.array([1, 1, 1])
result = matrix + row_mean  # Adds to each row

# Broadcasting rules:
# 1. Align dimensions from the right
# 2. Dimensions must match or one must be 1
# 3. Size 1 dimensions are "stretched" to match
```

**ML example:** Standardizing features (subtract mean, divide by std) uses broadcasting.

---

## 4. Vectorization — Performance Critical

```python
# SLOW — Python loop
result = np.zeros(1000000)
for i in range(1000000):
    result[i] = arr[i] * 2 + 1

# FAST — NumPy vectorized
result = arr * 2 + 1          # 10-100x faster
```

**Performance comparison:**

```python
import time

n = 10_000_000
py_list = list(range(n))
np_arr = np.arange(n)

# Python sum — ~200ms
start = time.time()
total = sum(py_list)
print('Python list:', time.time() - start)

# NumPy sum — ~5ms (40x faster)
start = time.time()
total = np.sum(np_arr)
print('NumPy array:', time.time() - start)
```

---

## 5. Universal Functions (ufuncs)

Element-wise operations optimized in C:

```python
arr = np.array([1, 2, 3, 4, 5])

np.sqrt(arr)       # Square root
np.exp(arr)        # Exponential
np.log(arr)        # Natural log
np.sin(arr)        # Sine
np.abs(arr)        # Absolute value
np.sign(arr)       # Sign (-1, 0, 1)
np.round(arr, 2)   # Round to decimals
np.clip(arr, 1, 3) # Clip values to [1, 3]
```

You can also make any operation a ufunc:

```python
sigmoid = lambda x: 1 / (1 + np.exp(-x))
# Automatically works on entire arrays!
```

---

## 6. Aggregation Operations

```python
arr = np.array([[1, 2, 3],
                [4, 5, 6]])

np.sum(arr)            # 21 — all elements
np.sum(arr, axis=0)    # [5, 7, 9] — sum columns (across rows)
np.sum(arr, axis=1)    # [6, 15] — sum rows (across columns)

np.mean(arr)           # Average
np.std(arr)            # Standard deviation
np.var(arr)            # Variance
np.min(arr)            # Minimum
np.max(arr)            # Maximum
np.argmin(arr)         # Index of minimum
np.argmax(arr)         # Index of maximum
np.median(arr)         # Median
np.percentile(arr, 75) # 75th percentile
```

---

## 7. Boolean Indexing

```python
arr = np.array([1, 2, 3, 4, 5, 6])

# Filter elements
mask = arr > 3
print(mask)            # [False, False, False, True, True, True]
print(arr[mask])       # [4, 5, 6]

# Inline
print(arr[arr > 3])    # [4, 5, 6]

# Multiple conditions
print(arr[(arr > 2) & (arr < 5)])   # [3, 4] — AND
print(arr[(arr < 2) | (arr > 5)])   # [1, 6] — OR

# Replace values
arr[arr < 0] = 0       # Clip negative values to 0
```

**ML example:** Filtering outliers, selecting positive class samples.

---

## 8. Linear Algebra

```python
# Dot product (matrix multiplication)
a = np.array([1, 2, 3])
b = np.array([4, 5, 6])
dot = np.dot(a, b)           # 32 = 1*4 + 2*5 + 3*6
dot = a @ b                  # Same (Python 3.5+)

# Matrix multiplication
A = np.array([[1, 2], [3, 4]])
B = np.array([[5, 6], [7, 8]])
C = A @ B                    # [[19, 22], [43, 50]]

# Linear algebra operations (linalg)
from numpy import linalg

# Eigenvalues and eigenvectors
eigvals, eigvecs = linalg.eig(A)

# Matrix inverse
inv = linalg.inv(A)

# Singular value decomposition (SVD) — PCA foundation
U, S, Vt = linalg.svd(A)

# Solve linear systems
X = linalg.solve(A, np.array([1, 2]))
```

---

## 9. The Random Module

```python
np.random.seed(42)  # For reproducibility

# Common distributions
np.random.normal(loc=0, scale=1, size=1000)     # Gaussian
np.random.uniform(low=0, high=1, size=1000)     # Uniform
np.random.binomial(n=10, p=0.5, size=100)      # Binomial
np.random.poisson(lam=5, size=100)             # Poisson

# Sampling
data = np.arange(100)
np.random.choice(data, size=10, replace=False)  # Random sample

# Shuffle (in-place)
np.random.shuffle(data)

# Set seed for reproducible experiments
np.random.seed(42)
```

---

## ML-Specific Patterns

### Feature standardization
```python
def standardize(X):
    mean = np.mean(X, axis=0)
    std = np.std(X, axis=0)
    return (X - mean) / std  # Broadcasting!

X_standardized = standardize(X)
```

### Train-test split
```python
def train_test_split(X, y, test_size=0.2):
    n = len(X)
    n_test = int(n * test_size)
    indices = np.random.permutation(n)
    test_idx = indices[:n_test]
    train_idx = indices[n_test:]
    return X[train_idx], X[test_idx], y[train_idx], y[test_idx]
```

### Mean Squared Error
```python
def mse(y_true, y_pred):
    return np.mean((y_true - y_pred) ** 2)
```

### One-hot encoding
```python
def one_hot(y, num_classes):
    return np.eye(num_classes)[y]
```

---

## Key Takeaways

1. **Vectorize everything** — avoid Python loops on numerical data (10-100x speedup)
2. **Shape matters** — understand `(n_samples, n_features)` representation
3. **Broadcasting** is magic — lets you operate on different-sized arrays
4. **Aggregate with axis** — `axis=0` = column operation, `axis=1` = row operation
5. **Boolean indexing** — powerful for filtering and masking
6. **`linalg`** for linear algebra (dot products, eigendecomposition, SVD)
7. **Always set `np.random.seed()`** for reproducibility
