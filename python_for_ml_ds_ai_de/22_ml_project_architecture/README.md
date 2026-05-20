# Module 22: ML Project Architecture

**Duration: 16 hours**

## Overview

This module covers the architectural patterns and tools needed to build production-ready machine learning projects. You will learn how to structure ML codebases, manage configuration, track experiments, version data and models, and orchestrate ML pipelines. The focus is on designing modular, maintainable, and scalable ML systems that can transition from research to production.

## Learning Objectives

By the end of this module, you will be able to:
- Apply project structure patterns like cookiecutter Data Science and modular monoliths
- Manage configuration with Hydra, pydantic-settings, and YAML configs
- Set up logging and monitoring for ML systems
- Track experiments with MLflow and Weights & Biases
- Version data with DVC and manage model registries
- Understand feature stores and pipeline orchestration concepts
- Design production-ready ML project architectures

## Topics Covered

| Topic | Hours | Description |
|-------|-------|-------------|
| Project structure patterns | 2 | cookiecutter DS, modular monolith layouts |
| Configuration management | 2.5 | Hydra, pydantic-settings, YAML configs |
| Logging and monitoring setup | 1.5 | Structured logging, monitoring dashboards |
| Experiment tracking | 3 | MLflow, Weights & Biases, tracking APIs |
| Model registries | 1.5 | Model versioning, staging, promotion |
| Data versioning | 2 | DVC, data pipeline versioning |
| Feature stores concept | 1 | Online vs offline feature stores |
| Pipeline orchestration | 2 | Airflow, Prefect, DAG-based workflows |

## ML/DS Relevance

This module bridges the gap between notebook-based prototyping and production ML systems:
- Structuring code for maintainability and collaboration
- Reproducible experiment tracking across team members
- Versioning datasets alongside code changes
- Designing feature pipelines that serve both training and inference
- Building modular architectures that enable team scalability

## Prerequisites

- Python project structure basics (Module 07)
- ML workflow understanding (Module 16)
- Command-line familiarity

## Key Files

| File | Description |
|------|-------------|
| `lesson.ipynb` | Interactive lesson with architecture patterns |
| `exercises.ipynb` | Practice exercises on project design |
| `solutions.ipynb` | Exercise solutions |
| `cheatsheet.md` | Quick reference for ML project architecture tools |
| `mini_project/README.md` | Mini project: Design a production ML project structure |

## Practice Questions

1. What are the trade-offs between cookiecutter DS and a modular monolith approach?
2. When would you use Hydra vs pydantic-settings for configuration?
3. How do experiment tracking systems ensure reproducibility?
4. What is the difference between online and offline feature stores?
5. How does DVC integrate with Git for data versioning?

## Interview Questions

1. "Design the folder structure for a team of 5 ML engineers working on a recommendation system."
2. "How would you handle configuration for a model that needs different parameters in dev, staging, and production?"
3. "Describe how you would migrate a Jupyter notebook prototype to a production ML system."
4. "What metrics would you monitor in a production ML system, and how would you track them?"
5. "Explain the MLOps maturity model and where most organizations fall."

## Common Pitfalls

- Mixing configuration with code (hardcoding paths, parameters)
- Using notebooks as production code without refactoring
- Not versioning data, only code
- Over-engineering architecture before requirements are clear
- Ignoring environment-specific configurations
- Tracking experiments inconsistently (missing hyperparameters, data versions)
- Not separating feature computation from model training
- Building monolithic feature pipelines that are hard to debug
- Forgetting to handle configuration validation and defaults
- Not documenting the architecture and component interactions

## References

- Cookiecutter Data Science: https://drivendata.github.io/cookiecutter-data-science/
- Hydra: https://hydra.cc/
- pydantic-settings: https://docs.pydantic.dev/latest/concepts/pydantic_settings/
- MLflow: https://mlflow.org/
- Weights & Biases: https://wandb.ai/
- DVC: https://dvc.org/
- Apache Airflow: https://airflow.apache.org/
- Prefect: https://www.prefect.io/
