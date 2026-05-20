# ML Workflow End-to-End — Cheatsheet

## Project Structure

```
ml_project/
    configs/config.yaml
    data/raw/, data/processed/
    notebooks/
    src/data/, src/features/, src/models/
    models/
    reports/figures/
    mlruns/        # MLflow
    requirements.txt
```

## Pipeline Design

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer

# Define steps for each column type
numeric_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler', StandardScaler())
])

categorical_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('onehot', OneHotEncoder(handle_unknown='ignore', sparse_output=False))
])

# Combine with ColumnTransformer
preprocessor = ColumnTransformer([
    ('num', numeric_transformer, ['age', 'fare']),
    ('cat', categorical_transformer, ['sex', 'embarked'])
])

# Full pipeline
pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier', RandomForestClassifier())
])

pipeline.fit(X_train, y_train)
y_pred = pipeline.predict(X_test)
```

## Model Evaluation

### Learning Curves
```python
from sklearn.model_selection import learning_curve

train_sizes, train_scores, val_scores = learning_curve(
    pipeline, X, y, cv=5,
    train_sizes=np.linspace(0.1, 1.0, 10),
    scoring='accuracy'
)
```

### Validation Curves
```python
from sklearn.model_selection import validation_curve

train_scores, val_scores = validation_curve(
    pipeline, X, y,
    param_name='classifier__max_depth',
    param_range=[3, 5, 10, None],
    cv=5, scoring='accuracy'
)
```

### Confusion Matrix
```python
from sklearn.metrics import ConfusionMatrixDisplay
ConfusionMatrixDisplay.from_predictions(y_test, y_pred)
```

## Model Interpretation

### Permutation Importance
```python
from sklearn.inspection import permutation_importance

perm = permutation_importance(model, X_test, y_test, n_repeats=10, random_state=42)
# perm.importances_mean: feature importance scores
```

### SHAP
```python
import shap
explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X_test)
shap.summary_plot(shap_values, X_test, feature_names=feature_names)
shap.waterfall_plot(shap.Explanation(
    values=shap_values[1][0], base_values=explainer.expected_value[1],
    data=X_test[0], feature_names=feature_names
))
```

## Experiment Tracking with MLflow

```python
import mlflow
from mlflow.models import infer_signature

with mlflow.start_run(run_name='experiment_1'):
    # Log parameters
    mlflow.log_param('n_estimators', 100)
    mlflow.log_param('max_depth', 5)

    # Log metrics
    mlflow.log_metric('accuracy', 0.85)
    mlflow.log_metric('f1', 0.82)

    # Log model
    signature = infer_signature(X_train, y_train)
    mlflow.sklearn.log_model(pipeline, 'model', signature=signature)

    # Log artifacts
    mlflow.log_artifact('feature_importance.png')

# View: mlflow ui  (run in terminal)
```

## Model Serialization

```python
import joblib

# Save
joblib.dump(pipeline, 'model.joblib')
joblib.dump(pipeline, 'model_compressed.joblib', compress=3)

# Load
loaded_pipeline = joblib.load('model.joblib')
predictions = loaded_pipeline.predict(X_new)
```

## Bias-Variance Diagnosis

| Symptom | Diagnosis | Fix |
|---------|-----------|-----|
| High train error, high test error | High bias (underfitting) | More complex model, more features |
| Low train error, high test error | High variance (overfitting) | Regularization, more data, simpler model |
| Both high but close | Insufficient features | Feature engineering |
| Train >> Test (large gap) | Overfitting | Reduce model complexity, add data |

## Common Pitfalls

| Mistake | Fix |
|---------|-----|
| Data leakage in pipeline | Fit transformers on train only |
| Not versioning data/configs | Use DVC, MLflow, or commit hashes |
| Manual preprocessing outside pipeline | Everything in Pipeline |
| Testing many models on same test set | Use nested CV or hold-out validation |
| Deploying model without pipeline | Serialize full Pipeline, not just estimator |
| Not checking residuals | Always plot residuals vs predicted |

## Quick Reference

```python
# Key commands
cross_val_score(pipeline, X, y, cv=5)
GridSearchCV(pipeline, param_grid, cv=5)
learning_curve(pipeline, X, y, cv=5)
validation_curve(pipeline, X, y, param_name, param_range, cv=5)
permutation_importance(pipeline, X_test, y_test)
joblib.dump(pipeline, 'model.joblib')
mlflow.start_run(); mlflow.log_param(); mlflow.log_metric(); mlflow.log_model()
```
