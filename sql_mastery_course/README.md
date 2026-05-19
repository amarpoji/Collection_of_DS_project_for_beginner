# 🗄️ SQL Mastery Course

### From Beginner → Job-Ready Data Professional

A complete, project-based SQL learning workspace covering beginner, intermediate, and advanced topics for **data science, analytics, and machine learning workflows**.

---

## 📚 What You'll Learn

| Level | Topics |
|-------|--------|
| **Beginner** | SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, Aliases, Filters, Aggregates, GROUP BY, HAVING |
| **Intermediate** | JOINs (INNER/LEFT/RIGHT/FULL), Subqueries, CASE WHEN, String/Date functions, NULL handling, Views, CTEs, Window Functions |
| **Advanced** | Advanced Windows, Query Optimization, Indexing, Transactions, Stored Procedures, DB Design, Normalization, Analytical SQL |

---

## 📁 Course Structure

```
sql_mastery_course/
│
├── 01_beginner/                     # Beginner lessons (01-08)
│   ├── 01_what_is_sql.md           # What is SQL? Databases & Tables
│   ├── 02_select_where.md          # SELECT & WHERE clause
│   ├── 03_order_by_limit_distinct.md # Sorting & pagination
│   ├── 04_aliases_filtering.md     # Aliases & advanced filtering
│   ├── 05_aggregate_functions.md   # COUNT, SUM, AVG, MIN, MAX
│   ├── 06_group_by.md             # GROUP BY basics
│   ├── 07_having.md               # Filtering groups
│   ├── 08_beginner_review.md      # Comprehensive review
│   └── exercises/                  # Lesson exercises (same as files)
│
├── 02_intermediate/                 # Intermediate lessons (09-16)
│   ├── 09_joins.md                 # INNER, LEFT, RIGHT, FULL JOINs
│   ├── 10_subqueries.md           # Subqueries in WHERE/FROM/SELECT
│   ├── 11_case_when.md            # Conditional logic
│   ├── 12_string_functions.md     # String manipulation
│   ├── 13_date_functions.md       # Date/time operations
│   ├── 14_null_handling_views.md  # NULL handling & Views
│   ├── 15_ctes.md                 # CTE (Common Table Expressions)
│   └── 16_window_functions_basics.md # ROW_NUMBER, RANK, LAG/LEAD
│
├── 03_advanced/                     # Advanced lessons (17-24)
│   ├── 17_advanced_window_functions.md # Advanced window function patterns
│   ├── 18_query_optimization.md   # EXPLAIN QUERY PLAN, optimization
│   ├── 19_indexing.md             # Index types, strategy
│   ├── 20_transactions.md         # ACID, BEGIN/COMMIT/ROLLBACK
│   ├── 21_stored_procedures.md    # SQLite procedures & triggers
│   ├── 22_database_design.md      # Schema design principles
│   ├── 23_normalization.md        # 1NF, 2NF, 3NF, BCNF
│   └── 24_analytical_sql.md       # Business intelligence queries
│
├── datasets/                        # All CSV data + setup scripts
│   ├── customers.csv               # 20 customers
│   ├── orders.csv                  # 50 orders
│   ├── order_items.csv             # 88 order line items
│   ├── products.csv                # 20 products
│   ├── employees.csv               # 15 employees
│   ├── departments.csv             # 6 departments
│   ├── movies.csv                  # 40 movies
│   ├── airbnb_listings.csv         # 20 Airbnb listings
│   ├── setup.sql                   # SQLite schema creation
│   └── import_data.sql             # CSV import script
│
├── exercises/                       # 60+ practice exercises
│   ├── beginner_exercises.md       # 25 beginner exercises
│   ├── intermediate_exercises.md   # 15+ intermediate exercises
│   └── advanced_exercises.md       # 25 advanced exercises
│
├── projects/                        # 5 Projects + 1 Capstone
│   ├── project_01_ecommerce.md     # E-commerce Sales Analysis
│   ├── project_02_employees.md     # Employee Analytics
│   ├── project_03_movies.md        # Movie Insights
│   ├── project_04_airbnb.md        # Airbnb Market Analysis
│   ├── project_05_customers.md     # Customer 360° Analysis
│   └── capstone_dashboard.md       # Executive Business Dashboard 🏆
│
├── solutions/                       # Complete answer keys
│   ├── beginner_solutions.md       # All beginner exercise answers
│   ├── intermediate_solutions.md   # All intermediate exercise answers
│   ├── advanced_solutions.md       # All advanced exercise answers
│   └── project_solutions.md        # All project + capstone answers
│
├── sql_mastery.db                  # 📀 SQLite database (all data)
└── README.md                       # This file
```

---

## 🚀 Quick Start

### Prerequisites
- **Python 3.x** — for Jupyter notebooks (`pip install notebook`)
- **SQLite** — comes built-in with Python (`import sqlite3`)
- Optional: install `sqlite3` CLI for terminal queries

### 1. Open the Database

**Option A — SQLite CLI** (if installed):
```bash
sqlite3 sql_mastery.db
```

**Option B — Python (no install needed)**:
```python
import sqlite3
conn = sqlite3.connect('sql_mastery.db')
cursor = conn.cursor()
cursor.execute("SELECT * FROM employees LIMIT 5;")
print(cursor.fetchall())
```

**Option C — VS Code SQLite Extension**:
1. Install "SQLite" extension by alexcvzz
2. Press `Ctrl+Shift+P`, run "SQLite: Open Database"
3. Select `sql_mastery.db`
4. Run queries via `Ctrl+Shift+Q`

**Option D — DBeaver** (recommended):
1. Download DBeaver (free)
2. Create SQLite connection → select `sql_mastery.db`
3. Browse tables, run queries visually

### 2. Explore the Database

```sql
-- See all tables
.tables

-- See table schema
.schema employees

-- Sample data
SELECT * FROM customers LIMIT 5;

-- Row count per table
SELECT 'employees' AS table_name, COUNT(*) AS rows FROM employees
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;
```

### 3. Start Learning

1. **Beginner path:** Start with `01_beginner/01_what_is_sql.md` → work through lesson 08
2. **Practice:** After each lesson, open the corresponding `.sql` file and run the queries
3. **Exercises:** After each level, do the exercises in `exercises/` folder
4. **Check answers:** Compare with `solutions/`
5. **Projects:** Apply everything with real projects
6. **Capstone:** Prove your skills with the executive dashboard

---

## 💻 How to Run SQL Queries

### Running a SQL file
```bash
# Run a lesson's SQL against the database
sqlite3 sql_mastery.db < 01_beginner/01_what_is_sql.sql
```

### Interactive SQLite session
```bash
sqlite3 sql_mastery.db
sqlite> .headers on      # Show column names
sqlite> .mode column     # Aligned column output
sqlite> SELECT * FROM employees LIMIT 3;
```

### Jupyter Notebooks
```bash
# Install Jupyter
pip install notebook

# Launch
jupyter notebook

# Navigate to the course folder and open a notebook
```

---

## 📊 Datasets Reference

### Entity-Relationship Diagram (Text)

```
┌──────────────┐     ┌──────────────┐     ┌──────────────────┐
│  customers   │     │    orders    │     │   order_items    │
├──────────────┤     ├──────────────┤     ├──────────────────┤
│ customer_id* │────→│ customer_id  │     │ order_items_id*  │
│ first_name   │     │ order_id*    │────→│ order_id         │
│ last_name    │     │ order_date   │     │ product_id ─────→┐
│ email        │     │ status       │     │ quantity         │
│ age          │     │ total_amount │     │ unit_price       │
│ city         │     │ payment_meth │     └──────────────────┘
│ state        │     └──────────────┘                        │
└──────────────┘                                            │
                                                             │
┌──────────────┐     ┌──────────────┐                        │
│  employees   │     │ departments  │     ┌──────────────────┐│
├──────────────┤     ├──────────────┤     │    products      ││
│ employee_id* │────→│department_id │     ├──────────────────┤│
│ first_name   │     │department_nam│     │ product_id*      │←┘
│ last_name    │     │ location     │     │ product_name     │
│ salary       │     │ budget       │     │ category         │
│ department_id│←────┘              │     │ unit_price       │
│ manager_id──→│(self-ref)          │     │ stock_quantity   │
└──────────────┘                    │     └──────────────────┘
                                    │
┌──────────────┐     ┌──────────────┘
│    movies    │     │ airbnb_listings
├──────────────┤     ├──────────────────
│ movie_id*    │     │ property_id*
│ title        │     │ property_name
│ genre        │     │ neighbourhood
│ release_year │     │ room_type
│ rating       │     │ price
│ director     │     │ nights_booked
│ studio       │     │ rating
│ budget       │     │ superhost
│ revenue      │     └──────────────────
└──────────────┘
```
(* = Primary Key, → = Foreign Key)

### Table Details

| Table | Rows | Description |
|-------|------|-------------|
| `customers` | 20 | E-commerce customers with demographics |
| `orders` | 50 | Customer orders (status: Pending/Shipped/Delivered/Cancelled) |
| `order_items` | 88 | Individual products per order |
| `products` | 20 | Product catalog in Electronics/Furniture/Accessories |
| `employees` | 15 | Company employees with salaries and managers |
| `departments` | 6 | Company departments with budgets |
| `movies` | 40 | Films with ratings, budget, revenue |
| `airbnb_listings` | 20 | NYC-style Airbnb properties |

---

## 🎯 Exercises Overview

| Set | Count | Difficulty | Skills Tested |
|-----|-------|------------|--------------|
| `beginner_exercises.md` | 25 | 🟢 Easy | SELECT, WHERE, GROUP BY, HAVING |
| `intermediate_exercises.md` | 15 | 🟡 Medium | JOINs, Subqueries, CTEs, CASE |
| `advanced_exercises.md` | 25 | 🔴 Hard | Windows, Optimization, Analytical SQL |

**Total: 65+ exercises + 5 projects + 1 capstone = 70+ practice items**

---

## 🏗️ Projects Path

1. **E-commerce Analysis** 🛒 — Revenue, customer value, product performance
2. **Employee Analytics** 👥 — Salary analysis, departmental performance
3. **Movie Insights** 🎬 — ROI analysis, genre trends, director performance
4. **Airbnb Market** 🏠 — Pricing, occupancy, superhost analysis
5. **Customer 360°** 👤 — CLV, RFM segmentation, churn analysis
6. **Capstone: Executive Dashboard** 🏆 — Full business review (all skills)

---

## 💡 Learning Tips

1. **Run every query** — Don't just read. Type or copy each query and run it.
2. **Modify and experiment** — After a lesson query, change columns, add filters, sort differently.
3. **Break queries on purpose** — See what error messages look like. This builds debugging skills.
4. **Use the `.sql` files** — Each lesson has a companion SQL file with all examples ready to run.
5. **Pace yourself** — 1-2 lessons per day is better than cramming all 24.
6. **Do exercises before checking solutions** — Struggle first, then learn from the answer.
7. **Projects are the real test** — If you can complete the capstone, you're job-ready.
8. **Use EXPLAIN QUERY PLAN** — Once you reach intermediate, learn to think about performance.

---

## 📖 Estimated Timeline

| Phase | Duration | Outcome |
|-------|----------|---------|
| Beginner (Lessons 1-8) | 1 week | Write basic queries confidently |
| Intermediate (Lessons 9-16) | 1-2 weeks | Join tables, use subqueries, write CTEs |
| Advanced (Lessons 17-24) | 1-2 weeks | Optimize queries, design databases |
| Projects (1-5) | 1-2 weeks | Apply skills to real scenarios |
| Capstone | 2-3 days | Prove job readiness |

**Total: ~4-6 weeks to go from zero to job-ready SQL.**

---

## 🚀 Next Steps After This Course

Once you complete the capstone, you're ready for:

- **LeetCode SQL Hard problems** — Practice interview questions
- **Mode Analytics SQL Tutorial** — Free advanced tutorials
- **StrataScratch** — Real interview questions from tech companies
- **HackerRank SQL** — Certification paths
- **Apply for roles:** Data Analyst, Business Intelligence Analyst, Data Scientist (entry), Analytics Engineer

---

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| `sqlite3: command not found` | Use Python's `sqlite3` module instead |
| `no such table` | Make sure you're in the course root directory |
| `.import` fails | Already imported — just use `sql_mastery.db` |
| Query runs forever | Add `LIMIT` or check for missing `ON` clause in JOIN |
| Wrong results | Check for NULL values with `IS NULL` not `= NULL` |

---

**Happy querying! 🎉**
