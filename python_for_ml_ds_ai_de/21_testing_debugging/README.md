# Module 21: Testing & Debugging

**Duration: 14 hours**

## Overview

This module covers the essential practices of testing and debugging Python code, with a strong focus on machine learning applications. You will learn how to write robust tests using pytest and unittest, mock external dependencies, debug training loops effectively, and set up continuous integration for ML projects. The emphasis is on practical, production-ready testing patterns that catch bugs early and ensure ML pipeline reliability.

## Learning Objectives

By the end of this module, you will be able to:
- Write unit tests using pytest with fixtures, parametrization, and conftest.py
- Use unittest.mock and monkeypatch to isolate components during testing
- Debug Python code effectively using pdb/ipdb and logging
- Measure test coverage with pytest-cov
- Set up basic CI pipelines with GitHub Actions
- Apply TDD principles to ML projects
- Test ML pipelines including data transforms, model training, and inference

## Topics Covered

| Topic | Hours | Description |
|-------|-------|-------------|
| pytest fundamentals | 2 | assert, fixtures, parametrize, conftest.py |
| unittest module | 1.5 | TestCase, setUp, tearDown, test suites |
| Mocking techniques | 2 | unittest.mock, monkeypatch, mocking ML models |
| Debugging with pdb/ipdb | 2 | breakpoints, stepping, post-mortem debugging |
| Logging for debugging | 1.5 | log levels, handlers, debugging training loops |
| Test coverage | 1.5 | pytest-cov, coverage reports, improving coverage |
| CI basics | 2 | GitHub Actions, running tests in CI |
| TDD principles | 1.5 | Red-Green-Refactor, TDD for ML workflows |

## ML/DS Relevance

Testing is critical in ML projects where data, models, and pipelines interact in complex ways. This module focuses on:
- Testing data transformation pipelines for correctness
- Mocking expensive model training during unit tests
- Debugging non-deterministic training loops
- Testing feature engineering logic
- Ensuring reproducibility through tested pipelines
- Setting up CI that validates both code and data quality

## Prerequisites

- Python fundamentals (Module 01)
- Error handling and logging basics (Module 06)
- ML workflow understanding (Module 16)

## Key Files

| File | Description |
|------|-------------|
| `lesson.ipynb` | Interactive lesson with code examples |
| `exercises.ipynb` | Practice exercises |
| `solutions.ipynb` | Exercise solutions |
| `cheatsheet.md` | Quick reference for testing & debugging |
| `mini_project/README.md` | Mini project: Test a full ML pipeline |

## Practice Questions

1. What is the difference between a pytest fixture and a unittest setUp method?
2. How would you mock a model.predict() call that takes 10 seconds to run?
3. What debugging approach would you use for a training loop that diverges after 100 epochs?
4. How do you measure test coverage and interpret the results?
5. What CI steps would you add for an ML project beyond running tests?

## Interview Questions

1. "Explain how you would test a pandas DataFrame transformation that should handle missing values."
2. "Describe your approach to debugging a gradient explosion in a neural network training loop."
3. "How do you ensure ML pipeline reproducibility through testing?"
4. "What mocking strategy would you use for a function that calls an external API for data augmentation?"
5. "How would you set up CI/CD for a project that trains models and deploys them as APIs?"

## Common Pitfalls

- Testing implementation details instead of behavior
- Forgetting to mock time-consuming ML operations
- Using print() instead of logging for debugging
- Writing tests that depend on random state without seeding
- Not testing edge cases in data transformations
- Ignoring test coverage gaps in data preprocessing code
- Writing overly complex tests that are hard to maintain
- Testing model accuracy in unit tests instead of integration tests
- Not using fixture scoping properly (creating expensive fixtures repeatedly)
- Forgetting to clean up test resources (temp files, database connections)

## References

- pytest documentation: https://docs.pytest.org/
- unittest.mock docs: https://docs.python.org/3/library/unittest.mock.html
- pdb docs: https://docs.python.org/3/library/pdb.html
- pytest-cov: https://pytest-cov.readthedocs.io/
- GitHub Actions: https://docs.github.com/en/actions
- "Python Testing with pytest" by Brian Okken
