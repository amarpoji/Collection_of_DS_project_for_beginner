# Mini Project: Feature Engineering Pipeline for Kaggle

**Module 15 — Feature Engineering**

## Objective

Build a feature engineering pipeline for the Titanic dataset that transforms raw passenger data into high-quality features, then train a model and compare performance against a baseline with minimal features.

## Dataset

**Titanic** (from seaborn)

You will engineer features from:
- Passenger class, sex, age, fare, embarked
- SibSp, Parch → family features
- Name → title extraction
- Cabin → deck letter

## Tasks

### Part 1: Baseline Model (3 hours)

Build a simple baseline:
1. Use only: pclass, sex, age, fare, embarked
2. Simple median imputation for age
3. OneHot encoding for sex and embarked
4. StandardScaler for age and fare
5. Train a Random Forest with default params
6. Report 5-fold CV accuracy

### Part 2: Feature Engineering (8 hours)

Create ALL of the following features:

**Numerical features:**
- FamilySize = SibSp + Parch + 1
- IsAlone = (FamilySize == 1).astype(int)
- FarePerPerson = Fare / FamilySize
- LogFare = log(Fare + 1)

**Categorical features:**
- Title extracted from Name (Mr, Mrs, Miss, Master, Rare)
- Deck letter from Cabin (A, B, C, D, E, F, G, U = Unknown)
- AgeGroup: Child (0-12), Teen (13-19), Adult (20-59), Senior (60+)
- FareBin: quartile-based bins

**Interaction features:**
- Pclass × Sex (interaction)
- Pclass × AgeGroup

**Missing value handling:**
- Impute Age using KNNImputer with pclass, fare, family size
- Impute Embarked with most frequent
- Create AgeMissing indicator
- Create CabinMissing indicator

### Part 3: Encoding Strategy (3 hours)

Compare encoding strategies:
1. OneHot encoding for all categorical features
2. Target encoding for high-cardinality features (Title, Deck)
3. Ordinal encoding for AgeGroup, Pclass
4. Frequency encoding for Embarked

Report which encoding combination gives the best CV score.

### Part 4: Feature Selection (2 hours)

1. Use VarianceThreshold to remove near-constant features
2. Use SelectKBest (f_classif) to rank features
3. Use RFE with Logistic Regression to select top 10 features
4. Compare performance with all features vs selected features

### Part 5: Final Pipeline (2 hours)

Build a complete sklearn Pipeline with ColumnTransformer that:
1. Imputes missing values
2. Scales numerical features
3. Encodes categorical features
4. Selects features
5. Trains a classifier

Use cross-validation to evaluate. Save the pipeline using joblib.

## Deliverables

1. **Jupyter notebook** with complete feature engineering pipeline
2. **Comparison table**: baseline vs engineered features
3. **Visualizations**: feature importance, correlation heatmap, feature distributions
4. **Final pipeline** saved as `titanic_pipeline.joblib`

## Evaluation Criteria

| Criteria | Weight |
|----------|--------|
| Number and quality of engineered features | 30% |
| Correct implementation of scaling/encoding/imputation | 25% |
| Feature selection and comparison | 15% |
| Pipeline construction with ColumnTransformer | 15% |
| Performance improvement over baseline | 15% |

## Resources

- sklearn.compose.ColumnTransformer: https://scikit-learn.org/stable/modules/compose.html
- sklearn.pipeline.Pipeline: https://scikit-learn.org/stable/modules/pipeline.html
- Target encoding guide: https://contrib.scikit-learn.org/category_encoders/

## Stretch Goals

- Implement target encoding with proper cross-validation (no leakage)
- Use category_encoders library for advanced encoding
- Submit to Kaggle Titanic competition (using engineered features)
- Create a feature importance plot comparing baseline vs engineered features
- Use SHAP to explain the final model
