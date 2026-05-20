# Mini Project: Complete ML Workflow on Titanic

**Module 14 — Python for Machine Learning**

## Objective

Build a complete ML pipeline on the Titanic dataset — from data loading and preprocessing through model training, evaluation, and hyperparameter tuning. Compare multiple classifiers and recommend the best model for deployment.

## Dataset

**Titanic** (from seaborn)

A classic binary classification dataset: predict survival (0 = died, 1 = survived) based on passenger features.

## Tasks

### Part 1: Data Preparation (4 hours)
1. Load Titanic dataset from seaborn
2. Handle missing values in Age, Embarked, Cabin
3. Feature engineering: create FamilySize = sibsp + parch + 1, IsAlone = (FamilySize == 1)
4. Encode categorical features (sex, embarked)
5. Create train/test split (80/20, stratified)
6. Scale numerical features with StandardScaler

### Part 2: Model Training & Comparison (8 hours)
Train and evaluate at least 4 models:
1. Logistic Regression
2. Decision Tree
3. Random Forest
4. SVM
5. KNN

For each model:
- Report accuracy, precision, recall, F1-score
- Plot confusion matrix
- Plot ROC curve and compute AUC

### Part 3: Cross-Validation (4 hours)
1. Perform 5-fold cross-validation on all models
2. Compare mean and std of CV scores
3. Identify the most stable model (lowest variance)
4. Visualize CV results with box plots

### Part 4: Hyperparameter Tuning (6 hours)
1. Tune the best-performing model with GridSearchCV
2. Search spaces:
   - Random Forest: n_estimators [50, 100, 200], max_depth [3, 5, 10, None], min_samples_split [2, 5, 10]
   - OR SVM: C [0.1, 1, 10, 100], gamma ['scale', 'auto', 0.1, 0.01], kernel ['rbf', 'linear']
3. Report best parameters and best CV score
4. Evaluate tuned model on held-out test set
5. Compare pre-tuning and post-tuning performance

### Part 5: Model Interpretation (4 hours)
1. Extract and visualize feature importances from Random Forest
2. Extract coefficients from Logistic Regression (interpret as log-odds)
3. Create a SHAP-like summary (using feature importances or coefficients)
4. Write a paragraph explaining which features drive survival predictions

### Part 6: Final Report (4 hours)
Create a report including:
1. Data preparation summary
2. Model comparison table (all metrics)
3. CV results visualization
4. Hyperparameter tuning results
5. Final model recommendation with justification
6. Feature importance analysis
7. Code in a well-organized Jupyter notebook

## Deliverables

1. **Jupyter notebook** with complete, well-commented code
2. **Plots**: confusion matrices, ROC curves, CV box plot, feature importance
3. **Report**: Markdown or PDF with findings and recommendations

## Evaluation Criteria

| Criteria | Weight |
|----------|--------|
| Correct ML workflow (split, scale, train, evaluate) | 25% |
| Model comparison with appropriate metrics | 20% |
| Cross-validation implementation | 15% |
| Hyperparameter tuning | 20% |
| Model interpretation | 10% |
| Code quality and documentation | 10% |

## Resources

- scikit-learn docs: https://scikit-learn.org/stable/
- Seaborn Titanic: `sns.load_dataset('titanic')`
- Kaggle Titanic competition: https://www.kaggle.com/c/titanic

## Stretch Goals

- Implement feature engineering (Title extraction from Name, Cabin letter)
- Use ensemble methods (VotingClassifier, StackingClassifier)
- Create a Pipeline object combining preprocessing and model
- Export the best model with joblib
- Build a simple Streamlit app for predictions
