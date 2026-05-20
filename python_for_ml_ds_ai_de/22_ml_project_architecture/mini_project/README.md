# Mini Project: Design a Production ML Project Architecture

**Goal**: Design and implement a production-ready ML project structure for a customer churn prediction system.

## Scenario

Your startup has been using Jupyter notebooks for customer churn prediction. The system works but is fragile: no version control for data, hyperparameters are hardcoded, experiments aren't tracked, and deploying a new model requires manual steps. Your task is to architect a proper ML project that can scale with the team (expected to grow to 5 ML engineers and 2 data engineers).

## Business Requirements

1. Predict customer churn (binary classification) with at least 85% precision
2. Weekly model retraining with new data
3. A/B testing capability for new features
4. Models must be reproducible from 6 months ago
5. Data scientists should be able to run experiments without DevOps help
6. The system must log predictions for monitoring and drift detection

## Project Requirements

### Part 1: Directory Structure
Design and create a complete directory structure that includes:
- Source code modules (data, features, models, deployment)
- Configuration management
- Experiment tracking setup
- Test infrastructure
- Documentation
- Data directories (raw, processed, external)

### Part 2: Configuration System
Implement a configuration system that:
- Uses YAML for default configuration
- Supports environment overrides (dev, staging, production)
- Validates configuration at startup
- Exposes settings via a clean Python interface

### Part 3: Experiment Tracking
Set up MLflow (or W&B) integration:
- Log all hyperparameters
- Log metrics (precision, recall, F1, AUC-ROC)
- Log model artifacts with versioning
- Log feature importance plots
- Create a simple experiment comparison notebook

### Part 4: Data Pipeline
Build a data pipeline that:
- Loads raw data from CSV
- Validates schema and data quality
- Creates features using a FeatureEngineering class
- Splits data with versioned train/test splits
- Logs data statistics to experiment tracker

### Part 5: Model Pipeline
Build a model training pipeline that:
- Reads configuration for model selection and hyperparameters
- Trains at least 3 model types (logistic regression, random forest, XGBoost)
- Performs cross-validation
- Logs results to experiment tracker
- Saves the best model to a model registry
- Is callable from both CLI and Python

### Part 6: Orchestration
Create a simple orchestration DAG (using pseudocode or Airflow/Prefect syntax) that:
- Runs data pipeline weekly
- Runs model training after data is ready
- Evaluates new model against current production model
- Promotes model if performance improves
- Handles failures gracefully with retries

## Deliverables

1. Complete directory structure (actual files with docstrings)
2. `config/default.yaml` and `config/production.yaml`
3. `src/config.py` — pydantic-settings or Hydra implementation
4. `src/data/loader.py`, `src/data/validator.py`
5. `src/features/engineering.py`
6. `src/models/trainer.py`, `src/models/evaluator.py`
7. `src/models/registry.py`
8. `orchestration/pipeline_dag.py` — DAG definition
9. `tests/test_data.py`, `tests/test_features.py`, `tests/test_model.py`
10. Architecture diagram (ASCII or draw.io) showing component interactions

## Evaluation Criteria

- **Modularity**: Can components be developed and tested independently?
- **Configurability**: Can the system be configured without code changes?
- **Reproducibility**: Can any past experiment be reproduced exactly?
- **Extensibility**: How easy is it to add a new model or feature?
- **Documentation**: Is the architecture and usage well-documented?
- **Testing**: Are critical paths covered by tests?
- **Error handling**: Does the system fail gracefully with clear messages?

## Sample Data

Use the Telcom Customer Churn dataset (or generate synthetic data):
- Features: tenure, monthly charges, total charges, contract type, internet service, payment method, etc.
- Target: churn (Yes/No)
- Size: ~7000 rows

## Extension Ideas

- Add containerization with Docker
- Implement a feature store using Redis
- Add data drift monitoring with evidently.ai
- Set up CI/CD pipeline with GitHub Actions
- Add model explainability with SHAP
