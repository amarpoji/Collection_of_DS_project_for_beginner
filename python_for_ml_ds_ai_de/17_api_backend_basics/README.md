# Module 17: API & Backend Basics

**Duration: 16 hours**

## Overview

This module covers building REST APIs with FastAPI for deploying machine learning models in production. You will learn FastAPI fundamentals, Pydantic request/response models, CRUD operations, dependency injection, async endpoints, testing, CORS configuration, and environment management with pydantic-settings. The ML focus is deploying a trained sklearn house price prediction model as a production-ready REST API with input validation, error handling, and automated documentation via Swagger UI.

## Learning Objectives

By the end of this module, you will be able to:
- Create FastAPI applications with routes, path parameters, and query parameters
- Define request/response models using Pydantic with field validation constraints
- Implement GET, POST, PUT, DELETE endpoints following RESTful design
- Serve an sklearn ML model via a REST API with a prediction endpoint
- Write async endpoints and understand when async vs sync matters
- Use FastAPI's dependency injection system for shared model/config resources
- Test API endpoints with httpx TestClient and pytest fixtures
- Configure CORS middleware for cross-origin frontend access
- Manage environment variables with pydantic-settings and .env files
- Deploy an ML model as a production-grade prediction service

## Prerequisites

- Python Fundamentals (Modules 1-2)
- NumPy & Pandas (Modules 8-9)
- Scikit-learn Basics (Module 14)
- ML Workflow End-to-End (Module 16)

## Topics

### 1. FastAPI Fundamentals (2 hours)
- Installing FastAPI and uvicorn
- Creating your first application and route decorators
- Path parameters with type hints
- Query parameters and optional parameters
- Request body parsing with Pydantic models
- Response models and HTTP status codes
- Automatic OpenAPI/Swagger documentation generation

### 2. CRUD Operations (2 hours)
- GET: retrieving resources by ID or listing all
- POST: creating new resources with request validation
- PUT: full resource updates
- DELETE: removing resources with proper status codes
- In-memory data store patterns for prototyping
- Error handling with HTTPException and status codes

### 3. Pydantic Models (2 hours)
- Field types: str, int, float, bool, List, Tuple
- Field validation: ge, le, gt, lt, min_length, max_length, pattern
- Nested models and model composition
- Custom validators with @field_validator and @model_validator
- Config and schema customization (example, json_schema_extra)
- Response model serialization with alias and exclude

### 4. Serving ML Models via API (4 hours)
- Loading a trained sklearn model at application startup
- Creating a /predict POST endpoint with feature input validation
- Building a HousePricePrediction model with price, confidence, metadata
- Returning predictions with confidence scores/intervals
- Model versioning in endpoint paths or response headers
- Batch prediction endpoints accepting lists of samples
- Error handling for model inference failures

### 5. Async Endpoints (1 hour)
- async/await syntax in FastAPI route handlers
- When async matters: IO-bound vs CPU-bound operations
- Running blocking code in thread pool with run_in_threadpool
- Background tasks with BackgroundTasks
- Concurrent IO operations with asyncio.gather

### 6. Dependency Injection (1 hour)
- FastAPI Depends system for shared resources
- Providing ML model objects, database connections, config
- Dependency scopes: singleton (app.state) vs per-request
- Composing multiple dependencies together
- Generator-based dependencies for resource cleanup (yield)

### 7. Testing with httpx and pytest (2 hours)
- Setting up TestClient from FastAPI
- Testing CRUD endpoints with valid and invalid data
- Testing prediction endpoints with Pydantic-validated inputs
- Fixtures for reusable test client and test data
- Testing error cases (404, 422, 500 responses)
- Parametrized tests for multiple scenarios

### 8. CORS and Environment Configuration (1 hour)
- CORS middleware configuration and why it matters
- Allowing specific origins, methods, and headers
- Environment variables with pydantic-settings.BaseSettings
- Loading from .env files with Config.env_file
- Type-safe configuration with field validation on settings

### 9. Complete ML API Project (1 hour)
- Build a complete house price prediction service
- Train + save an sklearn model, create prediction API
- Input validation, error handling, request logging
- API documentation with interactive Swagger UI
- Containerization with Docker preparation

## ML Focus

- Deploying trained sklearn models as production REST APIs
- House price prediction endpoint with Pydantic feature validation
- Model versioning and lifecycle management strategies
- Batch prediction for efficient inference at scale
- Production-grade API structure for ML microservices
- Automated API documentation for ML model consumers

## Practice Questions

1. How does FastAPI use Python type hints to generate OpenAPI documentation?
2. What is the difference between path parameters and query parameters? When do you use each?
3. How does Pydantic Field(ge=0, le=1) protect your ML model from bad inputs?
4. Why should you load an ML model at app startup rather than inside each endpoint function?
5. When would you use async endpoints vs synchronous endpoints for an ML prediction API?
6. What is dependency injection and how does it help manage model objects across routes?
7. How do you simulate HTTP requests to test a FastAPI app without running a server?
8. What is CORS and what problem does it solve when a React frontend calls your API?
9. How would you handle model versioning — supporting v1 and v2 of a model simultaneously?
10. What happens if your model raises an exception during prediction? How should the API respond?

## Interview Questions

1. "Explain how FastAPI generates automatic documentation from your code."
   - Type hints -> Pydantic models -> OpenAPI schema -> Swagger UI and ReDoc.

2. "How would you design an API endpoint for ML model prediction?"
   - POST /predict with Pydantic request model, response model, input validation, error handling.

3. "What's the difference between app.state and Depends() for sharing the model object?"
   - app.state: singleton accessible everywhere. Depends: per-request or reusable with lifecycle mgmt.

4. "How do you test a FastAPI application?"
   - TestClient from fastapi.testclient, pytest fixtures, test with valid+invalid data.

5. "How would you handle a request where the model hasn't loaded yet?"
   - Check app.state.model is not None, return 503 Service Unavailable if missing.

## Common Pitfalls

| Mistake | Fix |
|---------|-----|
| Loading model inside endpoint function | Load once at startup with @app.on_event("startup") or lifespan |
| Blocking event loop with CPU-bound ML inference | Either use sync endpoints (recommended for CPU) or run_in_threadpool |
| Not validating input features | Always use Pydantic with Field(ge=, le=) constraints matching training data ranges |
| Hardcoding config values | Use pydantic-settings.BaseSettings with .env files |
| Forgetting CORS middleware | Add CORSMiddleware before any routes if a frontend calls the API |
| No error handling for model failures | Wrap predict() in try/except, return HTTPException with 500 and detail |
| Mixing up POST and GET for predictions | Use POST for prediction (sends data in body), GET for retrieving status |
| Not closing database connections | Use generator dependencies with yield/finally for cleanup |
