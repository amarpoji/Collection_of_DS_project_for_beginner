# Mini Project: Feature Extraction from a Relational Database

## Objective

Design and populate a relational database simulating an e-commerce platform, then use SQL queries to extract features for a machine learning model that predicts customer churn.

## Dataset Schema

Create a SQLite database with the following tables:

### customers
| Column | Type | Description |
|--------|------|-------------|
| customer_id | INTEGER PRIMARY KEY | Unique ID |
| name | TEXT | Customer name |
| signup_date | DATE | Account creation date |
| city | TEXT | Customer city |
| age | INTEGER | Customer age |
| gender | TEXT | Gender |

### orders
| Column | Type | Description |
|--------|------|-------------|
| order_id | INTEGER PRIMARY KEY | Unique ID |
| customer_id | INTEGER FK | Customer who placed order |
| order_date | DATE | Order timestamp |
| total_amount | REAL | Order total |
| num_items | INTEGER | Number of items in order |
| category | TEXT | Main product category |

### support_tickets
| Column | Type | Description |
|--------|------|-------------|
| ticket_id | INTEGER PRIMARY KEY | Unique ID |
| customer_id | INTEGER FK | Customer |
| created_at | DATETIME | Ticket timestamp |
| status | TEXT | 'open', 'closed', 'resolved' |
| priority | TEXT | 'low', 'medium', 'high', 'urgent' |
| resolution_time_hours | REAL | Hours to resolve |

### churn_labels
| Column | Type | Description |
|--------|------|-------------|
| customer_id | INTEGER PRIMARY KEY | Customer ID |
| churned | INTEGER | 1 if churned, 0 if active |
| churn_date | DATE | When churned (NULL if active) |

## Requirements

### Part 1: Database Creation & Population (20%)
1. Write Python code using sqlite3 to create all tables with proper constraints and foreign keys
2. Generate and insert synthetic data:
   - 500 customers
   - 5000 orders (spanning 2 years)
   - 800 support tickets
   - Churn labels (approximately 20% churn rate)
3. Use parameterized queries for all inserts

### Part 2: Feature Extraction Queries (40%)

Write SQL queries to extract the following features for each customer:

**Demographic Features:**
- age, gender, city
- days_since_signup (as of '2025-01-01')

**Behavioral Features (from orders table):**
- total_orders (count)
- total_spent (SUM of total_amount)
- avg_order_value
- days_since_last_order
- order_frequency (orders per month since signup)
- favorite_category (most ordered category)
- num_distinct_categories
- avg_items_per_order

**Support Features (from support_tickets table):**
- total_tickets
- avg_resolution_time
- num_high_priority_tickets
- num_urgent_tickets
- has_open_ticket (boolean)

**Time-Based Features:**
- orders_last_30_days
- orders_last_90_days
- spent_last_30_days
- spent_last_90_days

### Part 3: ML-Ready Dataset Creation (25%)
1. Combine all features into a single query using CTEs
2. Join with churn_labels to include the target variable
3. Export the result to a pandas DataFrame using `pd.read_sql()`
4. Save as `churn_features.csv`
5. Handle NULLs appropriately (COALESCE to 0 for counts, use sensible defaults)

### Part 4: Validation & Analysis (15%)
1. Print shape of the feature matrix
2. Show distribution of churn label
3. Display 5 sample rows
4. Check for missing values
5. Compare features between churned and active customers using pandas

## Deliverables

1. `churn_feature_extraction.ipynb` — Complete notebook
2. `churn_features.csv` — Final feature matrix

## Evaluation Criteria

- Database schema enforces referential integrity (foreign keys, NOT NULL where appropriate)
- Synthetic data is realistic and varied
- Feature extraction queries are correct and well-structured
- CTEs used for multi-step feature construction
- Final dataset is clean, complete, and ML-ready
- Documentation explains the feature engineering decisions

## Stretch Goals

- Create a VIEW for the feature matrix
- Add a recursive CTE to build customer tenure in months
- Use RANK() to find top 10 customers by total spend
- Create a trigger that logs when customers are updated
- Build a simple churn prediction model using the extracted features
