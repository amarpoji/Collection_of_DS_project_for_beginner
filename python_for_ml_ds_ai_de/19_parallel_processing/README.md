# Module 19: Parallel Processing

**Duration: 12 hours**

## Overview

This module covers parallel and concurrent programming in Python for ML workloads. You will learn threading, multiprocessing, and asyncio, understand the Global Interpreter Lock (GIL), use concurrent.futures, work with shared memory, and learn when to use each approach. The ML focus is parallelizing model training, data preprocessing, and inference.

## Learning Objectives

By the end of this module, you will be able to:
- Understand the differences between threading, multiprocessing, and asyncio
- Explain the GIL and its impact on Python performance
- Use ThreadPoolExecutor and ProcessPoolExecutor
- Work with multiprocessing pools and shared memory
- Write async/await code for IO-bound tasks
- Choose the right concurrency model for different ML tasks

## Prerequisites

- Python Functions (Module 2)
- OOP (Module 3)
- Basic understanding of CPU vs IO-bound tasks

## Topics

### 1. Threading (2 hours)
- Thread creation and management
- Thread safety and locks
- GIL limitations
- When threading helps
- threading vs concurrent.futures

### 2. The GIL Explained (1 hour)
- What is the Global Interpreter Lock
- How GIL affects CPU-bound vs IO-bound tasks
- GIL and C extensions (NumPy, scikit-learn)
- Future of GIL (Python 3.13+ free-threaded mode)

### 3. Multiprocessing (3 hours)
- Process creation and management
- multiprocessing.Pool
- Shared memory (Value, Array)
- Manager for shared state
- Process communication (Queue, Pipe)

### 4. concurrent.futures (2 hours)
- ThreadPoolExecutor
- ProcessPoolExecutor
- Submitting and collecting results
- Context manager usage
- Timeouts and cancellation

### 5. AsyncIO Basics (2 hours)
- async/await syntax
- Event loop
- Coroutines, tasks, futures
- asyncio.gather, asyncio.create_task
- Libraries for async (aiohttp, aiofiles)

### 6. When to Use Each (1 hour)
- Decision framework: IO-bound vs CPU-bound
- ML-specific scenarios
- Performance comparison benchmarks

### 7. ML Focus: Parallel Processing (1 hour)
- Parallelizing data preprocessing
- Parallel model training (sklearn n_jobs)
- Batch inference with multiprocessing
- Async data loading pipelines

## ML Focus
- Parallelize data preprocessing with multiprocessing
- Speed up hyperparameter search
- Batch model inference across processes
- Async data loading for training pipelines
- Understanding when sklearn parallelizes internally
