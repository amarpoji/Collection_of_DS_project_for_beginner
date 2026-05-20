# Mini Project: Parallel ML Pipeline

**Module 19 — Parallel Processing**

## Objective

Build a parallel ML pipeline that preprocesses data, trains models, runs hyperparameter search, and performs batch inference — all using the appropriate parallelization strategy for each stage. Compare performance against sequential execution.

## Dataset

**Synthetic Dataset** — generate a large dataset (100,000+ rows, 20 features) for regression or classification.

## Tasks

### Part 1: Benchmark Sequential vs Parallel (2 hours)

1. Create a CPU-bound function (e.g., computing statistics on large arrays)
2. Create an IO-bound function (e.g., making simulated HTTP requests)
3. Run both with:
   - Sequential execution
   - ThreadPoolExecutor
   - ProcessPoolExecutor
4. Measure and compare execution times
5. Create a summary table showing which approach wins for each workload

### Part 2: Parallel Data Preprocessing (2 hours)

1. Generate a large DataFrame with 100,000+ rows and 20+ columns
2. Create a preprocessing pipeline that includes:
   - Missing value imputation (per column)
   - Outlier clipping (3-sigma rule)
   - Feature scaling (z-score normalization)
   - Feature engineering (polynomial features, interactions)
3. Implement a chunk-based parallel version using ProcessPoolExecutor
4. Compare preprocessing time: sequential vs parallel (2, 4, 8 workers)
5. Plot speedup vs number of workers

### Part 3: Parallel Hyperparameter Search (3 hours)

1. Implement a manual hyperparameter search (GridSearch-like) over a parameter grid
2. Run it:
   - Sequentially
   - With ProcessPoolExecutor (parallel over parameter combinations)
3. Use sklearn's built-in n_jobs=-1 for comparison
4. Measure time and document speedup
5. Compare your parallel search vs sklearn's GridSearchCV

### Part 4: Parallel Model Training (2 hours)

1. Implement training of multiple models in parallel:
   - Random Forest
   - Gradient Boosting
   - Ridge Regression
   - SVM (linear)
2. Use ProcessPoolExecutor to train each model on a separate process
3. Collect results and select the best model
4. Compare against sequential training

### Part 5: Parallel Batch Inference (2 hours)

1. Split a large test dataset (50,000 rows) into batches
2. Run inference:
   - Sequentially
   - With ThreadPoolExecutor (model already loaded)
   - With ProcessPoolExecutor (load model per process)
3. Measure throughput (predictions/second) for each approach
4. Find the optimal batch size

### Part 6: Async Data Loading Pipeline (1 hour)

1. Simulate an async data pipeline that:
   - Fetches data from multiple simulated API endpoints concurrently
   - Processes results as they arrive
   - Stores processed data
2. Use asyncio with aiohttp (or simulated async)

## Deliverables

1. **benchmark_parallel.py** — sequential vs parallel comparison
2. **parallel_preprocessing.py** — multiprocessing data pipeline
3. **parallel_search.py** — parallel hyperparameter search
4. **parallel_training.py** — multi-model parallel training
5. **batch_inference.py** — parallel batch inference
6. **async_pipeline.py** — async data loading
7. **results/** — timing results and plots
8. **README.md** — findings and recommendations

## Evaluation Criteria

| Criteria | Weight |
|----------|--------|
| Correct choice of parallelism (threads vs processes vs async) | 25% |
| Correct implementation of parallel patterns | 25% |
| Performance measurement and comparison | 20% |
| Speedup analysis and documentation | 15% |
| Code quality and organization | 15% |

## Resources

- concurrent.futures: https://docs.python.org/3/library/concurrent.futures.html
- multiprocessing: https://docs.python.org/3/library/multiprocessing.html
- asyncio: https://docs.python.org/3/library/asyncio.html
- GIL: https://realpython.com/python-gil/

## Stretch Goals

- Implement a distributed task queue with Celery or Ray
- Use shared memory (multiprocessing.shared_memory) for zero-copy data sharing
- Implement a producer-consumer pipeline with Queue
- Profile with cProfile and optimize bottlenecks
- Use numba for CPU-bound operations with GIL released
