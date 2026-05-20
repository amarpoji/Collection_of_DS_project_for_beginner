# Mini Project: Statistical Analysis for Feature Selection

**Module 13 — Statistics for Data**

## Objective

Apply statistical testing to identify the most predictive features in a dataset, then build a simple classifier using only statistically-selected features. Compare performance against using all features.

## Dataset

**Titanic** (from seaborn)

The Titanic dataset contains passenger information and survival outcomes. It's ideal for practicing:
- Descriptive statistics on age, fare, family size
- Chi-square tests for categorical features (sex, pclass, embarked)
- t-tests for numerical features by survival group
- Correlation analysis between features
- Feature selection based on statistical significance

## Tasks

### Part 1: Exploratory Statistical Analysis (6 hours)
1. Load the Titanic dataset and compute descriptive statistics for all numerical columns
2. Create a five-number summary for Age and Fare by survival status
3. Identify outliers using IQR method
4. Visualize distributions with histograms and box plots

### Part 2: Hypothesis Testing (8 hours)
1. **t-test**: Test if Age differs between survivors and non-survivors
2. **t-test**: Test if Fare differs between survivors and non-survivors
3. **Chi-square**: Test independence of sex and survival
4. **Chi-square**: Test independence of pclass and survival
5. **ANOVA**: Test if Age differs across passenger classes
6. Compute Cohen's d for all significant t-tests
7. Apply Bonferroni correction for multiple testing

### Part 3: Correlation Analysis (4 hours)
1. Compute Pearson and Spearman correlation matrices
2. Identify top 3 features most correlated with survival
3. Create a heatmap of correlations
4. Discuss any surprising correlations

### Part 4: Feature Selection & ML Pipeline (6 hours)
1. Use SelectKBest with chi-square to select top categorical features
2. Use SelectKBest with f_classif to select top numerical features
3. Train a Logistic Regression model using only statistically-selected features
4. Train the same model using ALL features
5. Compare accuracy, precision, recall, and F1-score
6. Write a summary: Are statistically-selected features sufficient?

## Deliverables

1. **Python script or notebook** with complete analysis
2. **Visualizations** (box plots, histograms, correlation heatmaps)
3. **Written report** (checklist format):
   - Summary statistics table
   - Hypothesis test results table
   - Feature selection justification
   - Model comparison results
   - Conclusions and recommendations

## Evaluation Criteria

| Criteria | Weight |
|----------|--------|
| Correct application of statistical tests | 30% |
| Proper interpretation of p-values and effect sizes | 25% |
| Quality of visualizations | 15% |
| ML model comparison and analysis | 20% |
| Report clarity and depth | 10% |

## Resources

- `scipy.stats` documentation: https://docs.scipy.org/doc/scipy/reference/stats.html
- sklearn.feature_selection: https://scikit-learn.org/stable/modules/feature_selection.html
- Seaborn Titanic dataset: `sns.load_dataset('titanic')`

## Stretch Goals

- Implement bootstrapped confidence intervals for all test statistics
- Use Sequential Feature Selector (SFS) instead of SelectKBest
- Build a confusion matrix and ROC curve for the model
- Try Random Forest classifier instead of Logistic Regression
