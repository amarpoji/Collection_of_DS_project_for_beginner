# Module 08: NumPy — Cheatsheet

## Array Creation

```python
import numpy as np

# From lists
np.array([1, 2, 3])
np.array([[1, 2], [3, 4]])

# Initializations
np.zeros((3, 4))       # All zeros
np.ones((2, 3))        # All ones
np.full((2, 2), 7)     # All same value
np.eye(4)              # Identity matrix
np.empty((3, 2))       # Uninitialized (fast)

# Sequences
np.arange(0, 10, 2)    # [0, 2, 4, 6, 8]
np.linspace(0, 1, 5)   # [0, 0.25, 0.5, 0.75, 1.0]

# Random
np.random.seed(42)
np.random.randn(1000)         # Normal(0,1)
np.random.rand(100)           # Uniform(0,1)
np.random.randint(0, 10, 20)  # Random ints
np.random.normal(5, 2, 100)   # Normal(5,2)
np.random.uniform(0, 1, 100)  # Uniform
```

## Shape Operations

```python
arr = np.arange(12)

arr.shape              # (12,)
arr.reshape(3, 4)      # (3, 4)
arr.reshape(2, -1)     # (2, 6) — -1 infers dimension
arr.flatten()          # Copy — 1D
arr.ravel()            # View — 1D (faster)
arr.T                  # Transpose
arr.T.shape            # (4, 3)

# Combine arrays
np.concatenate([a, b])
np.vstack([a, b])      # Vertical stack
np.hstack([a, b])      # Horizontal stack
```

## Broadcasting Rules

```
Rule 1: Align shapes from the right
Rule 2: Dimensions must match OR one must be 1
Rule 3: Size-1 dimensions are stretched

(3, 4) + (4,)    -> (3, 4) + (1, 4) -> (3, 4)
(3, 1) * (4,)    -> (3, 1) * (1, 4) -> (3, 4)
```

```python
# Examples
arr + 10              # Scalar broadcast
matrix + row_vector   # 1D broadcast across rows
(X - mean) / std      # Feature standardization
```

## Universal Functions (ufuncs)

```python
np.sqrt(arr)     np.exp(arr)     np.log(arr)
np.sin(arr)      np.cos(arr)     np.tan(arr)
np.abs(arr)      np.sign(arr)    np.round(arr)
np.clip(arr, 0, 1)   np.square(arr)
```

## Aggregation

```python
np.sum(arr)              np.mean(arr)
np.std(arr)              np.var(arr)
np.min(arr)              np.max(arr)
np.argmin(arr)           np.argmax(arr)
np.median(arr)           np.percentile(arr, 75)

# With axis
np.mean(arr, axis=0)     # Per column / per feature
np.mean(arr, axis=1)     # Per row / per sample
```

## Boolean Indexing

```python
mask = arr > 5
arr[mask]                # Filter
arr[(arr > 2) & (arr < 5)]   # AND
arr[(arr < 2) | (arr > 5)]   # OR
arr[~(arr == 3)]             # NOT
arr[arr < 0] = 0             # Replace values
```

## Linear Algebra

```python
from numpy import linalg

np.dot(a, b)       # Dot product
a @ b              # Same (Python 3.5+)
A @ B              # Matrix multiplication

linalg.inv(A)      # Matrix inverse
linalg.det(A)      # Determinant
linalg.eig(A)      # Eigenvalues & eigenvectors
linalg.svd(A)      # SVD (PCA foundation)
linalg.solve(A, b) # Solve Ax = b
linalg.norm(v)     # Vector/matrix norm
```

## Random Module

```python
np.random.seed(42)                     # Reproducibility
np.random.randn(100)                   # N(0,1)
np.random.normal(5, 2, 100)           # N(5,2)
np.random.randint(0, 10, 20)          # Uniform ints
np.random.choice(data, 10)            # Random sample
np.random.permutation(100)            # Shuffled indices
np.random.shuffle(data)               # In-place shuffle
```

## ML Patterns

```python
# Standardization
X_scaled = (X - X.mean(axis=0)) / X.std(axis=0)

# Train-test split
n_test = int(n * 0.2)
idx = np.random.permutation(n)
X_train, X_test = X[idx[n_test:]], X[idx[:n_test]]
y_train, y_test = y[idx[n_test:]], y[idx[:n_test]]

# Mean Squared Error
mse = np.mean((y_true - y_pred) ** 2)

# One-hot encoding
np.eye(num_classes)[y]

# Add bias term
np.c_[np.ones(X.shape[0]), X]

# Normal equation: theta = (X^T X)^-1 X^T y
theta = linalg.inv(X.T @ X) @ X.T @ y
```

## Performance Tips

- **Prefer vectorized** over loops (10-100x faster)
- **Pre-allocate** instead of `np.append` in loops
- **Use `out=` parameter** to avoid creating new arrays
- **Use views** (`reshape`, `ravel`) instead of copies (`flatten`) when possible
- **Set `dtype` explicitly** for memory efficiency (e.g., `np.float32` vs `np.float64`)

## Common Pitfalls

- **`==` for float comparison** — use `np.allclose(a, b)` due to floating point
- **Copy vs View** — `.reshape()` returns a view (modifying it changes original)
- **`axis` confusion** — `axis=0` operates along rows (per column), `axis=1` operates along columns (per row)
- **`np.random.seed` not set** — results won't be reproducible
- **Python list multiplication** — `[1,2] * 3` gives `[1,2,1,2,1,2]`, not `[3,6]`
