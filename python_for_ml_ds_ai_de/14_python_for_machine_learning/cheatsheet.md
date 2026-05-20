# Python for Machine Learning — Cheatsheet

## Scikit-Learn API

```python
# Every estimator follows:
model = EstimatorClass(hyperparameters)
model.fit(X_train, y_train)      # Train
y_pred = model.predict(X_test)   # Predict
model.score(X_test, y_test)      # Default scoring

# Transformers (preprocessing):
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_train)  # Learn + apply
X_test_scaled = scaler.transform(X_test)  # Apply only
```

## Train/Test Split

```python
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)
```

## Cross-Validation

```python
from sklearn.model_selection import cross_val_score, cross_validate

scores = cross_val_score(model, X, y, cv=5, scoring='accuracy')
# Returns: array of 5 scores

# Detailed version:
cv_results = cross_validate(model, X, y, cv=5,
    scoring=['accuracy', 'f1'], return_estimator=True)
```

## Regression Models

| Model | Key Param | Use Case |
|-------|-----------|----------|
| `LinearRegression()` | — | Baseline, interpretable |
| `Ridge(alpha=1.0)` | alpha | L2 regularization |
| `Lasso(alpha=1.0)` | alpha | L1 regularization, feature selection |

## Classification Models

| Model | Key Param | Use Case |
|-------|-----------|----------|
| `LogisticRegression(C=1.0)` | C (inverse reg) | Binary/multi-class baseline |
| `DecisionTreeClassifier(max_depth=5)` | max_depth | Interpretable |
| `RandomForestClassifier(n_estimators=100)` | n_estimators | High accuracy, robust |
| `SVC(kernel='rbf', C=1.0)` | kernel, C, gamma | Complex boundaries |
| `KNeighborsClassifier(n_neighbors=5)` | n_neighbors | Non-parametric, simple |

## Unsupervised Models

```python
# K-Means
kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
labels = kmeans.fit_predict(X)

# DBSCAN
dbscan = DBSCAN(eps=0.5, min_samples=5)
labels = dbscan.fit_predict(X)  # -1 = noise point

# PCA
pca = PCA(n_components=2)
X_reduced = pca.fit_transform(X)
print(pca.explained_variance_ratio_)  # variance per component
```

## Metrics

### Classification

```python
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    roc_auc_score, confusion_matrix, classification_report
)

# For binary classification:
print(classification_report(y_test, y_pred, target_names=['No', 'Yes']))
cm = confusion_matrix(y_test, y_pred)
tn, fp, fn, tp = cm.ravel()
```

### Regression

```python
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)
mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)
```

## Hyperparameter Tuning

```python
from sklearn.model_selection import GridSearchCV, RandomizedSearchCV

# Grid Search (exhaustive)
param_grid = {
    'n_estimators': [50, 100],
    'max_depth': [5, 10, None]
}
grid = GridSearchCV(RandomForestClassifier(), param_grid, cv=5, scoring='f1')
grid.fit(X_train, y_train)
print(grid.best_params_, grid.best_score_)

# Random Search (efficient for large spaces)
param_dist = {
    'n_estimators': np.arange(50, 300, 50),
    'max_depth': [3, 5, 10, None]
}
random = RandomizedSearchCV(RandomForestClassifier(), param_dist, n_iter=10, cv=5)
```

## Key Rules

1. **ALWAYS** scale before SVM, KNN, PCA, K-Means
2. **NEVER** scale before tree-based models
3. **Split BEFORE** scaling (prevent data leakage)
4. **stratify=y** for classification with imbalanced classes
5. **Use test set ONCE** — only for final evaluation
6. **More trees** in RF ≈ better, but diminishing returns after ~100

## Common Pitfalls

| Mistake | Fix |
|---------|-----|
| Data leakage from scaling before split | Scale after train/test split |
| Accuracy on imbalanced data | Use precision/recall/F1 |
| Overfitting hyperparameters to test set | Use cross-validation |
| Not scaling features | Scale for distance-based models |
| Too many trees (slow, no improvement) | 100-300 trees is usually enough |
