# Mini Project: Containerize and Deploy an ML Prediction API

**Goal**: Containerize a trained ML model with Docker and deploy it as a FastAPI prediction API with CI/CD, monitoring, and testing.

## Scenario

You've trained a house price prediction model (Random Forest Regressor) that achieves RMSE of $45,000. Now you need to deploy it so the web team can integrate it into their real estate platform. The API must handle 100 requests/second with <200ms latency.

## Project Structure

```
house_price_api/
  app/
    __init__.py
    main.py           # FastAPI application
    schemas.py        # Pydantic request/response models
    model.py          # Model loading and prediction logic
    config.py         # Settings management
  models/
    model.pkl         # Trained model artifact
    scaler.pkl        # Feature scaler
    metadata.json     # Model info (version, features, metrics)
  tests/
    test_api.py       # API endpoint tests
    test_model.py     # Model tests
  Dockerfile
  docker-compose.yml
  .dockerignore
  requirements.txt
  .github/
    workflows/
      test.yml        # CI - run tests
      deploy.yml      # CD - build and deploy
  scripts/
    train.py          # Script to train and save model
    benchmark.py      # Performance benchmark
  monitoring/
    drift_detector.py # Drift monitoring logic
```

## Requirements

### Part 1: FastAPI Application
Build a prediction API with:
- `GET /` — API info and status
- `GET /health` — Health check (model loaded, uptime)
- `POST /predict` — Single prediction
- `POST /predict_batch` — Batch predictions (up to 100)
- `POST /predict/v2` — Future version (stub, returns 501)

Input schema:
```json
{
  "features": [sqft, bedrooms, bathrooms, age, ...],
  "options": {
    "return_proba": false,
    "model_version": "latest"
  }
}
```

Output schema:
```json
{
  "prediction": 450000.0,
  "confidence_interval": [420000, 480000],
  "model_version": "v1.0",
  "processing_time_ms": 12.5
}
```

### Part 2: Docker Containerization
- Create a Dockerfile (multi-stage build, <300MB image)
- Create a docker-compose.yml with health checks
- Create a .dockerignore file
- Verify the container starts and responds to requests
- Measure image size and startup time

### Part 3: Testing
- Test API endpoints with FastAPI TestClient
- Test model loading and prediction
- Test error cases (invalid input, missing model)
- Test batch prediction endpoint
- Aim for >85% code coverage

### Part 4: CI/CD Pipeline
Create GitHub Actions workflow:
- **CI** (on push): Run tests, lint code, check model performance
- **CD** (on merge to main): Build Docker image, push to registry, deploy

### Part 5: Monitoring Setup
Implement monitoring:
- Log all prediction requests (features, prediction, latency)
- Track average prediction per hour
- Simple data drift detection (KS test on feature distributions)
- Alert if error rate exceeds 1% or latency exceeds 500ms

### Part 6: Local Testing with ngrok
- Start the API locally with Docker
- Expose with ngrok
- Test the public endpoint
- Document the ngrok URL pattern for the web team

## Deliverables

1. Complete FastAPI application with Pydantic validation
2. Dockerfile and docker-compose.yml
3. .dockerignore file
4. Test suite with >85% coverage
5. GitHub Actions CI/CD configuration
6. Monitoring setup (logging + basic drift detection)
7. Performance benchmark report
8. README with deployment instructions

## Sample Data Generation

```python
# scripts/train.py — Simplified training script
import joblib
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler

np.random.seed(42)
n = 1000
X = pd.DataFrame({
    "sqft": np.random.normal(2000, 500, n),
    "bedrooms": np.random.randint(1, 6, n),
    "bathrooms": np.random.uniform(1, 4, n),
    "age": np.random.randint(0, 100, n),
})
y = 50000 + 150 * X["sqft"] + 10000 * X["bedrooms"] + 20000 * X["bathrooms"] - 500 * X["age"] + np.random.normal(0, 30000, n)

model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X, y)

joblib.dump(model, "models/model.pkl")
joblib.dump(StandardScaler(), "models/scaler.pkl")
print("Model trained and saved!")
```

## Extension Ideas

- Add authentication (API key validation)
- Add request caching with Redis (docker-compose)
- Implement A/B testing between model versions
- Add Prometheus metrics endpoint
- Deploy to a cloud platform (AWS Elastic Beanstalk, GCP Cloud Run)
- Add auto-scaling configuration
- Create a simple web frontend to test the API
