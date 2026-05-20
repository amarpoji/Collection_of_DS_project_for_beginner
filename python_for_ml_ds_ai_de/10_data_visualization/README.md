# Module 10: Data Visualization

**Duration:** 18 hours

## Overview

Data visualization is a critical skill for data scientists — it enables exploratory data analysis, pattern discovery, and effective communication of insights. This module covers matplotlib (the foundational plotting library) and seaborn (a high-level statistical visualization library), with a focus on EDA for ML workflows.

## Learning Objectives

By the end of this module, you will be able to:
- Understand matplotlib's figure and axes architecture
- Differentiate between pyplot (MATLAB-style) and OO API
- Create line plots, scatter plots, histograms, and box plots
- Build heatmaps for correlation analysis
- Design multi-panel subplot layouts
- Customize plots with colors, labels, legends, and annotations
- Create statistical visualizations with seaborn
- Generate pairplots, distplots, boxenplots, lmplots, and catplots
- Perform EDA visualization on ML datasets

## Prerequisites

- Pandas fundamentals (Module 09)
- Understanding of basic statistics (mean, median, correlation)

## Topics

### 1. Matplotlib Philosophy
- Figure and Axes architecture
- The pyplot interface (MATLAB-style)
- The Object-Oriented (OO) API
- When to use each approach

### 2. Line Plots
- Simple line charts
- Multiple lines on the same axes
- Styling (linewidth, linestyle, markers)
- Trend visualization

### 3. Scatter Plots
- Feature relationships
- Color encoding by category
- Size encoding by magnitude
- Alpha blending for overplotting

### 4. Histograms & Distributions
- Binning data
- Multiple histograms for comparison
- Density plots (KDE)
- Cumulative distributions

### 5. Box Plots for Outliers
- Five-number summary visualization
- IQR and outlier detection
- Grouped box plots by category
- Violin plots as alternatives

### 6. Heatmaps for Correlation
- Correlation matrix computation
- Annotated heatmaps
- Color maps for correlation strength
- Masking upper triangles

### 7. Subplots
- plt.subplots() for grid layouts
- Shared axes
- Different plot types in one figure
- Fine-tuning layout with gridspec

### 8. Customization
- Colors (named, hex, RGB, colormaps)
- Labels and titles
- Legends (location, customization)
- Annotations and text boxes
- Ticks and tick labels
- Grid lines and spines

### 9. Seaborn High-Level API
- Setting seaborn theme/style
- relplot for relational data
- displot for distributions
- catplot for categorical data

### 10. Advanced Seaborn
- pairplot for pairwise relationships
- distplot/histplot for distributions
- boxenplot for large-data box plots
- lmplot for regression with confidence bands
- heatmap with seaborn
- jointplot for bivariate distributions

## Practice Questions

1. Load the Iris dataset and create a scatter plot of sepal length vs sepal width, colored by species.
2. Create a 2x2 subplot grid showing histograms of all four Iris features.
3. Generate a correlation heatmap of the Titanic dataset numeric features.
4. Create a box plot of Age by Pclass from Titanic, colored by survival status.
5. Use seaborn's pairplot on Iris with hue='species'.
6. Create an lmplot showing Fare vs Age with hue='Survived' from Titanic.
7. Customize a matplotlib figure with title, axis labels, legend, and grid.
8. Create a boxenplot of Fare by Embarked port.
9. Overlay a KDE on a histogram using seaborn's histplot.
10. Create a subplot combining a scatter plot and its marginal histograms.

## Interview Questions

1. **What is the difference between pyplot and the OO API in matplotlib?**
   - pyplot stores a global figure/axes state (MATLAB-like), convenient for quick plots. The OO API gives explicit control over Figure and Axes objects, essential for complex layouts and embedding in applications.

2. **Explain the figure and axes architecture of matplotlib.**
   - Figure is the top-level container (like a canvas). Axes is an individual plot within the figure (the actual plotting area). A Figure can contain multiple Axes objects (subplots).

3. **When would you use seaborn over matplotlib?**
   - For statistical visualizations, when you want built-in grouping (hue, col, row), when you need statistical transforms (KDE, regression), and when you want publication-quality defaults with minimal code.

4. **How do you detect outliers visually?**
   - Box plots show outliers as points beyond whiskers (typically ±1.5×IQR). Scatter plots reveal isolated points. Histograms show long tails. Seaborn's boxenplot shows quantile distributions.

5. **What is the purpose of a heatmap in EDA?**
   - Heatmaps visualize correlation matrices, making it easy to spot multicollinearity (features correlated with each other) and features strongly correlated with the target.

6. **How do you handle overplotting in scatter plots?**
   - Use alpha transparency, reduce point size, use 2D histograms/hexbin, or randomly sample points.

7. **Explain the hue, col, and row parameters in seaborn.**
   - These create faceted plots: 'hue' colors by category within one plot, 'col' creates separate subplots per column category, 'row' creates separate subplots per row category.

8. **What's the difference between distplot (deprecated) and histplot in seaborn?**
   - distplot is deprecated in favor of histplot (histogram + optional KDE) and kdeplot (KDE only). histplot provides more control and better defaults.

9. **How can you customize a matplotlib colorbar?**
   - Use `plt.colorbar()` or `fig.colorbar()`, passing parameters for label, ticks, orientation, and colormap. For discrete colorbars, use `BoundaryNorm`.

10. **What are best practices for choosing colors in visualizations?**
    - Use colorblind-friendly palettes (e.g., 'Set2', 'colorblind' in seaborn). Limit categories to 6-8 distinct colors. Use sequential colormaps for continuous data. Avoid red-green for comparisons.

## Common Pitfalls

1. **Mixing pyplot and OO API**: Pick one style per script. Mixing them leads to confusion about the current figure state.
2. **Forgetting plt.show()**: In scripts, plots won't display without it. In Jupyter, use `%matplotlib inline`.
3. **Not closing figures**: Can cause memory leaks in loops. Use `plt.close()` or `plt.clf()`.
4. **Overplotting**: Too many points without transparency. Use alpha, sampling, or 2D histograms.
5. **Truncated labels**: `plt.tight_layout()` or `constrained_layout=True` prevents label clipping.
6. **Wrong plot type for data**: Don't use line plots for categorical data; use bar or box plots.
7. **Ignoring axis scales**: Log scale for skewed data. `plt.yscale('log')`.
8. **Color choices**: Avoid rainbow colormaps (e.g., 'jet') — they distort perception. Use 'viridis', 'plasma', or seaborn palettes.

## Resources

- [matplotlib documentation](https://matplotlib.org/stable/index.html)
- [seaborn documentation](https://seaborn.pydata.org/)
- [Matplotlib Cheat Sheet](https://matplotlib.org/cheatsheets/)
- [Seaborn Example Gallery](https://seaborn.pydata.org/examples/index.html)
- [Choosing Colormaps in Matplotlib](https://matplotlib.org/stable/users/explain/colors/colormaps.html)

## Next Module

Module 11: SQL for Data People — Bridge the gap between SQL and pandas for data science.
