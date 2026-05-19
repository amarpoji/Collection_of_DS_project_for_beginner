# Lesson 01: What is SQL, Databases & Tables

## What is a Database?

A **database** is an organized collection of data stored electronically. Think of it like a digital filing cabinet where you can store, retrieve, and manage information efficiently.

**Real-world examples:**
- An e-commerce site stores products, customers, and orders in a database
- A hospital stores patient records, appointments, and prescriptions
- A bank stores accounts, transactions, and customer information

## What is SQL?

**SQL** (Structured Query Language) is the standard language for communicating with relational databases. You use SQL to:
- **Query** data (ask questions)
- **Insert** new data
- **Update** existing data
- **Delete** data
- **Create** and modify database structures

SQL is pronounced either as "sequel" or "S-Q-L."

## Relational Databases

A **relational database** organizes data into **tables** that are related to each other through common columns.

### Tables, Rows, and Columns

- **Table**: Like a spreadsheet with a specific theme (e.g., `employees`, `customers`)
- **Row** (Record): One complete entry in a table (e.g., one employee)
- **Column** (Field): One attribute of the data (e.g., `first_name`, `salary`)

```
  employees table
  ┌──────────────┬──────────────┬──────────┬────────┐
  │ employee_id  │ first_name   │ job_title│ salary │  ← Columns
  ├──────────────┼──────────────┼──────────┼────────┤
  │ 1            │ John         │ Analyst  │ 75000  │  ← Row
  │ 2            │ Jane         │ Engineer │ 95000  │  ← Row
  └──────────────┴──────────────┴──────────┴────────┘
```

## SQLite vs MySQL vs PostgreSQL

| Feature | SQLite | MySQL | PostgreSQL |
|---------|--------|-------|------------|
| Type | Embedded | Client-Server | Client-Server |
| Setup | No server needed | Requires installation | Requires installation |
| Use case | Small apps, mobile, learning | Web apps | Enterprise apps |
| Concurrency | Limited | Good | Excellent |
| File-based | Yes (single .db file) | No | No |

This course uses **SQLite** — perfect for learning because it requires zero setup!

## Common Data Types in SQLite

| Type | Description | Example |
|------|-------------|---------|
| INTEGER | Whole numbers | 42, -5, 75000 |
| REAL | Decimal numbers | 99.99, 3.14 |
| TEXT | String of characters | 'John', 'New York' |
| NULL | Missing or unknown value | (no data) |

## Exploring the Database

Let's explore the `sql_mastery.db` database interactively. We'll use `sqlite3` command-line tool.

### 1. See all tables

```sql
-- List all tables in the database
.tables
```

**Expected output:**
```
airbnb_listings  customers        departments      employees
movies           order_items      orders           products
```

Our database has **8 tables** with real-world data!

### 2. See table structure (schema)

```sql
-- Show the structure of the employees table
.schema employees
```

**Expected output:**
```
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    hire_date TEXT,
    job_title TEXT,
    salary REAL,
    department_id INTEGER,
    manager_id TEXT
);
```

### 3. View column details with PRAGMA

```sql
-- Show detailed column info for a table
PRAGMA table_info(customers);
```

**Expected output:**
```
cid  name               type     notnull  dflt_value  pk
---  -----------------  -------  -------  ----------  --
0    customer_id        INTEGER  0                    0
1    first_name         TEXT     0                    0
2    last_name          TEXT     0                    0
3    email              TEXT     0                    0
4    gender             TEXT     0                    0
5    age                INTEGER  0                    0
6    city               TEXT     0                    0
7    state              TEXT     0                    0
8    registration_date  TEXT     0                    0
9    is_active          INTEGER  0                    0
```

### 4. Count rows in a table

```sql
-- Count how many records are in each table
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM movies;
```

**Expected output:**
```
15  (employees)
20  (customers)
50  (orders)
40  (movies)
```

## Tables in sql_mastery.db

| Table | Rows | Description |
|-------|------|-------------|
| `departments` | 6 | Company departments with budgets |
| `employees` | 15 | Employee details and salaries |
| `customers` | 20 | Customer profiles |
| `products` | 20 | Product catalog with prices |
| `orders` | 50 | Customer orders |
| `order_items` | 88 | Individual items in each order |
| `movies` | 40 | Movie catalog with ratings |
| `airbnb_listings` | 20 | Airbnb property listings |

## Key Terms Summary

- **Database**: Organized collection of data
- **Table**: Collection of related data (like a spreadsheet)
- **Row**: A single record in a table
- **Column**: A specific attribute across all rows
- **Schema**: The structure/definition of a table
- **SQL**: The language to talk to databases
- **SQLite**: A file-based database engine

---

## Hands-On Exercises

### Exercise 1
List all tables in the `sql_mastery.db` database using `.tables`.

### Exercise 2
Use `.schema` to view the structure of the `movies` table. What columns does it have?

### Exercise 3
Run `PRAGMA table_info(orders)` and write down the column names and their data types.

### Exercise 4
Count the number of rows in the `airbnb_listings` table.

### Exercise 5
Use `.schema` to explore all 8 tables. Which table has the most columns?

---

### 🔥 Mini Challenge
Use the sqlite3 dot commands to find:
1. Which table has a column called `rating`?
2. How many columns does the `order_items` table have?
3. What is the data type of the `price` column in `airbnb_listings`?
