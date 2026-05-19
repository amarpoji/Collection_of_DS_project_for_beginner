# Lesson 18: Query Optimization

Writing correct SQL is step one. Writing **fast** SQL is what separates beginners from professionals. This lesson covers how SQLite executes queries and how to optimize them.

## 1. EXPLAIN QUERY PLAN

SQLite's `EXPLAIN QUERY PLAN` shows how a query will be executed. The output has four columns: (id, parent, notused, detail).

```sql
EXPLAIN QUERY PLAN SELECT * FROM employees;
-- (2, 0, 0, 'SCAN employees')
```

### Key Operations

| Operation | Meaning | Cost |
|-----------|---------|------|
| `SCAN table` | Full table scan — reads every row | HIGH |
| `SEARCH table USING INDEX` | Index lookup — reads only matching rows | LOW |
| `USE TEMP B-TREE FOR ORDER BY` | Needs to sort results | MEDIUM |
| `CORRELATED SCALAR SUBQUERY` | Runs subquery per outer row | HIGH |

## 2. Identifying Full Table Scans

```sql
-- ❌ Bad: no index on salary column
EXPLAIN QUERY PLAN SELECT * FROM employees WHERE salary > 100000;
-- (2, 0, 0, 'SCAN employees')

-- ✅ Good: has index on department_id
EXPLAIN QUERY PLAN SELECT * FROM employees WHERE department_id = 1;
-- (3, 0, 0, 'SEARCH employees USING INDEX idx_employees_department (department_id=?)')
```

## 3. Avoiding N+1 Query Problems

The N+1 problem happens when application code executes one query to get parent rows, then one query per child:

```python
# ❌ BAD: N+1 pattern
employees = db.execute("SELECT * FROM employees")  # 1 query
for emp in employees:
    dept = db.execute("SELECT * FROM departments WHERE id = ?", [emp.dept_id])  # N queries!
```

**Fix:** Use a JOIN to get everything in one query.

```sql
-- ✅ GOOD: single query
SELECT e.*, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
```

## 4. EXISTS vs IN vs JOIN

Three ways to find employees in high-budget departments (budget > $500K):

### IN (subquery evaluated first)

```sql
EXPLAIN QUERY PLAN
SELECT e.* FROM employees e
WHERE e.department_id IN (
    SELECT department_id FROM departments WHERE budget > 500000
);
-- (3, 0, 0, 'SEARCH e USING INDEX idx_employees_department (department_id=?)')
-- Efficient: uses index on department_id
```

### EXISTS (correlated subquery)

```sql
EXPLAIN QUERY PLAN
SELECT e.* FROM employees e
WHERE EXISTS (
    SELECT 1 FROM departments d
    WHERE d.department_id = e.department_id AND d.budget > 500000
);
-- (2, 0, 0, 'SCAN e')
-- For each employee, runs the subquery
```

### JOIN with DISTINCT

```sql
EXPLAIN QUERY PLAN
SELECT DISTINCT e.* FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.budget > 500000;
-- (5, 0, 0, 'SCAN e USING INDEX idx_employees_department')
-- Also efficient, uses index scan
```

**Rule of thumb:** For large datasets with indexes, `IN` and `JOIN` typically outperform `EXISTS`.

## 5. Avoid SELECT *

```sql
-- ❌ Returns ALL columns even if you only need 3
SELECT * FROM orders WHERE customer_id = 5;

-- ✅ Only transfers needed data
SELECT order_id, order_date, total_amount FROM orders WHERE customer_id = 5;
```

Benefits: less I/O, less memory, less network transfer, can use covering indexes.

## 6. Optimizing JOIN Order

SQLite's query planner usually picks the optimal join order, but you can help it:
- Put the smaller result set first (outer table)
- Filter early with WHERE clauses
- Ensure join columns are indexed

---

## Exercises

1. **Query Plan Analysis**: Run `EXPLAIN QUERY PLAN` on `SELECT * FROM products WHERE unit_price > 50`. What type of scan does it use?

2. **Optimize a Slow Query**: The following query does a full table scan. Create an index to fix it:
   ```sql
   SELECT * FROM employees WHERE salary > 100000;
   ```

3. **EXISTS vs IN Rewrite**: Rewrite this EXISTS query using IN and compare the query plan:
   ```sql
   SELECT * FROM order_items oi
   WHERE EXISTS (SELECT 1 FROM products p WHERE p.product_id = oi.product_id AND p.category = 'Electronics');
   ```

4. **N+1 Avoidance**: Given this Python-like pseudo-code pattern, write the single SQL query that replaces it:
   ```
   for each department:
       get all employees in that department
   ```

5. **Column Selection**: Write an optimized version of `SELECT * FROM employees` that only retrieves the columns needed for a name badge (employee_id, first_name, last_name, job_title, department_name via JOIN).

---

🔥 **Challenge**: Find all employees who earn more than the average salary of their department. Write the query two ways (correlated subquery vs window function) and compare their EXPLAIN QUERY PLAN outputs. Which is more efficient and why?
