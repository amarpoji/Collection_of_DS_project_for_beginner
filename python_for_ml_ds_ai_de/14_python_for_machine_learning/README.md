# Module 14: Python for Machine Learning

**Duration: 30 hours**

## Overview

This module provides a comprehensive introduction to machine learning using Python and scikit-learn. You will learn the core ML workflow — from data preparation to model evaluation and hyperparameter tuning. Both supervised and unsupervised learning algorithms are covered with hands-on practice on real datasets.

## Learning Objectives

By the end of this module, you will be able to:
- Understand the scikit-learn API (estimator, fit, predict, transform)
- Split data into training and testing sets
- Apply cross-validation for reliable evaluation
- Build and evaluate supervised learning models (Linear Regression, Logistic Regression, Decision Trees, Random Forest, SVM, KNN)
- Build and evaluate unsupervised learning models (K-Means, PCA, DBSCAN)
- Select appropriate metrics (accuracy, precision, recall, F1, ROC-AUC, MSE, MAE, R²)
- Perform hyperparameter tuning with GridSearchCV and RandomizedSearchCV
- Complete a full ML workflow on real datasets

## Prerequisites

- Python programming (Modules 1-7)
- NumPy, Pandas, Matplotlib/Seaborn (Modules 8-10)
- Basic statistics (Module 13)

## Topics

### 1. Scikit-Learn API (3 hours)
- Estimator interface: `.fit()`, `.predict()`, `.transform()`
- Supervised vs unsupervised estimators
- `fit(X, y)` vs `fit(X)` — when to use each
- Common parameters and attributes

### 2. Data Splitting and Cross-Validation (3 hours)
- Train/test split with `train_test_split`
- Stratified splitting for imbalanced data
- K-Fold cross-validation
- StratifiedKFold, GroupKFold
- `cross_val_score` and `cross_validate`

### 3. Supervised Learning: Regression (4 hours)
- Linear Regression
- Metrics: MSE, MAE, R²
- Assumptions and diagnostics
- Regularization (Ridge, Lasso) — brief intro

### 4. Supervised Learning: Classification (8 hours)
- Logistic Regression
- Decision Trees
- Random Forest
- Support Vector Machines (SVM)
- K-Nearest Neighbors (KNN)
- Metrics: accuracy, precision, recall, F1, ROC-AUC, confusion matrix

### 5. Unsupervised Learning (6 hours)
- K-Means clustering
- DBSCAN for density-based clustering
- PCA for dimensionality reduction
- Evaluation: silhouette score, inertia, explained variance

### 6. Hyperparameter Tuning (4 hours)
- GridSearchCV: exhaustive search
- RandomizedSearchCV: random search
- Validation curves and learning curves
- Best practices to avoid overfitting

### 7. Complete ML Workflow (2 hours)
- Putting it all together on a real dataset
- Data cleaning → feature selection → model training → evaluation → tuning

## ML Focus
- Complete ML workflow from raw data to deployed-ready model
- Understanding bias-variance tradeoff through model comparison
- Practical tips for real-world ML projects

## Datasets Used
- Iris (classification) — Logistic Regression, Decision Trees, KNN
- Titanic (classification) — Random Forest, SVM, hyperparameter tuning
- California Housing (regression) — Linear Regression, Ridge
- Digits (classification) — PCA + classification
- Mall Customers / Blobs (clustering) — K-Means, DBSCAN

## Files
- `README.md` — This file
- `lesson.ipynb` — Main lesson notebook
- `exercises.ipynb` — Practice exercises
- `solutions.ipynb` — Exercise solutions
- `cheatsheet.md` — Quick reference
- `mini_project/README.md` — Mini project description

## Practice Questions
1. What is the difference between fit, predict, and transform?
2. When would you use stratified cross-validation?
3. What does the R² metric measure?
4. When is ROC-AUC preferred over accuracy?
5. What is the bias-variance tradeoff in Random Forest?

## Interview Questions
1. "Explain how cross-validation works and why we use it."
2. "Compare Logistic Regression and SVM — when would you use each?"
3. "How does Random Forest reduce overfitting compared to a single Decision Tree?"
4. "What is the curse of dimensionality and how does PCA help?"
5. "How do you choose between GridSearchCV and RandomizedSearchCV?"

## Common Pitfalls
- **Data leakage**: Scaling or encoding before train/test split
- **Overfitting**: Tuning on test data instead of using validation set
- **Ignoring class imbalance**: Using accuracy on imbalanced data
- **Not scaling features**: SVM, KNN, and PCA require feature scaling
- **Misinterpreting metrics**: High accuracy on imbalanced data is misleading
- **Too many trees**: Random Forest diminishing returns beyond ~100 trees
