# API & Backend Basics — Cheatsheet

## FastAPI App Setup

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

# Modern pattern (lifespan replaces @app.on_event)
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: load model, connect to DB
    app.state.model = joblib.load("model.joblib")
    yield
    # Shutdown: cleanup
    print("Shutting down...")

app = FastAPI(title="House Price API", version="1.0.0", lifespan=lifespan)

@app.get("/")
def root():
    return {"api": "House Price Predictor", "status": "running"}
```

Run: `uvicorn main:app --reload`
Swagger docs: http://localhost:8000/docs
ReDoc: http://localhost:8000/redoc

## Path and Query Parameters

```python
# Path parameter (from URL path)
@app.get("/models/{model_version}")
def get_model(model_version: str):
    return {"version": model_version}

# Query parameters (from URL ?key=value)
@app.get("/search")
def search(q: str | None = None, limit: int = 10):
    return {"query": q, "limit": limit}

# Combined: path -> /products/42?category=electronics&page=2
@app.get("/products/{product_id}")
def get_product(product_id: int, category: str | None = None, page: int = 1):
    ...
```

## Route Ordering

```python
# WRONG: /search never matches because {listing_id} captures "search"
@app.get("/listings/{listing_id}")
@app.get("/listings/search")

# RIGHT: Static routes BEFORE parameterized routes
@app.get("/listings/search")
@app.get("/listings/{listing_id}")
```

## Pydantic Models

```python
from pydantic import BaseModel, Field, field_validator, model_validator

# Input model: validate feature data from client
class HouseFeatures(BaseModel):
    bedrooms: int = Field(..., ge=1, le=10, description="Number of bedrooms")
    bathrooms: float = Field(..., ge=0.5, le=10)
    sqft_living: int = Field(..., ge=100, le=10000)
    sqft_lot: int = Field(..., ge=100, le=100000)
    floors: float = Field(..., ge=1.0, le=4.0)
    waterfront: bool = False
    condition: int = Field(..., ge=1, le=5)
    yr_built: int = Field(..., ge=1900, le=2025)

    @model_validator(mode='after')
    def check_room_count(self):
        if self.bedrooms > 6 and self.sqft_living < 2000:
            raise ValueError(f"Too many bedrooms ({self.bedrooms}) for sqft ({self.sqft_living})")
        return self

# Response model: structure returned to client
class PricePrediction(BaseModel):
    predicted_price: float
    confidence_interval: tuple[float, float]
    prediction_id: str
    model_version: str = "1.0.0"
    features_used: list[str]

# Batch models
class BatchRequest(BaseModel):
    samples: list[HouseFeatures] = Field(..., max_length=32)

class BatchResponse(BaseModel):
    predictions: list[PricePrediction]
    batch_size: int
```

## CRUD Endpoints

```python
from fastapi import HTTPException

items_db = {}

@app.get("/items/{item_id}", response_model=Item)
def get_item(item_id: str):
    if item_id not in items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    return items_db[item_id]

@app.post("/items", response_model=Item, status_code=201)
def create_item(item: Item):
    items_db[item.id] = item
    return item

@app.put("/items/{item_id}", response_model=Item)
def update_item(item_id: str, item: Item):
    if item_id not in items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    items_db[item_id] = item
    return item

@app.delete("/items/{item_id}", status_code=204)
def delete_item(item_id: str):
    if item_id not in items_db:
        raise HTTPException(status_code=404, detail="Item not found")
    del items_db[item_id]
```

## ML Prediction Endpoint

```python
import joblib
import numpy as np
from fastapi import HTTPException

@app.post("/predict", response_model=PricePrediction)
def predict(features: HouseFeatures):
    model = app.state.model
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    try:
        X = np.array([[features.bedrooms, features.bathrooms,
                       features.sqft_living, features.sqft_lot,
                       features.floors, int(features.waterfront),
                       features.condition, features.yr_built]])
        pred = model.predict(X)[0]

        # Confidence interval from tree variance
        tree_preds = np.array([t.predict(X)[0] for t in model.estimators_])
        std = tree_preds.std()
        low, high = round(pred - 1.645 * std, 2), round(pred + 1.645 * std, 2)

        return {
            "predicted_price": round(float(pred), 2),
            "confidence_interval": (low, high),
            "prediction_id": str(uuid.uuid4()),
            "model_version": "1.0.0",
            "features_used": app.state.feature_names
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")

@app.post("/predict-batch", response_model=BatchResponse)
def predict_batch(batch: BatchRequest):
    if len(batch.samples) > 32:
        raise HTTPException(status_code=422, detail="Max batch size is 32")
    predictions = [predict(s) for s in batch.samples]
    return BatchResponse(predictions=predictions, batch_size=len(predictions))
```

## Model Loading at Startup

```python
# Pattern 1: deprecated (but still common)
@app.on_event("startup")
def load_model():
    app.state.model = joblib.load("model.joblib")

# Pattern 2: modern (lifespan + async context manager, preferred)
@asynccontextmanager
async def lifespan(app: FastAPI):
    app.state.model = joblib.load("model.joblib")
    print("Model loaded")
    yield
    print("Cleanup done")

app = FastAPI(lifespan=lifespan)
```

## Async Endpoints

```python
import asyncio
from fastapi.concurrency import run_in_threadpool

# Async for IO-bound work
@app.get("/market-data")
async def get_market_data():
    data = await asyncio.gather(
        fetch_zillow_data(),
        fetch_redfin_data()
    )
    return data

# CPU-bound work in thread pool
@app.get("/heavy-compute")
async def heavy():
    result = await run_in_threadpool(cpu_intensive_function)
    return {"result": result}

# Background tasks
from fastapi import BackgroundTasks

def log_request(prediction_id: str):
    print(f"Logged: {prediction_id}")

@app.post("/predict")
def predict(features: HouseFeatures, bg_tasks: BackgroundTasks):
    result = predict_price(features)
    bg_tasks.add_task(log_request, result["prediction_id"])
    return result
```

## Dependency Injection

```python
from fastapi import Depends

# Simple dependency
def get_model():
    return app.state.model

# Generator dependency (with cleanup)
def get_db():
    db = DatabaseConnection()
    try:
        yield db
    finally:
        db.close()

# Composed dependency
def get_model_info(
    model=Depends(get_model),
    config=Depends(get_config)
):
    return {"type": type(model).__name__, **config}

# In routes:
@app.get("/predict")
def predict(features: HouseFeatures, model=Depends(get_model)):
    ...
```

## Testing with httpx

```python
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

def test_predict_valid():
    response = client.post("/predict", json={
        "bedrooms": 3, "bathrooms": 2.0, "sqft_living": 1800,
        "sqft_lot": 5000, "floors": 1.5, "waterfront": False,
        "condition": 3, "yr_built": 1995
    })
    assert response.status_code == 200
    assert "predicted_price" in response.json()

def test_predict_invalid():
    response = client.post("/predict", json={"bedrooms": 100})  # Invalid
    assert response.status_code == 422

# Parametrized tests
@pytest.mark.parametrize("payload,expected_status", [
    ({"bedrooms": -1, ...}, 422),
    ({"sqft_living": 50, ...}, 422),
    ({"yr_built": 1800, ...}, 422),
])
def test_validation(payload, expected_status):
    response = client.post("/predict", json=payload)
    assert response.status_code == expected_status
```

## CORS Configuration

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",   # Vite dev
        "http://localhost:3000",   # React dev
        "https://myapp.com"        # Production
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## Environment Variables (pydantic-settings)

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_name: str = "House Price API"
    debug: bool = False
    model_path: str = "model.joblib"
    api_key: str = ""
    max_batch_size: int = 32
    allowed_origins: str = "http://localhost:5173"
    log_level: str = "INFO"

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"

settings = Settings()
```

**.env file:**
```
MODEL_PATH=production_model.joblib
DEBUG=false
MAX_BATCH_SIZE=64
ALLOWED_ORIGINS=http://localhost:5173,https://myapp.com
LOG_LEVEL=DEBUG
```

## Error Handling

```python
from fastapi import HTTPException

# Explicit error
@app.get("/items/{item_id}")
def get_item(item_id: str):
    if item_id not in db:
        raise HTTPException(status_code=404, detail="Item not found")
    return db[item_id]

# Model not loaded error
@app.post("/predict")
def predict(features: HouseFeatures):
    model = app.state.model
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded yet")
    try:
        ...
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")
```

## Status Codes Reference

| Code | Meaning | When to Use |
|------|---------|-------------|
| 200 | OK | Successful GET, PUT, POST |
| 201 | Created | Successful POST (new resource) |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Malformed request |
| 401 | Unauthorized | Missing/invalid auth |
| 403 | Forbidden | Valid auth, insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 422 | Unprocessable Entity | Validation error (Pydantic) |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unhandled server error |
| 503 | Service Unavailable | Model not loaded, maintenance |

## Common Patterns

```python
# Path operation config
@app.post("/predict", summary="Predict house price", tags=["prediction"])
def predict(features: HouseFeatures):
    ...

# Multiple response types
from typing import Union
@app.get("/items/{item_id}", response_model=Union[Item, ErrorResponse])
def get_item(item_id: str):
    ...

# Header parameters
from fastapi import Header
@app.get("/items")
def get_items(x_api_key: str = Header(...)):
    ...
```

## Quick Reference

```bash
uvicorn main:app --reload           # Development server
uvicorn main:app --host 0.0.0.0 --port 8000  # Production server
```

```python
@app.get("/route")                  # GET endpoint
@app.post("/route")                 # POST endpoint
@app.put("/route/{id}")             # PUT endpoint
@app.delete("/route/{id}")          # DELETE endpoint
Depends(dependency)                 # Dependency injection
TestClient(app)                     # Testing client
CORSMiddleware                      # CORS setup
BaseSettings                        # Environment config
HTTPException(status_code, detail)  # Error responses
Field(ge=0, le=1)                   # Validation constraints
BackgroundTasks                     # Background operations
```

## Common Pitfalls

| Mistake | Fix |
|---------|-----|
| Loading model inside endpoint | Load model once at startup (lifespan or on_event) |
| Blocking event loop with CPU work | Use sync endpoints or run_in_threadpool for CPU-bound tasks |
| Not validating inputs | Use Pydantic with Field(ge=, le=) matching training data ranges |
| Hardcoding config | Use pydantic-settings + .env files |
| Forgetting CORS for frontend | Add CORSMiddleware before any routes |
| Not testing API endpoints | Use TestClient with pytest, test valid + invalid data |
| No error handling for model failures | Wrap predict() in try/except, return descriptive HTTPException |
| Route ordering bugs | Define static routes before parameterized routes |
| Exposing stack traces in errors | Log server-side, return sanitized messages to client |
| Mixing up GET and POST for predictions | Use POST (data in body), GET for reads/status |
