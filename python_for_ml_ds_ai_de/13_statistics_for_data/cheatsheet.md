# Statistics for Data — Cheatsheet

## Descriptive Statistics

| Metric | Formula | Python | Interpretation |
|--------|---------|--------|----------------|
| Mean | Σx / n | `np.mean(x)` | Center of data |
| Median | Middle value | `np.median(x)` | Robust center |
| Mode | Most frequent | `stats.mode(x)` | Most common value |
| Variance | Σ(x - μ)² / n | `np.var(x)` | Average squared deviation |
| Std Dev | √Variance | `np.std(x)` | Spread in original units |
| IQR | Q3 - Q1 | `stats.iqr(x)` | Middle 50% spread |
| Skewness | — | `stats.skew(x)` | Asymmetry (0 = symmetric) |
| Kurtosis | — | `stats.kurtosis(x)` | Tail "heaviness" |

## Probability Distributions

```python
from scipy import stats

# Normal
samples = np.random.normal(loc=0, scale=1, size=1000)
pdf = stats.norm.pdf(x, loc=0, scale=1)
cdf = stats.norm.cdf(x, loc=0, scale=1)

# Binomial
samples = np.random.binomial(n=10, p=0.5, size=1000)

# Poisson
samples = np.random.poisson(lam=3, size=1000)
```

**68-95-99.7 Rule**: 68% within 1σ, 95% within 2σ, 99.7% within 3σ

## Central Limit Theorem

- Distribution of sample means → Normal as n ↑ (n ≥ 30)
- Mean of sample means = population mean
- Standard error = σ / √n
- ```python
  sample_means = [np.mean(np.random.choice(pop, n)) for _ in range(1000)]
  ```

## Hypothesis Testing

### t-test (compare 2 groups)
```python
stats.ttest_ind(group1, group2)           # independent
stats.ttest_rel(before, after)            # paired
stats.ttest_1samp(data, popmean)          # one sample
```

### ANOVA (compare 3+ groups)
```python
stats.f_oneway(group1, group2, group3)
```

### Chi-Square (categorical)
```python
stats.chi2_contingency(contingency_table)
```

## Correlation

| Type | Python | Use Case |
|------|--------|----------|
| Pearson | `df.corr(method='pearson')` | Linear relationships |
| Spearman | `df.corr(method='spearman')` | Monotonic (non-linear) |

- Range: [-1, 1]
- 0 = no linear correlation
- Always visualize with scatter plots!

## Effect Size

```python
# Cohen's d
pooled_std = np.sqrt((std1**2 + std2**2) / 2)
cohens_d = (mean1 - mean2) / pooled_std
# Small: 0.2, Medium: 0.5, Large: 0.8
```

## Bayes Theorem

```
P(A|B) = P(B|A) * P(A) / P(B)
```

- Prior: P(A) — belief before evidence
- Likelihood: P(B|A) — evidence given belief
- Posterior: P(A|B) — updated belief

## ML Feature Selection

```python
from sklearn.feature_selection import SelectKBest, f_classif, f_regression, chi2

# Classification
selector = SelectKBest(score_func=f_classif, k=3)
X_selected = selector.fit_transform(X, y)

# Regression
selector = SelectKBest(score_func=f_regression, k=3)

# Categorical features
selector = SelectKBest(score_func=chi2, k=3)  # needs non-negative values
```

## Common Mistakes

- ❌ Using Pearson for non-linear relationships → Use Spearman
- ❌ Ignoring normality assumption for t-tests → n ≥ 30 often sufficient (CLT)
- ❌ p > 0.05 means "no effect" → p > 0.05 means insufficient evidence
- ❌ Running many tests without correction → Use Bonferroni or FDR
- ❌ Confusing statistical significance with practical significance → Check effect size

## Quick Reference: Key Functions

```python
# scipy.stats
stats.describe(data)          # Comprehensive summary
stats.normaltest(data)        # Test for normality
stats.shapiro(data)           # Shapiro-Wilk normality test
stats.pearsonr(x, y)          # Pearson correlation + p-value
stats.spearmanr(x, y)         # Spearman correlation + p-value
stats.pointbiserialr(x, y)    # Binary-continuous correlation

# numpy
np.cov(x, y)                  # Covariance matrix
np.corrcoef(x, y)             # Correlation matrix
```
