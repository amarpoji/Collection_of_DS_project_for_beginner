# Module 20: Advanced Python Patterns

**Duration: 16 hours**

## Overview

This module covers advanced Python patterns essential for production ML systems. You will learn decorators, generators, context managers, descriptors, metaclasses, mixins, and design patterns (factory, singleton, observer, dependency injection). The ML focus is building robust, maintainable, and production-grade ML systems using these patterns.

## Learning Objectives

By the end of this module, you will be able to:
- Write decorators for logging, timing, retry, and caching
- Use generators for memory-efficient data processing
- Create context managers for resource management
- Understand and apply descriptors and metaclasses
- Implement design patterns: factory, singleton, observer
- Use mixins for reusable behavior
- Apply dependency injection for testable ML code
- Build production-ready ML pipeline components

## Prerequisites

- Python Functions (Module 2)
- OOP in Python (Module 3)
- Error Handling (Module 6)

## Topics

### 1. Decorators (3 hours)
- Function and class decorators
- Decorators with arguments
- Built-in decorators: @staticmethod, @classmethod, @property
- Logging decorators for ML pipelines
- Timing and profiling decorators
- Retry decorators for ML API calls
- Caching/Memoization decorators

### 2. Generators and Yield (2 hours)
- Generator functions with yield
- Generator expressions
- Memory-efficient data processing pipelines
- Infinite sequences and streaming
- yield from for nested generators
- ML data generator patterns

### 3. Context Managers (2 hours)
- with statement protocol
- contextlib.contextmanager
- contextlib.ContextDecorator
- Context managers for ML resources
- Nested context managers
- Database/model session management

### 4. Descriptors and Metaclasses (1 hour)
- Descriptor protocol (__get__, __set__, __delete__)
- Property descriptor vs @property
- Metaclass basics (__new__, __init__)
- When and when not to use metaclasses
- Practical use cases in ML frameworks

### 5. Mixins (1 hour)
- Multiple inheritance patterns
- Mixin class design
- ML-specific mixins (LoggableMixin, SerializableMixin)
- Diamond problem resolution

### 6. Design Patterns (4 hours)
- Factory pattern: model factory, data loader factory
- Singleton pattern: configuration, model registry
- Observer pattern: metrics monitoring, model logging
- Dependency injection: testable ML components
- Strategy pattern: different ML algorithms

### 7. Production Patterns for ML (3 hours)
- Config objects with dataclasses + pydantic
- Pipeline composition (chain of responsibility)
- Retry decorators for model inference
- Feature store client patterns
- Model registry patterns

## ML Focus
- Retry decorators for unreliable ML API calls
- Config objects for model hyperparameters
- Pipeline composition for ML workflows
- Factory pattern for model selection
- Singleton pattern for model registry
- Observer pattern for ML metrics monitoring
- Context managers for model session management
