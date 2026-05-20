# Data Visualization Cheatsheet

## Imports
```python
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
```

## Matplotlib Basics

```python
# Figure and Axes (OO API)
fig, ax = plt.subplots(figsize=(8, 6))
ax.plot(x, y)
plt.show()

# Pyplot style
plt.plot(x, y)
plt.xlabel('X Label')
plt.ylabel('Y Label')
plt.title('Title')
plt.show()

# Jupyter inline
%matplotlib inline
```

## Line Plots
```python
plt.plot(x, y, color='blue', linewidth=2, linestyle='--', marker='o')
plt.plot(x, y1, label='Series 1')
plt.plot(x, y2, label='Series 2')
plt.legend()
```

## Scatter Plots
```python
plt.scatter(x, y, c=colors, s=sizes, alpha=0.5, cmap='viridis')
plt.colorbar(label='Value')
```

## Histograms
```python
plt.hist(data, bins=30, alpha=0.7, density=True, edgecolor='black')
plt.hist(data1, bins=30, alpha=0.5, label='Group 1')
plt.hist(data2, bins=30, alpha=0.5, label='Group 2')
```

## Box Plots
```python
plt.boxplot(data, labels=['A', 'B', 'C'], vert=True, patch_artist=True)
```

## Heatmaps
```python
corr = df.corr()
plt.imshow(corr, cmap='coolwarm', aspect='auto')
plt.colorbar()
plt.xticks(range(len(corr)), corr.columns, rotation=45)
plt.yticks(range(len(corr)), corr.columns)
# Annotated
for i in range(len(corr)):
    for j in range(len(corr)):
        plt.text(j, i, f'{corr.iloc[i,j]:.2f}', ha='center', va='center')
```

## Subplots
```python
fig, axes = plt.subplots(2, 3, figsize=(12, 8))
axes[0, 0].plot(x, y)
axes[0, 1].scatter(x, y)
# ... or flatten
axes_flat = axes.flatten()
axes_flat[0].hist(data)

# Share axes
fig, axes = plt.subplots(2, 2, sharex=True, sharey=True)
plt.tight_layout()

# GridSpec for complex layouts
gs = fig.add_gridspec(2, 2, width_ratios=[2, 1], height_ratios=[1, 2])
```

## Customization
```python
ax.set_xlabel('X Label', fontsize=12, fontweight='bold')
ax.set_ylabel('Y Label', fontsize=12)
ax.set_title('Title', fontsize=14, pad=20)
ax.legend(loc='upper right', frameon=True, shadow=True)
ax.grid(True, alpha=0.3, linestyle=':')
ax.set_xlim(0, 10)
ax.set_ylim(0, 100)
ax.set_xticks([0, 2, 4, 6, 8, 10])
ax.set_xticklabels(['zero', 'two', 'four', 'six', 'eight', 'ten'], rotation=45)
ax.axhline(y=50, color='r', linestyle='--', alpha=0.5)  # Reference line
ax.annotate('Important point', xy=(5, 50), xytext=(7, 80),
            arrowprops=dict(arrowstyle='->', color='black'))

# Color
colors = ['#FF5733', '#33FF57', '#3357FF']
```

## Saving Figures
```python
plt.savefig('plot.png', dpi=300, bbox_inches='tight')
plt.savefig('plot.pdf', dpi=300, bbox_inches='tight')
```

## Seaborn: Theme & Style
```python
sns.set_theme()                              # Modern default
sns.set_style('whitegrid')                   # 'darkgrid', 'white', 'dark', 'ticks'
sns.set_palette('husl')                     # 'Set1', 'Set2', 'colorblind', 'pastel'
sns.set_context('notebook')                 # 'paper', 'talk', 'poster'
sns.color_palette('viridis', n_colors=5)     # Get palette colors
```

## Seaborn: Relational Plots
```python
sns.scatterplot(data=df, x='x', y='y', hue='category', size='magnitude', alpha=0.7)
sns.lineplot(data=df, x='x', y='y', hue='category', style='category', markers=True)
sns.relplot(data=df, x='x', y='y', hue='cat', col='cat2', row='cat3', kind='scatter')
```

## Seaborn: Distribution Plots
```python
sns.histplot(data=df, x='col', bins=30, kde=True, hue='category', multiple='stack')
sns.kdeplot(data=df, x='col', hue='category', fill=True, alpha=0.5)
sns.ecdfplot(data=df, x='col', hue='category')  # Cumulative distribution
sns.rugplot(data=df, x='col')                   # Rug marks

# Bivariate distributions
sns.kdeplot(data=df, x='col1', y='col2', fill=True)
sns.jointplot(data=df, x='col1', y='col2', kind='hex')  # 'scatter', 'kde', 'reg'
```

## Seaborn: Categorical Plots
```python
sns.boxplot(data=df, x='cat_col', y='num_col', hue='hue_col')
sns.boxenplot(data=df, x='cat_col', y='num_col')  # Better for large data
sns.violinplot(data=df, x='cat_col', y='num_col', inner='quartile')
sns.barplot(data=df, x='cat_col', y='num_col', estimator=np.mean)
sns.countplot(data=df, x='cat_col', hue='hue_col')
sns.pointplot(data=df, x='cat_col', y='num_col', hue='hue_col')
sns.catplot(data=df, x='cat_col', y='num_col', kind='box', col='panel_col')
```

## Seaborn: Regression & Matrix Plots
```python
sns.lmplot(data=df, x='x', y='y', hue='cat', ci=95, scatter_kws={'alpha': 0.5})
sns.regplot(data=df, x='x', y='y', ci=None, order=2)  # Polynomial fit

sns.heatmap(corr, annot=True, fmt='.2f', cmap='coolwarm', center=0,
            square=True, linewidths=0.5, cbar_kws={'label': 'Correlation'})
sns.clustermap(corr, annot=True, fmt='.2f', cmap='coolwarm')  # With dendrogram
```

## Seaborn: Pairwise Plots
```python
sns.pairplot(data=df, hue='species', diag_kind='kde', palette='Set2',
             corner=True)  # Upper triangle only
sns.PairGrid(data=df, hue='species')  # More control, map methods
```

## Common Color Palettes
```python
# Sequential: 'viridis', 'plasma', 'inferno', 'magma', 'Blues', 'Greens'
# Diverging: 'coolwarm', 'RdBu', 'PiYG', 'PRGn'
# Qualitative: 'Set1','Set2','Set3','Pastel1','Pastel2','tab10','colorblind'
# Seaborn: 'deep', 'muted', 'bright', 'pastel', 'dark', 'colorblind'
```

## Axis Tweaks
```python
plt.xticks(rotation=45, ha='right')
plt.tick_params(labelsize=10)
ax.spines['top'].set_visible(False)    # Remove top spine
ax.spines['right'].set_visible(False)  # Remove right spine
```

## Figure Saving Tips
- Always use `bbox_inches='tight'` to prevent clipping
- PNG for web, PDF for documents, SVG for vector editing
- Set `dpi=300` for high-resolution output
- Use `figsize` early (when creating figure) for proper proportions
