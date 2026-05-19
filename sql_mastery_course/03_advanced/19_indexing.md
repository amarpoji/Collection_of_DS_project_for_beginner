# Lesson 19: Indexing

Indexes are the #1 performance tool in SQL. They're like a book's index — instead of reading every page to find what you need, you look up the topic in the index and jump directly to the right page.

## 1. What is an Index?

An index is a separate data structure (B-tree in SQLite) that stores a sorted copy of selected columns, with pointers to the original rows.

**Without index**: SQLite reads every row (full table scan).
**With index**: SQLite navigates the B-tree to find matching rows in O(log n) time.

```sql
-- Without index
EXPLAIN QUERY PLAN SELECT * FROM employees WHERE salary > 100000;
-- (2, 0, 0, 'SCAN employees')

-- With index (after CREATE INDEX idx_employees_salary ON employees(salary))
-- (3, 0, 0, 'SEARCH employees USING INDEX idx_employees_salary (salary>?)')
```

## 2. Creating Indexes

```sql
CREATE [UNIQUE] INDEX index_name ON table_name (column1, column2, ...);
DROP INDEX IF EXISTS index_name;
```

## 3. Composite (Multi-Column) Indexes

Column order matters! The "leftmost prefix rule" means the index can be used for queries on:
- The first column only
- The first + second columns
- The first + second + third columns

**Best practice**: Put equality conditions first, range conditions second, ORDER BY columns last.

```sql
-- For this query:
SELECT * FROM orders
WHERE status = 'Delivered' AND order_date > '2024-02-01'
ORDER BY total_amount;

-- Best index: (status, order_date, total_amount)
CREATE INDEX idx_orders_opt ON orders(status, order_date, total_amount);
```

## 4. When Indexes HELP

| Operation | How it helps |
|-----------|-------------|
| **WHERE** | Quickly find matching rows |
| **JOIN** | Fast lookups on join keys (always index FKs!) |
| **ORDER BY** | Avoid sorting if index order matches |
| **GROUP BY** | Can scan index in group order |
| **MIN/MAX** | First/last entry in index |

## 5. When Indexes HURT

| Operation | Why it hurts |
|-----------|-------------|
| **INSERT** | Must update every index on the table |
| **UPDATE** (indexed column) | Must update the index |
| **DELETE** | Must remove from every index |
| **Storage** | Each index adds disk and memory usage |

**Rule of thumb**: Index columns used in WHERE, JOIN, and ORDER BY. Don't index columns with low cardinality (e.g., gender with only 2 values).

## 6. Special Index Types

### UNIQUE Index
Enforces that no two rows have the same value(s).

```sql
CREATE UNIQUE INDEX idx_employees_email ON employees(email);
-- INSERT with duplicate email would fail
```

### Partial Index
Only indexes a subset of rows. Smaller and faster for filtered queries.

```sql
-- Only index active orders (Pending or Processing)
CREATE INDEX idx_active_orders ON orders(total_amount)
WHERE status IN ('Pending', 'Processing');
```

## 7. Indexes and NULL Values

SQLite stores NULLs in indexes. Queries with `IS NULL` can use the index.

## 8. Viewing Existing Indexes

```sql
SELECT name, sql FROM sqlite_master
WHERE type='index' AND name NOT LIKE 'sqlite_auto%';
```

---

## Exercises

1. **Create a Unit Price Index**: Create an index on `products.unit_price` and verify it changes the query plan for `SELECT * FROM products WHERE unit_price > 50`.

2. **Composite Index on Order Items**: Create a composite index on `order_items(order_id, product_id)` and test it with a join query.

3. **Unique Email Enforcement**: Create a UNIQUE index on `customers.email` and test what happens when you try to insert a duplicate.

4. **Partial Index for Profitable Movies**: Create a partial index on movies where `revenue_millions > budget_millions * 2` (profitable movies only).

5. **Before/After Analysis**: Drop `idx_orders_customer` and check the query plan for a query filtering by `customer_id`. Then recreate it. Compare the plans.

---

🔥 **Challenge**: Design the optimal index strategy for an e-commerce reporting query that shows monthly revenue by product category for delivered orders in 2024, sorted by revenue descending. Create the index(es) and demonstrate the before/after query plan.
