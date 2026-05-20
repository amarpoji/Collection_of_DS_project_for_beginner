# Module 24: Capstone Projects — Cheatsheet

## Project 1: End-to-End ML Pipeline

### Architecture
```
data/raw/ --> data/processed/ --> feature engineering --> model training --> evaluation --> MLflow tracking
                                    |                                                      |
                                    v                                                      v
                              train/test split                                    registry/model.pkl
```

### Key Libraries
```python
import pandas as pd, numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error, r2_score
import mlflow
import matplotlib.pyplot as plt
import seaborn as sns
```

### Experiment Tracking with MLflow
```python
mlflow.set_experiment("house-prices")
with mlflow.start_run():
    mlflow.log_params({"model": "rf", "n_estimators": 100})
    mlflow.log_metrics({"rmse": 45000, "r2": 0.87})
    mlflow.sklearn.log_model(model, "model")
    mlflow.log_artifact("feature_importance.png")
```

### Evaluation Metrics
- Regression: RMSE, MAE, R², MAPE
- Classification: Accuracy, Precision, Recall, F1, AUC-ROC
- Cross-validation: Mean ± std of primary metric

## Project 2: Data Engineering ETL Pipeline

### Architecture
```
CSV/API Source --> Extract (pandas/requests) --> Transform (pandas) --> Load (SQLite) --> Schedule (Airflow)
```

### ETL Template
```python
def extract():
    return pd.read_csv("source.csv"), requests.get(api_url).json()

def transform(df, api_data):
    df = df.dropna()
    df = df.merge(pd.DataFrame(api_data), on="id")
    df["new_feature"] = df["col1"] / df["col2"]
    return df

def load(df, db_path="data/pipeline.db"):
    import sqlite3
    conn = sqlite3.connect(db_path)
    df.to_sql("processed_data", conn, if_exists="replace", index=False)
    conn.close()
```

### Airflow DAG Template
```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

default_args = {"owner": "data_team", "retries": 3, "retry_delay": timedelta(minutes=5)}

with DAG("etl_pipeline", default_args=default_args,
         schedule_interval="@daily", start_date=datetime(2024, 1, 1),
         catchup=False) as dag:
    extract_task = PythonOperator(task_id="extract", python_callable=extract)
    transform_task = PythonOperator(task_id="transform", python_callable=transform)
    load_task = PythonOperator(task_id="load", python_callable=load)
    extract_task >> transform_task >> load_task
```

## Project 3: Recommendation System

### Architecture
```
User-Item Matrix --> Similarity Computation --> Recommend Top-K --> Evaluate (precision@k/recall@k)
```

### Collaborative Filtering
```python
from sklearn.metrics.pairwise import cosine_similarity

user_item_matrix = df.pivot_table(index="user_id", columns="item_id", values="rating")
user_sim = cosine_similarity(user_item_matrix.fillna(0))

def recommend(user_id, n=5):
    sim_users = np.argsort(user_sim[user_id])[::-1][1:6]
    items = user_item_matrix.iloc[sim_users].mean()
    return items.nlargest(n).index.tolist()
```

### Evaluation
```python
def precision_at_k(recommended, relevant, k):
    rec_at_k = recommended[:k]
    return len(set(rec_at_k) & set(relevant)) / k

def recall_at_k(recommended, relevant, k):
    rec_at_k = recommended[:k]
    return len(set(rec_at_k) & set(relevant)) / len(relevant)
```

## Project 4: NLP Project

### Architecture
```
Raw Text --> Preprocessing (cleaning/tokenization) --> Features (TF-IDF/embeddings) --> Model --> Evaluation
```

### Text Processing Pipeline
```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression

nlp_pipeline = Pipeline([
    ("tfidf", TfidfVectorizer(max_features=5000, ngram_range=(1, 2),
                               stop_words="english")),
    ("clf", LogisticRegression(max_iter=1000)),
])
nlp_pipeline.fit(X_train, y_train)
```

### Evaluation
```python
from sklearn.metrics import classification_report, confusion_matrix
print(classification_report(y_test, nlp_pipeline.predict(X_test)))
```

## Project 5: Production Prediction API

### Architecture
```
Train Model --> FastAPI App --> Pydantic Schemas --> Docker Container --> Tests --> CI/CD
```

### FastAPI + Docker
```python
@app.post("/predict", response_model=PredictionOut)
def predict(data: PredictionIn):
    features = np.array(data.features).reshape(1, -1)
    pred = model.predict(features)[0]
    return PredictionOut(prediction=float(pred))
```

```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## General Tools Reference

| Tool | Purpose | Command / Usage |
|------|---------|-----------------|
| Git | Version control | git init, add, commit, push |
| Conda | Environment | conda create -n capstone python=3.10 |
| pytest | Testing | pytest tests/ -v |
| black | Code formatting | black . |
| flake8 | Linting | flake8 src/ |
| pre-commit | Git hooks | pre-commit install |
| mkdocs | Documentation | mkdocs serve |
