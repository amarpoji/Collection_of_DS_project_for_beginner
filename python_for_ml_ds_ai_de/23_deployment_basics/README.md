# Module 23: Deployment Basics

**Duration: 16 hours**

## Overview

This module covers the fundamentals of deploying machine learning models to production. You will learn Docker containerization, model serving patterns, API deployment with FastAPI, cloud deployment basics, CI/CD for ML, and monitoring deployed models. The focus is on practical skills for getting models from notebooks to production APIs.

## Learning Objectives

By the end of this module, you will be able to:
- Containerize ML applications using Docker and docker-compose
- Build and deploy FastAPI prediction APIs with Pydantic validation
- Understand batch vs real-time model serving patterns
- Deploy to cloud platforms (AWS, GCP, Azure basics)
- Set up CI/CD pipelines for ML model deployment
- Monitor deployed models for drift and performance degradation
- Use ngrok for testing local deployments remotely

## Topics Covered

| Topic | Hours | Description |
|-------|-------|-------------|
| Docker fundamentals | 3 | Dockerfile, docker-compose, .dockerignore |
| Containerizing ML APIs | 2.5 | Packaging models, dependencies, environment |
| Model serving patterns | 1.5 | Batch vs real-time, trade-offs |
| FastAPI deployment | 3 | FastAPI + Uvicorn + Gunicorn, Pydantic validation |
| Cloud deployment basics | 2 | AWS/GCP/Azure, deployment options |
| CI/CD for ML | 2 | GitHub Actions, automated testing and deployment |
| Monitoring deployed models | 1.5 | Drift detection, performance tracking |
| ngrok for testing | 0.5 | Exposing local servers for testing |

## ML/DS Relevance

Deployment is where ML models create real business value. This module focuses on:
- Building prediction APIs that handle production traffic
- Containerizing ML dependencies for reproducible deployments
- Designing model serving architecture (batch scoring, real-time APIs)
- Implementing monitoring to catch model degradation early
- Setting up CI/CD pipelines that validate model performance before deployment

## Prerequisites

- Python web basics (Module 17)
- ML model building (Module 14-16)
- Command-line and basic system administration

## Key Files

| File | Description |
|------|-------------|
| `lesson.ipynb` | Interactive lesson on deployment concepts |
| `exercises.ipynb` | Practice deployment exercises |
| `solutions.ipynb` | Exercise solutions |
| `cheatsheet.md` | Quick reference for Docker, FastAPI, deployment |
| `mini_project/README.md` | Mini project: Containerize and deploy an ML API |

## Practice Questions

1. What is the difference between CMD and ENTRYPOINT in a Dockerfile?
2. When would you choose batch serving over real-time API serving?
3. What is the purpose of Gunicorn in a FastAPI deployment?
4. How do you handle model versioning in a deployed API?
5. What metrics would you monitor for a deployed model to detect drift?

## Interview Questions

1. "Walk me through how you would deploy a scikit-learn model as a REST API."
2. "How do you handle model updates in production without downtime?"
3. "Describe the difference between data drift and concept drift and how to detect each."
4. "How would you design a CI/CD pipeline for an ML model that needs performance validation?"
5. "What factors would you consider when choosing between batch and real-time serving?"

## Common Pitfalls

- Not pinning dependency versions in Docker images
- Building overly large Docker images (include unnecessary files)
- Exposing internal endpoints or debug routes in production
- Not handling model loading errors gracefully in the API
- Forgetting to add health check endpoints
- Using CPU-only images for models that need GPU
- Not configuring logging for production APIs
- Ignoring CORS configuration for web-based clients
- Not testing the Docker build locally before cloud deployment
- Overlooking rate limiting and authentication for production APIs

## References

- Docker documentation: https://docs.docker.com/
- FastAPI: https://fastapi.tiangolo.com/
- Uvicorn: https://www.uvicorn.org/
- Gunicorn: https://gunicorn.org/
- Docker Compose: https://docs.docker.com/compose/
- GitHub Actions: https://docs.github.com/en/actions
- ngrok: https://ngrok.com/
- "Architecture of Open Source Applications" - Model serving patterns
