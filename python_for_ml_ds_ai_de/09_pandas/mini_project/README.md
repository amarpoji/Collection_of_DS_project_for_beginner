# Mini Project: Titanic EDA & Data Preparation for ML

## Objective

Perform a complete exploratory data analysis (EDA) and data preparation pipeline on the Titanic dataset, producing a clean dataset ready for machine learning modeling.

## Dataset

The Titanic dataset is one of the most famous datasets in data science. It contains passenger information from the RMS Titanic, including survival outcomes.

**Source:** `https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv`

**Columns:**
- `PassengerId` — Unique passenger ID
- `Survived` — Survival (0 = No, 1 = Yes)
- `Pclass` — Passenger class (1, 2, 3)
- `Name` — Passenger name
- `Sex` — Gender
- `Age` — Age in years
- `SibSp` — Number of siblings/spouses aboard
- `Parch` — Number of parents/children aboard
- `Ticket` — Ticket number
- `Fare` — Fare paid
- `Cabin` — Cabin number
- `Embarked` — Port of embarkation (C = Cherbourg, Q = Queenstown, S = Southampton)

## Requirements

Implement the following steps in a Jupyter notebook:

### Part 1: Data Loading & Inspection (15%)
1. Load the dataset from URL
2. Display basic info (`.info()`, `.describe()`, `.shape`)
3. Identify missing values per column
4. Check data types and memory usage

### Part 2: Data Cleaning (25%)
1. Handle missing Age values (impute with median grouped by Pclass and Sex)
2. Handle missing Embarked values (fill with mode)
3. Create a 'Cabin_Deck' feature from Cabin (extract first letter)
4. Drop the 'Cabin' column after extraction
5. Remove duplicate rows if any

### Part 3: Feature Engineering (25%)
1. Extract 'Title' (Mr, Mrs, Miss, Master, etc.) from Name
2. Group rare titles into 'Rare' category
3. Create 'Family_Size' = SibSp + Parch + 1
4. Create 'Is_Alone' flag (1 if Family_Size == 1)
5. Create 'Age_Group' bins: Child (0-12), Teen (13-19), Adult (20-39), Middle-Aged (40-59), Senior (60+)
6. Create 'Fare_Group' bins based on quartiles

### Part 4: Encoding & Final Preparation (25%)
1. Encode Sex as binary (0/1)
2. Create dummy variables for Embarked, Title, Cabin_Deck
3. Create dummy variables for Age_Group and Fare_Group
4. Drop original categorical columns after encoding
5. Drop PassengerId, Name, Ticket (not useful as features)
6. Ensure all columns are numeric (int or float)
7. Verify no missing values remain

### Part 5: Validation (10%)
1. Display final DataFrame info — confirm 0 non-null counts
2. Show shape — should be (891, ~25-30 features)
3. Display first 5 rows of the clean dataset
4. Export to `titanic_clean.csv`

## Deliverables

1. `titanic_eda_ml_prep.ipynb` — Complete notebook with all parts
2. `titanic_clean.csv` — Final cleaned dataset

## Evaluation Criteria

- All missing values are handled correctly
- Feature engineering adds meaningful new features
- Final dataset has no missing values and all numeric types
- Code is well-commented and follows pandas best practices
- No SettingWithCopyWarning in the output

## Stretch Goals

- Use `pd.merge()` to merge the Titanic data with a custom deck location mapping
- Create a correlation heatmap of numerical features
- Use `pd.ProfileReport` for automated EDA
- Train a simple LogisticRegression on the clean data and report accuracy
