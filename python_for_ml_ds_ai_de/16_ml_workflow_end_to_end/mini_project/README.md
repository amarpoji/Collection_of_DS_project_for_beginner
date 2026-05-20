# Mini Project: End-to-End ML Project with Experiment Tracking

**Module 16 — ML Workflow End-to-End**

## Objective

Build a complete end-to-end machine learning project on the California Housing dataset. Implement pipeline design, model evaluation, interpretation, experiment tracking with MLflow, and model serialization. The goal is to create a production-ready ML workflow.

## Dataset

**California Housing** (from sklearn)

Predict median house value in California districts based on 8 features:
- MedInc, HouseAge, AveRooms, AveBedrms, Population, AveOccup, Latitude, Longitude

## Tasks

### Part 1: Project Structure & Data Preparation (3 hours)

1. Create the following directory structure:
   ```
   california_housing_project/
       data/
           raw/
           processed/
       notebooks/
       src/
           data/
           features/
           models/
       models/
       reports/figures/
       configs/
   ```

2. Load California Housing and save raw data to `data/raw/`
3. Perform EDA and save processed data to `data/processed/`
4. Create a config.yaml with parameters (test_size, random_state, model params)

### Part 2: Pipeline Design (5 hours)

1. Build a Pipeline with ColumnTransformer:
   - Scale numerical features with StandardScaler
   - Add polynomial features (degree=2) for MedInc
   - Create interaction features (Latitude × Longitude)
   - Use FeatureUnion or ColumnTransformer for parallel branches

2. Compare three regressors in the pipeline:
   - LinearRegression
   - Ridge
   - RandomForestRegressor

3. Evaluate each with 5-fold cross-validation
4. Select the best model family for further tuning

### Part 3: Hyperparameter Tuning (4 hours)

1. Use GridSearchCV on the best model family
2. For Random Forest: search n_estimators [50, 100, 200], max_depth [5, 10, None], min_samples_split [2, 5, 10]
3. For Ridge: search alpha [0.01, 0.1, 1, 10, 100]
4. Report best parameters and CV score
5. Evaluate on held-out test set

### Part 4: Model Evaluation (4 hours)

1. Generate a learning curve for the best model
2. Generate a validation curve for the most important hyperparameter
3. Plot predicted vs actual values
4. Plot residuals (should be randomly scattered around 0)
5. Report: R², RMSE, MAE on test set

### Part 5: Model Interpretation (3 hours)

1. Compute permutation feature importance
2. Create a SHAP summary plot (install shap if needed)
3. Pick 2 test samples and create SHAP waterfall plots
4. Write interpretations for each

### Part 6: Experiment Tracking (3 hours)

1. Use MLflow to track all experiments:
   - Log all model comparisons (Part 2)
   - Log all GridSearch trials (Part 3)
   - Log best model parameters, metrics, and artifacts
   - Log feature importance plot and SHAP summary

2. Compare runs using MLflow UI

### Part 7: Final Deliverable (2 hours)

1. Save the best full pipeline with joblib
2. Create a prediction script that:
   - Loads the pipeline
   - Takes new data (e.g., sample from test set)
   - Returns predictions
3. Write a README.md explaining how to reproduce the project
4. Create a requirements.txt

## Deliverables

1. **Project directory** with all source code organized
2. **Jupyter notebook** with complete analysis
3. **Saved pipeline** (best_model.joblib)
4. **MLflow runs** (mlruns directory)
5. **README.md** with reproduction instructions
6. **requirements.txt**

## Evaluation Criteria

| Criteria | Weight |
|----------|--------|
| Project structure and organization | 15% |
| Pipeline design with ColumnTransformer | 20% |
| Model evaluation (learning curves, residuals) | 20% |
| Model interpretation (SHAP, permutation) | 15% |
| MLflow experiment tracking | 20% |
| Final deliverable and documentation | 10% |

## Resources

- sklearn Pipeline docs: https://scikit-learn.org/stable/modules/pipeline.html
- MLflow docs: https://mlflow.org/docs/latest/index.html
- SHAP docs: https://shap.readthedocs.io/en/latest/
- joblib: https://joblib.readthedocs.io/en/latest/

## Stretch Goals

- Implement data versioning with DVC
- Build a FastAPI endpoint serving the model
- Create a Streamlit dashboard for model monitoring
- Set up a CI/CD pipeline for model retraining
- Deploy to a cloud service (AWS SageMaker, GCP AI Platform)
