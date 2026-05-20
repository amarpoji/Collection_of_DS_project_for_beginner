# Module 22: ML Project Architecture — Cheatsheet

## Project Structure Patterns

### Cookiecutter Data Science

```
project/
  data/
    raw/                # Immutable raw data
    interim/            # Intermediate transformed data
    processed/          # Final modeling data
    external/           # External reference data
  notebooks/            # Jupyter notebooks for exploration
  src/                  # Source code
    data/               # Data loading and preprocessing
    features/           # Feature engineering
    models/             # Model training and inference
    visualization/      # Plotting and dashboards
  models/               # Trained model artifacts
  reports/              # Generated analysis reports
  tests/                # Test suite
  config/               # Configuration files
  Makefile              # Automation commands
  pyproject.toml        # Project metadata and dependencies
```

### Modular Monolith

```
src/
  ingestion/            # Data ingestion module
    loader.py
    validator.py
    schemas.py
  features/             # Feature engineering module
    transformers.py
    selectors.py
    stores.py
  training/             # Model training module
    trainer.py
    tuner.py
    evaluator.py
  serving/              # Inference module
    predictor.py
    api.py
    serializer.py
  common/               # Shared utilities
    config.py
    logging.py
    metrics.py
```

## Configuration Management

### Hydra

```python
# config/config.yaml
db:
  host: localhost
  port: 5432
model:
  name: random_forest
  params:
    n_estimators: 100
    max_depth: 10

# config.py
from dataclasses import dataclass
import hydra
from omegaconf import DictConfig

@dataclass
class DBConfig:
    host: str = "localhost"
    port: int = 5432

@hydra.main(version_base=None, config_path="config", config_name="config")
def train(cfg: DictConfig):
    print(cfg.model.name)
    print(cfg.db.host)
```

### pydantic-settings

```python
from pydantic_settings import BaseSettings
from pydantic import Field

class Settings(BaseSettings):
    model_path: str = Field(default="models/model.pkl")
    api_host: str = Field(default="0.0.0.0")
    api_port: int = Field(default=8000)
    log_level: str = Field(default="INFO")
    batch_size: int = Field(default=32)

    class Config:
        env_file = ".env"
        env_prefix = "ML_"

settings = Settings()
# Reads from environment variables or .env file
```

### YAML Configuration Pattern

```yaml
# config.yaml
project:
  name: housing_price_prediction
  version: 1.0.0

data:
  raw_path: data/raw/housing.csv
  processed_path: data/processed/
  test_size: 0.2
  random_state: 42

features:
  numerical: [sqft, bedrooms, bathrooms, age]
  categorical: [neighborhood]
  target: price

training:
  model: gradient_boosting
  params:
    n_estimators: 300
    learning_rate: 0.05
    max_depth: 5
  cv_folds: 5
  scoring: neg_mean_squared_error
```

## Experiment Tracking

### MLflow

```python
import mlflow

mlflow.set_tracking_uri("http://localhost:5000")
mlflow.set_experiment("housing-prices")

with mlflow.start_run():
    # Log params
    mlflow.log_param("n_estimators", 100)
    mlflow.log_param("max_depth", 10)

    # Log metrics
    mlflow.log_metric("rmse", 45000.0)
    mlflow.log_metric("r2", 0.87)

    # Log model
    mlflow.sklearn.log_model(model, "model")

    # Log artifacts
    mlflow.log_artifact("feature_importance.png")
    mlflow.log_artifact("config.yaml")
```

### Weights & Biases

```python
import wandb

wandb.init(project="housing-prices", config={
    "n_estimators": 100,
    "max_depth": 10,
    "learning_rate": 0.05
})

# Log metrics during training
for epoch in range(10):
    loss = train_step()
    wandb.log({"epoch": epoch, "loss": loss})

# Log model
wandb.log_artifact("model.pkl", type="model")

wandb.finish()
```

## Data Versioning with DVC

```bash
# Install
pip install dvc

# Initialize
dvc init

# Track data
dvc add data/raw/dataset.csv
git add data/raw/dataset.csv.dvc .gitignore

# Push to remote
dvc remote add -d myremote s3://mybucket/data
dvc push

# Pull data
dvc pull

# Switch versions (via Git)
git checkout v1.0
dvc checkout
```

## Pipeline Orchestration

### Airflow DAG

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

with DAG(
    dag_id="ml_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
) as dag:
    ingest = PythonOperator(
        task_id="ingest_data",
        python_callable=ingest_data
    )
    preprocess = PythonOperator(
        task_id="preprocess",
        python_callable=preprocess_data
    )
    train = PythonOperator(
        task_id="train_model",
        python_callable=train_model
    )
    evaluate = PythonOperator(
        task_id="evaluate_model",
        python_callable=evaluate_model
    )

    ingest >> preprocess >> train >> evaluate
```

### Prefect Flow

```python
from prefect import flow, task

@task
def load_data():
    return pd.read_csv("data.csv")

@task
def preprocess(df):
    return df.dropna()

@task
def train(df):
    model = RandomForestRegressor()
    model.fit(df[["x"]], df["y"])
    return model

@flow
def ml_pipeline():
    data = load_data()
    clean = preprocess(data)
    model = train(clean)
    return model
```

## MLOps Maturity Model

| Level | Name | Characteristics |
|-------|------|-----------------|
| 0 | No MLOps | Manual processes, no tracking, notebooks only |
| 1 | DevOps but no MLOps | Code in Git, CI/CD for code, but data/model not tracked |
| 2 | Automated Training | Experiment tracking, data versioning, model registry |
| 3 | Automated Deployment | CI/CD for models, A/B testing, automated retraining |
| 4 | Full MLOps | AutoML, self-healing pipelines, drift detection |

## ML Project Architecture Checklist

- [ ] Clear directory structure with separation of concerns
- [ ] Configuration separated from code (YAML/env/config objects)
- [ ] Experiment tracking configured (MLflow/W&B)
- [ ] Data versioning in place (DVC)
- [ ] Logging configured (structured, levels, file + console)
- [ ] Test suite for data validation, features, and models
- [ ] Model registry for version tracking
- [ ] Orchestration for scheduled retraining
- [ ] Monitoring for prediction drift and data quality
- [ ] Documentation of architecture and component interactions
