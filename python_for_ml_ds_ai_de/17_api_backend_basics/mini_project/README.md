# Mini Project: House Price Prediction API

**Module 17 — API & Backend Basics**

## Objective

Build a production-ready REST API that serves a trained sklearn house price prediction model. The API will accept property features via POST requests, return predicted prices with confidence intervals, and include proper input validation, error handling, automated documentation, and comprehensive testing.

## Dataset

You will generate and use a synthetic house price dataset with these features:

| Feature | Type | Range | Description |
|---------|------|-------|-------------|
| bedrooms | int | 1-10 | Number of bedrooms |
| bathrooms | float | 0.5-10 | Number of bathrooms |
| sqft_living | int | 100-10000 | Living area in sq ft |
| sqft_lot | int | 100-100000 | Lot size in sq ft |
| floors | float | 1-4 | Number of floors |
| waterfront | bool | 0/1 | Has waterfront view |
| condition | int | 1-5 | Condition rating |
| yr_built | int | 1900-2025 | Year built |

The target is `price` (in USD), generated with a formula plus noise to create a realistic regression problem.

You will train a RandomForestRegressor, save it with joblib, then serve it via FastAPI.

## Tasks

### Part 1: Model Training & Serialization (2 hours)

1. Generate a synthetic dataset with at least 1000 samples
2. Split into train/test (80/20)
3. Train a RandomForestRegressor with good hyperparameters (n_estimators=100, max_depth=10, n_jobs=-1)
4. Evaluate: report MAE (mean absolute error) and R2 score
5. Compute feature importance and identify the top 3 features
6. Save the model with joblib as `model.joblib`
7. Also save the feature names list alongside the model

### Part 2: Basic API Setup (3 hours)

1. Create `main.py` with a FastAPI application
2. Load the model at startup using the modern `lifespan` pattern (not deprecated `@app.on_event`)
3. Create a root endpoint `GET /` returning API name, version, and status
4. Create a health check `GET /health` returning status and model loaded flag
5. Create a prediction endpoint `POST /predict`:
   - Accept `HouseFeatures` Pydantic model with field validation matching training data ranges
   - Return predicted price with confidence interval, prediction ID, and model version
   - Handle errors gracefully with try/except and HTTPException
6. Test with Swagger UI at http://localhost:8000/docs

### Part 3: Advanced API Features (3 hours)

1. Add a batch prediction endpoint `POST /predict-batch`:
   - Accept a list of up to 32 samples
   - Return a list of predictions with batch metadata
   - Return 422 if batch size exceeds limit
2. Add a model info endpoint `GET /model-info` returning:
   - Model type, number of estimators, max depth
   - Feature names and their importance scores
   - Model version
3. Add request logging using BackgroundTasks:
   - Log each request (timestamp, features, predicted price) to an in-memory list
   - Create a `GET /logs` endpoint returning recent logs
4. Add proper error handling for:
   - Model not loaded (503)
   - Invalid input features (422)
   - Prediction failure (500)
   - Resource not found (404)

### Part 4: Configuration (2 hours)

1. Create `settings.py` with pydantic-settings:
   ```python
   class Settings(BaseSettings):
       app_name: str = "House Price Prediction API"
       debug: bool = False
       model_path: str = "model.joblib"
       max_batch_size: int = 32
       allowed_origins: str = "http://localhost:5173"
       log_level: str = "INFO"
   ```
2. Create a `.env` file to override defaults
3. Load settings on startup and inject into routes via Depends()
4. Configure CORS middleware using the `allowed_origins` setting

### Part 5: Testing (3 hours)

1. Create `test_api.py` with pytest and TestClient
2. Test the health endpoint returns 200
3. Test the predict endpoint with valid data returns 200 with expected keys
4. Test the predict endpoint with invalid data (out-of-range values) returns 422
5. Test the predict endpoint with missing fields returns 422
6. Test the predict-batch endpoint with too many samples returns 422
7. Test the model-info endpoint returns 200 with model metadata
8. Use parametrized tests for multiple invalid input scenarios
9. Use pytest fixtures for the test client

### Part 6: Async & Dependency Injection (1 hour)

1. Create an async endpoint `GET /market-data` that:
   - Simulates fetching data from 3 external sources concurrently using `asyncio.gather`
   - Returns aggregated market data
2. Use dependency injection to provide the model object to endpoints
3. Create a generator-based dependency for a mock database connection

### Part 7: Docker & Deployment (2 hours)

1. Create a `Dockerfile`:
   ```dockerfile
   FROM python:3.11-slim
   WORKDIR /app
   COPY requirements.txt .
   RUN pip install -r requirements.txt
   COPY . .
   EXPOSE 8000
   CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
   ```
2. Create `requirements.txt` with all dependencies
3. Create a comprehensive `README.md` with setup and usage instructions
4. (Optional) Deploy to Render, Railway, or any cloud platform

## Deliverables

1. **train_model.py** — model training script
2. **model.joblib** — trained model file (gitignored)
3. **main.py** — FastAPI application with all endpoints
4. **models.py** — Pydantic request/response models
5. **settings.py** — configuration with pydantic-settings
6. **.env** — environment variables (gitignored)
7. **test_api.py** — pytest tests
8. **requirements.txt** — Python dependencies
9. **Dockerfile** — container definition
10. **README.md** — setup and usage instructions

## Project Structure

```
house_price_api/
├── main.py              # FastAPI app, routes, startup
├── models.py            # Pydantic request/response models
├── settings.py          # pydantic-settings configuration
├── train_model.py       # Training script
├── model.joblib         # Trained model (gitignored)
├── test_api.py          # pytest tests
├── .env                 # Environment variables (gitignored)
├── requirements.txt     # Python dependencies
├── Dockerfile           # Container definition
└── README.md            # Setup and usage instructions
```

## Evaluation Criteria

| Criteria | Weight |
|----------|--------|
| Model training, evaluation, and serialization | 10% |
| API design (routes, models, validation, error handling) | 25% |
| Input validation with Pydantic (comprehensive constraints) | 15% |
| Batch prediction and model info endpoints | 10% |
| Testing coverage (valid, invalid, edge cases) | 20% |
| Configuration with pydantic-settings + CORS | 10% |
| Async endpoint and dependency injection | 5% |
| Documentation and Docker setup | 5% |

## Dependencies

```
fastapi>=0.110.0
uvicorn[standard]>=0.27.0
pydantic>=2.5.0
pydantic-settings>=2.1.0
scikit-learn>=1.3.0
numpy>=1.24.0
joblib>=1.3.0
httpx>=0.26.0
pytest>=7.4.0
```

## Resources

- FastAPI docs: https://fastapi.tiangolo.com/
- Pydantic docs: https://docs.pydantic.dev/
- FastAPI Testing: https://fastapi.tiangolo.com/tutorial/testing/
- pydantic-settings: https://docs.pydantic.dev/latest/concepts/pydantic_settings/
- Uvicorn: https://www.uvicorn.org/
- Scikit-learn RandomForest: https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestRegressor.html
- Joblib: https://joblib.readthedocs.io/

## Stretch Goals

- Add authentication with API keys (validate in a dependency)
- Add Prometheus metrics with prometheus-fastapi-instrumentator
- Add request rate limiting with slowapi
- Deploy to a cloud platform (Render, Railway, AWS, GCP)
- Add model versioning with multiple endpoints (/v1/predict, /v2/predict)
- Add a simple HTML frontend that calls the API (use Jinja2 templates)
- Add request caching for identical feature inputs
- Add model retraining endpoint that accepts new training data
- Add data drift monitoring (compare request distributions to training data)
- Add OpenTelemetry for distributed tracing
