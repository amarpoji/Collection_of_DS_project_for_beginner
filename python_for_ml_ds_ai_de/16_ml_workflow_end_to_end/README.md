# Module 16: ML Workflow End-to-End

**Duration: 24 hours**

## Overview

This module covers the complete end-to-end machine learning project lifecycle — from project structure and data versioning through pipeline design, model evaluation, interpretation, and experiment tracking. You will learn how to build production-ready ML workflows using sklearn pipelines, MLflow, and SHAP.

## Learning Objectives

By the end of this module, you will be able to:
- Structure a complete ML project with modular code
- Implement data versioning strategies
- Track experiments with MLflow
- Design complex pipelines with sklearn Pipeline and ColumnTransformer
- Serialize and deploy models with joblib/pickle
- Evaluate models with learning curves, validation curves, and confusion matrices
- Analyze feature importance and interpret models with SHAP
- Complete an end-to-end ML project with experiment tracking

## Prerequisites

- Python for ML (Module 14)
- Feature Engineering (Module 15)

## Topics

### 1. ML Project Structure (3 hours)
- Directory structure for ML projects
- Config files (YAML, JSON)
- Separation of concerns: data, features, models, utils
- Reproducibility and version control

### 2. Data Versioning (2 hours)
- Tracking data versions
- DVC (Data Version Control) overview
- Hash-based data tracking
- Keeping raw data immutable

### 3. Experiment Tracking with MLflow (4 hours)
- MLflow setup and concepts
- Logging parameters, metrics, and artifacts
- Comparing runs
- Model registry basics

### 4. Pipeline Design (4 hours)
- sklearn Pipeline: chaining transformers + estimator
- ColumnTransformer for heterogeneous data
- FeatureUnion for parallel transformations
- Custom transformers with FunctionTransformer
- Pipeline persistence

### 5. Model Serialization (2 hours)
- joblib vs pickle
- Saving and loading models
- Versioning serialized models
- Deployment considerations

### 6. Model Evaluation (4 hours)
- Learning curves: bias-variance diagnosis
- Validation curves: hyperparameter sensitivity
- Confusion matrix detailed analysis
- Precision-recall curves
- Regression diagnostics (residual plots)

### 7. Model Interpretation (3 hours)
- Feature importance analysis (permutation importance)
- Partial dependence plots
- SHAP (SHapley Additive exPlanations) basics
- Interpreting model predictions

### 8. Complete End-to-End Project (2 hours)
- Bringing it all together
- From raw data to deployed model
- Best practices checklist

## ML Focus
- Production-ready ML workflows
- Experiment tracking for reproducibility
- Model interpretation for stakeholder communication

## Datasets Used
- California Housing — regression pipeline with MLflow
- Titanic — classification pipeline with SHAP
- Iris — learning curves and validation curves

## Files
- `README.md` — This file
- `lesson.ipynb` — Main lesson notebook
- `exercises.ipynb` — Practice exercises
- `solutions.ipynb` — Exercise solutions
- `cheatsheet.md` — Quick reference
- `mini_project/README.md` — Mini project description

## Practice Questions
1. What is the advantage of using Pipeline over manual step-by-step processing?
2. How does MLflow help with experiment reproducibility?
3. What can a learning curve tell you about bias vs variance?
4. When would you use permutation importance vs SHAP?
5. What is the difference between joblib and pickle for model serialization?

## Interview Questions
1. "Walk me through your complete ML project workflow from start to finish."
2. "How do you diagnose and fix overfitting in a production ML pipeline?"
3. "Explain how SHAP values work and when you'd use them."
4. "How would you set up experiment tracking for a team of data scientists?"
5. "What considerations go into deciding whether to retrain a model?"

## Common Pitfalls
- **Not versioning data**: Can't reproduce results without knowing which data was used
- **Manual preprocessing steps**: Leads to training-serving skew
- **Ignoring data leakage in pipelines**: Especially with target encoding or scaling
- **Not saving the full pipeline**: Deploying model without preprocessing steps
- **Over-relying on feature importance**: Correlation ≠ causation
- **Not checking residuals**: Linear models need residual diagnostics
