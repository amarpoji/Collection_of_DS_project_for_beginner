# Capstone Projects: Selection Guide

This guide helps you choose which capstone project(s) to tackle based on your interests, goals, and skill level. All five projects are portfolio-ready and demonstrate mastery of different aspects of the ML/DS engineering stack.

## Quick Comparison

| Project | Difficulty | Time | ML Focus | Engineering Focus | Portfolio Impact |
|---------|-----------|------|----------|-------------------|-----------------|
| 1. End-to-End ML Pipeline | ★★★★☆ | 8 hrs | High | Medium | High |
| 2. Data Engineering ETL | ★★★☆☆ | 6 hrs | Low | High | Medium |
| 3. Recommendation System | ★★★★☆ | 6 hrs | High | Medium | High |
| 4. NLP Project | ★★★★☆ | 6 hrs | High | Low | High |
| 5. Production API | ★★★★☆ | 6 hrs | Medium | High | Very High |

## Project Selection by Career Goal

### Aspiring ML Engineer
**Recommended**: Project 1 + Project 5
- Demonstrates both modeling skills and production deployment
- Shows you can build, track, and deploy models
- Key skills: MLflow, scikit-learn, Docker, FastAPI

### Aspiring Data Scientist
**Recommended**: Project 1 + Project 3 or 4
- Focus on modeling, evaluation, and business insights
- Shows depth in analysis and model building
- Key skills: EDA, feature engineering, model evaluation

### Aspiring Data Engineer
**Recommended**: Project 2 + Project 5
- Focus on data pipelines, orchestration, and infrastructure
- Shows ability to build reliable data systems
- Key skills: ETL, Airflow, Docker, SQL

### Aspiring ML Ops Engineer
**Recommended**: Project 5 + Project 1
- Focus on deployment, monitoring, and reproducibility
- Shows understanding of the full ML lifecycle
- Key skills: Docker, CI/CD, MLflow, testing

### Full-Stack Data Scientist
**Recommended**: All 5 projects (or 1, 2, 3, 5)
- Demonstrates breadth across the entire stack
- Shows versatility and engineering capability
- Makes for a very strong portfolio

## Detailed Project Descriptions

### Project 1: End-to-End ML Pipeline
**Difficulty**: Hard | **Duration**: 8 hours | **Prerequisites**: Modules 1-16

Build a complete ML project from scratch including:
- Exploratory Data Analysis (EDA) with visualizations
- Feature engineering and selection
- Model selection with cross-validation
- Hyperparameter tuning (GridSearchCV/RandomizedSearchCV)
- Experiment tracking with MLflow
- Model evaluation and interpretation

**Best Dataset Options**:
- House Prices (Kaggle) — regression
- Titanic — classification
- Credit Card Fraud — imbalanced classification
- Diabetes progression (sklearn) — small, quick

**Portfolio Strength**: Demonstrates end-to-end ML workflow with professional experiment tracking.

### Project 2: Data Engineering ETL Pipeline
**Difficulty**: Medium | **Duration**: 6 hours | **Prerequisites**: Modules 11, 16, 18

Build an ETL pipeline that:
- Extracts data from CSV files and/or REST APIs
- Transforms data using pandas (cleaning, aggregation, feature creation)
- Loads data into SQLite database
- Schedules the pipeline with an Airflow DAG
- Includes data validation and quality checks

**Best Dataset Options**:
- NYC Taxi trips (public dataset)
- COVID-19 data from API
- Stock market data from Yahoo Finance API
- Weather data from OpenWeatherMap API

**Portfolio Strength**: Shows data engineering skills — pipeline design, orchestration, and data quality.

### Project 3: Recommendation System
**Difficulty**: Hard | **Duration**: 6 hours | **Prerequisites**: Modules 14, 15, 16

Build a recommendation system using:
- Collaborative filtering (user-user or item-item similarity)
- OR Content-based filtering (using item features)
- Evaluation with precision@k, recall@k, and mean average precision
- Handling cold-start problems

**Best Dataset Options**:
- MovieLens (100K or 1M) — classic recommender dataset
- Book-Crossing dataset
- Jester (joke recommendations)
- Last.fm (music recommendations)

**Portfolio Strength**: Specialized recommender system knowledge — valuable for e-commerce and media companies.

### Project 4: NLP Project
**Difficulty**: Hard | **Duration**: 6 hours | **Prerequisites**: Modules 14, 15, 16

Build an NLP solution with:
- Text preprocessing (cleaning, tokenization, lemmatization)
- Feature extraction (TF-IDF, word embeddings)
- Scikit-learn Pipeline for text classification
- Model evaluation and error analysis
- Optional: Simple web app to demo predictions

**Best Dataset Options**:
- Spam/Ham SMS collection
- IMDb movie reviews (sentiment)
- 20 Newsgroups (multiclass classification)
- Twitter disaster tweets

**Portfolio Strength**: NLP is one of the most in-demand ML specializations.

### Project 5: Production Prediction API
**Difficulty**: Hard | **Duration**: 6 hours | **Prerequisites**: Modules 17, 21, 23

Deploy a production-ready ML API:
- Train a model (can reuse from Project 1)
- Build FastAPI app with Pydantic validation
- Containerize with Docker (multi-stage build)
- Write comprehensive tests (pytest + TestClient)
- Set up CI/CD with GitHub Actions
- Include health checks, error handling, logging

**Best Dataset Options**:
- Iris dataset (simple, quick)
- Wine quality (regression)
- Any model from another project

**Portfolio Strength**: Demonstrates production ML engineering skills — one of the most valuable capabilities.

## How to Choose

### Option A: Depth (Recommended for most students)
Choose **one** project and do it exceptionally well:
- Add extra features beyond the requirements
- Write thorough tests (>85% coverage)
- Create excellent documentation
- Record a demo video

### Option B: Breadth (For strong students)
Choose **two** complementary projects:
- Project 1 + Project 5 (ML + Deployment)
- Project 2 + Project 5 (Data + Deployment)
- Project 3 + Project 4 (RecSys + NLP)

### Option C: Full Stack (For very strong students)
Complete **3-5 projects**:
- Start with Project 5 (deployment skills help everything)
- Then Project 1 (core ML)
- Then Project 2 or 3 or 4 based on interest

## Getting Started

1. **Day 1**: Choose project, set up repository, create project structure
2. **Day 2-3**: Implement core functionality
3. **Day 4**: Add tests, error handling, edge cases
4. **Day 5**: Write documentation, create README, add comments
5. **Day 6**: Polish, record demo, submit

## Resources

- Kaggle datasets: https://kaggle.com/datasets
- UCI ML Repository: https://archive.ics.uci.edu/ml
- MovieLens: https://grouplens.org/datasets/movielens/
- Papers With Code: https://paperswithcode.com/
- FastAPI docs: https://fastapi.tiangolo.com/
- MLflow docs: https://mlflow.org/docs/
