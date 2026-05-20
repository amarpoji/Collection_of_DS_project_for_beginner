# Mini Project: EDA Visualization for ML Datasets

## Objective

Create a comprehensive exploratory data analysis (EDA) visualization report for two classic ML datasets: Iris (classification) and Titanic (survival prediction). The goal is to uncover patterns, relationships, and anomalies that inform feature selection and model building.

## Datasets

1. **Iris Dataset** — `sklearn.datasets.load_iris()`
   - 150 samples, 4 features, 3 species
   - Features: sepal length, sepal width, petal length, petal width

2. **Titanic Dataset**
   - URL: `https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv`
   - 891 passengers, mix of numeric and categorical features

## Requirements

Implement the following visualizations in a Jupyter notebook using both matplotlib and seaborn.

### Part 1: Iris Dataset — Classification EDA (40%)

1. **Pairplot** — Use `sns.pairplot()` with hue='species', diag_kind='kde'. Save as `iris_pairplot.png`.
2. **Correlation Heatmap** — Compute feature correlation and display with `sns.heatmap()`, annotated with correlation values.
3. **Feature Distributions** — Create a 2x2 subplot grid of histograms for each feature, colored by species (use alpha blending).
4. **Box Plots** — Side-by-side box plots for each feature grouped by species. Use a 2x2 layout.
5. **Scatter Matrix** — Use `pd.plotting.scatter_matrix()` as an alternative to pairplot.
6. **Violin Plots** — Create violin plots for petal length by species with inner quartiles shown.

### Part 2: Titanic Dataset — Survival EDA (40%)

1. **Survival Breakdown** — Count plot of survival status (`sns.countplot()`).
2. **Age Distribution** — Histogram of Age with KDE overlay, split by survival (`sns.histplot()` with hue).
3. **Class & Survival** — Grouped bar chart of survival rate by Pclass (`sns.barplot()`).
4. **Fare Analysis** — Box plot of Fare by Pclass, with hue='Survived'. Use log scale for y-axis.
5. **Age vs Fare Scatter** — Scatter plot of Age vs Fare, colored by survival, with size by Pclass.
6. **Correlation Heatmap** — Numeric feature correlation matrix as a heatmap.
7. **Pairplot (selected features)** — Use `sns.pairplot()` with vars=['Age', 'Fare', 'Pclass'], hue='Survived'.
8. **Embarked Analysis** — Count plot of Embarked with hue='Survived'.
9. **Family Size Impact** — Bar plot of survival rate by Family_Size (SibSp + Parch + 1).
10. **Gender Analysis** — Survival rate by Sex as a bar plot with confidence intervals.

### Part 3: Insights & Documentation (20%)

For each visualization, include a markdown cell with:
- What the plot shows
- Key observations
- Implications for ML modeling

Example format:
```markdown
**Observation:** Petal length shows clear separation between Setosa and other species.
**ML Implication:** Petal length will be a strong feature for classification, likely one of the top 2 features in feature importance.
```

## Deliverables

1. `eda_visualization_report.ipynb` — Complete notebook with all visualizations
2. At least 3 saved PNG figures: `iris_pairplot.png`, `titanic_correlation.png`, `titanic_survival_analysis.png`

## Evaluation Criteria

- All required visualizations are present and render correctly
- Plots are well-labeled (titles, axis labels, legends)
- Color choices are appropriate and accessible
- Insights are documented with ML implications
- Code is clean, well-documented, and follows best practices

## Stretch Goals

- Create an interactive plot using `plotly.express` for the Titanic scatter plot
- Use `sns.FacetGrid` to create a multi-panel visualization
- Add custom annotations to highlight key data points
- Create a dashboard-style layout with `plt.GridSpec`
- Explore `sns.boxenplot` for Fare distribution
