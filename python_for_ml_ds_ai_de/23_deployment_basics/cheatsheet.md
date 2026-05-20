# Module 23: Deployment Basics — Cheatsheet

## Docker Essentials

### Dockerfile

```dockerfile
# Multi-stage build for smaller images
FROM python:3.10-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

FROM python:3.10-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Common Dockerfile Instructions

```
FROM          # Base image
WORKDIR       # Set working directory
COPY          # Copy files from host
RUN           # Execute command at build time
EXPOSE        # Document port
ENV           # Set environment variable
CMD           # Default command (runtime)
ENTRYPOINT    # Main command (overridable)
ARG           # Build-time variable
HEALTHCHECK   # Container health check
```

### .dockerignore

```
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
.env
.git/
.gitignore
*.md
notebooks/
data/
tests/
.DS_Store
```

### Docker Commands

```bash
# Build
docker build -t ml-api:latest .

# Run
docker run -p 8000:8000 ml-api:latest
docker run -d --name my-api -p 8000:8000 ml-api:latest

# List
docker ps           # running containers
docker images       # local images

# Stop/Remove
docker stop my-api
docker rm my-api
docker rmi ml-api:latest

# Logs
docker logs my-api
docker logs -f my-api  # follow

# Execute in container
docker exec -it my-api bash

# Tag and push
docker tag ml-api:latest user/ml-api:v1
docker push user/ml-api:v1
```

### docker-compose.yml

```yaml
version: "3.8"
services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - MODEL_PATH=/app/models/model.pkl
      - LOG_LEVEL=INFO
    volumes:
      - ./models:/app/models
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
```

## FastAPI Prediction API

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import joblib
import numpy as np
import pandas as pd
from typing import List, Optional

app = FastAPI(title="ML Prediction API", version="1.0.0")

# Request/Response schemas
class PredictionInput(BaseModel):
    features: List[float] = Field(..., description="Feature vector")
    model_version: Optional[str] = "latest"

class PredictionOutput(BaseModel):
    prediction: float
    probability: Optional[float] = None
    model_version: str

# Load model on startup
model = None
model_metadata = {}

@app.on_event("startup")
def load_model():
    global model, model_metadata
    model = joblib.load("models/model.pkl")
    model_metadata = {"version": "v1.0", "features": 10}

@app.get("/")
def root():
    return {"message": "ML Prediction API", "status": "running"}

@app.get("/health")
def health():
    return {"status": "healthy", "model_loaded": model is not None}

@app.post("/predict", response_model=PredictionOutput)
def predict(input_data: PredictionInput):
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    features = np.array(input_data.features).reshape(1, -1)
    pred = model.predict(features)[0]
    prob = model.predict_proba(features)[0].max() if hasattr(model, "predict_proba") else None
    return PredictionOutput(
        prediction=float(pred),
        probability=float(prob) if prob else None,
        model_version=model_metadata["version"],
    )

@app.post("/predict_batch")
def predict_batch(inputs: List[PredictionInput]):
    results = []
    for inp in inputs:
        features = np.array(inp.features).reshape(1, -1)
        pred = model.predict(features)[0]
        results.append({"prediction": float(pred)})
    return {"predictions": results}
```

## Running the API

```bash
# Development (single process)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Production (with Gunicorn + Uvicorn workers)
gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.main:app \
  --bind 0.0.0.0:8000 \
  --timeout 120 \
  --access-logfile -

# Test the API
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"features": [1.0, 2.0, 3.0, 4.0, 5.0]}'
```

## CI/CD for ML

```yaml
# .github/workflows/deploy.yml
name: Deploy ML API
on:
  push:
    branches: [main]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: "3.10"
      - run: pip install -r requirements.txt
      - run: pytest tests/

  build-and-deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: docker build -t ml-api .
      - run: docker tag ml-api:latest registry.example.com/ml-api:latest
      - run: docker push registry.example.com/ml-api:latest
      - run: ssh deploy@server "docker pull registry.example.com/ml-api:latest && docker-compose up -d"
```

## Model Serving Patterns

### Real-Time (Synchronous)
```
Client -> POST /predict -> API Server (load balancer) -> Model -> Response
Latency: <100ms desired
Examples: Fraud detection, recommendation
```

### Batch (Asynchronous)
```
Scheduler -> Batch Job -> Load Data -> Score -> Save Results -> Downstream
Latency: Minutes to hours
Examples: Customer scoring, report generation
```

## Monitoring - Drift Detection

```python
# Conceptual drift detection
def detect_data_drift(reference_data, production_data, threshold=0.05):
    from scipy.stats import ks_2samp
    drift_results = {}
    for col in reference_data.columns:
        stat, p_value = ks_2samp(reference_data[col], production_data[col])
        drift_results[col] = {
            "ks_statistic": stat,
            "p_value": p_value,
            "drift_detected": p_value < threshold,
        }
    return drift_results
```

## ngrok for Testing

```bash
# Expose local server
ngrok http 8000

# Output:
# Forwarding https://abc123.ngrok.io -> http://localhost:8000

# Test via ngrok
curl https://abc123.ngrok.io/health
```

## Cloud Deployment Quick Reference

| Platform | Compute | ML Specific | Easiest Path |
|----------|---------|-------------|--------------|
| AWS | EC2, ECS, Lambda | SageMaker | Elastic Beanstalk |
| GCP | Compute Engine, Cloud Run | Vertex AI | Cloud Run |
| Azure | VM, AKS, Functions | Azure ML | App Service |
