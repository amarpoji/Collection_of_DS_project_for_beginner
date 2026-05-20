# Module 13: Statistics for Data

**Duration: 24 hours**

## Overview

Statistics is the backbone of data science and machine learning. This module covers fundamental statistical concepts essential for understanding data distributions, drawing inferences, and building robust ML models. You will learn descriptive statistics, probability distributions, hypothesis testing, correlation analysis, and Bayesian reasoning — all with an ML-focused perspective.

## Learning Objectives

By the end of this module, you will be able to:
- Compute and interpret descriptive statistics (mean, median, mode, variance, std, IQR)
- Understand probability distributions (normal, binomial, Poisson) and their applications
- Apply the Central Limit Theorem for sampling and inference
- Conduct hypothesis tests (t-test, chi-square, ANOVA) and interpret p-values
- Calculate and interpret correlation coefficients (Pearson, Spearman)
- Understand Bayes theorem and its role in ML
- Compute and interpret effect sizes
- Use statistical tests for feature selection in ML pipelines
- Understand model assumptions through statistical lens

## Prerequisites

- Python fundamentals (Module 1-7)
- NumPy and Pandas (Module 8-9)
- Basic mathematical literacy

## Topics

### 1. Descriptive Statistics (4 hours)
- Measures of central tendency: mean, median, mode
- Measures of dispersion: variance, standard deviation, range, IQR
- Skewness and kurtosis
- Five-number summary and box plots
- Real-world interpretation

### 2. Probability Distributions (5 hours)
- Normal (Gaussian) distribution and the 68-95-99.7 rule
- Binomial distribution and Bernoulli trials
- Poisson distribution for count data
- Probability density functions (PDF) and cumulative distribution functions (CDF)
- Sampling from distributions with NumPy/SciPy

### 3. Central Limit Theorem (3 hours)
- Understanding sampling distributions
- The CLT in practice
- Standard error vs standard deviation
- Applications in confidence intervals

### 4. Hypothesis Testing (6 hours)
- Null and alternative hypotheses
- Type I and Type II errors
- t-tests: one-sample, two-sample, paired
- Chi-square test for independence
- ANOVA: one-way and two-way
- p-values: interpretation and common misconceptions
- Confidence intervals

### 5. Correlation Analysis (3 hours)
- Pearson correlation coefficient
- Spearman rank correlation
- Correlation vs causation
- Correlation matrices and heatmaps

### 6. Bayesian Statistics Intuition (2 hours)
- Bayes theorem: prior, likelihood, posterior
- Bayesian vs frequentist thinking
- Connection to Naive Bayes classifier

### 7. Effect Size and Statistical Power (1 hour)
- Cohen's d
- Eta-squared for ANOVA
- Why p-values alone are not enough

## ML Focus
- **Feature Selection**: Using ANOVA F-test (SelectKBest), chi-square tests for categorical features
- **Model Assumptions**: Linear regression assumes normality of residuals, homoscedasticity
- **Evaluation**: Understanding statistical significance of model improvements

## Datasets Used
- Iris dataset (seaborn) — descriptive stats, ANOVA
- Titanic dataset (seaborn) — chi-square tests, correlation
- California housing (sklearn) — feature selection via statistical tests

## Files
- `README.md` — This file
- `lesson.ipynb` — Main lesson notebook
- `exercises.ipynb` — Practice exercises
- `solutions.ipynb` — Exercise solutions
- `cheatsheet.md` — Quick reference
- `mini_project/README.md` — Mini project description

## Practice Questions
1. What is the difference between variance and standard deviation?
2. When would you use a t-test vs ANOVA?
3. What does the Central Limit Theorem tell us about sample means?
4. How do you interpret a p-value of 0.03?
5. What is the difference between Pearson and Spearman correlation?

## Interview Questions
1. "Explain the Central Limit Theorem and why it matters for ML."
2. "How would you select features using statistical tests?"
3. "What assumptions does linear regression make about the data distribution?"
4. "When would a chi-square test be preferred over a t-test?"
5. "Explain Bayes theorem intuitively and give an ML example."

## Common Pitfalls
- **p-value hacking**: Running multiple tests without correction (Bonferroni, FDR)
- **Ignoring assumptions**: Using parametric tests on non-normal data
- **Correlation ≠ causation**: Assuming correlation implies causal relationship
- **Small sample sizes**: Drawing conclusions from insufficient data
- **Misinterpreting p-values**: p > 0.05 does not mean "no effect"
- **Ignoring effect size**: Statistical significance ≠ practical significance
