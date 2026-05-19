# Lesson 21: Stored Procedures / Functions (SQLite Approach)

**Note:** SQLite does not have native stored procedures like PostgreSQL or MySQL. This is by design — SQLite is an embedded database, and "stored procedures" are handled in the application layer. This lesson shows three approaches to achieve similar functionality.

## Approach 1: Application-Layer Logic (Python)

The most natural approach in SQLite is to put business logic in your application code. Here's a Python function that acts like a stored procedure:

```python
import sqlite3

def transfer_funds(from_acct, to_acct, amount):
    """Application-layer 'stored procedure' for money transfer."""
    conn = sqlite3.connect('sql_mastery.db')
    try:
        conn.execute('BEGIN TRANSACTION')

        # Check balance
        cursor = conn.execute(
            'SELECT balance FROM accounts WHERE account_id = ?',
            (from_acct,)
        )
        balance = cursor.fetchone()
        if balance is None or balance[0] < amount:
            conn.rollback()
            return False, 'Insufficient funds'

        # Transfer
        conn.execute(
            'UPDATE accounts SET balance = balance - ? WHERE account_id = ?',
            (amount, from_acct)
        )
        conn.execute(
            'UPDATE accounts SET balance = balance + ? WHERE account_id = ?',
            (amount, to_acct)
        )

        conn.commit()
        return True, 'Transfer successful'
    except Exception as e:
        conn.rollback()
        return False, str(e)
    finally:
        conn.close()
```

## Approach 2: SQL Views (Encapsulation)

Views encapsulate complex queries behind a simple name — like a stored procedure that returns a result set.

### Sales Dashboard View
```sql
CREATE VIEW v_sales_dashboard AS
SELECT
    strftime('%Y-%m', o.order_date) AS month,
    p.category,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY month, p.category;
```

Then query it like a table:
```sql
SELECT * FROM v_sales_dashboard WHERE month = '2024-01';
```

### Employee Summary View
```sql
CREATE VIEW v_employee_summary AS
SELECT d.department_name,
       COUNT(*) AS employee_count,
       ROUND(AVG(e.salary), 0) AS avg_salary,
       ROUND(SUM(e.salary), 0) AS total_salary_cost,
       ROUND(AVG(e.salary) / d.budget * 100, 2) AS salary_pct_of_budget
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;
```

## Approach 3: Triggers (Automation)

Triggers automatically execute SQL in response to INSERT, UPDATE, or DELETE operations — similar to automatic stored procedures.

### Log Order Status Changes
```sql
CREATE TABLE order_change_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER,
    old_status TEXT,
    new_status TEXT,
    changed_by TEXT DEFAULT 'system',
    changed_at TEXT DEFAULT (datetime('now'))
);

CREATE TRIGGER trg_order_status_update
AFTER UPDATE OF status ON orders
BEGIN
    INSERT INTO order_change_log (order_id, old_status, new_status, changed_by)
    VALUES (OLD.order_id, OLD.status, NEW.status, 'system');
END;
```

### Prevent Negative Stock (Constraint-style trigger)
```sql
CREATE TRIGGER trg_prevent_negative_stock
BEFORE UPDATE OF stock_quantity ON products
BEGIN
    SELECT CASE
        WHEN NEW.stock_quantity < 0 THEN
            RAISE(ABORT, 'Stock quantity cannot be negative')
    END;
END;
```

### Auto-update Order Total
```sql
CREATE TRIGGER trg_update_order_total
AFTER INSERT ON order_items
BEGIN
    UPDATE orders SET total_amount = (
        SELECT ROUND(SUM(quantity * unit_price), 2)
        FROM order_items WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END;
```

---

## Exercises

1. **High-Value Customers View**: Create a view `v_high_value_customers` showing customers who spent > $500 total.

2. **Salary Change Logger**: Create a trigger that logs when an employee's salary changes (store old and new values).

3. **Low Stock View**: Create a view for products with stock < 10, showing product name, category, and supplier info.

4. **Cascade Delete Protector**: Create a trigger that prevents deleting orders that still have items in `order_items`.

5. **Customer Report Function**: Write the Python wrapper function for "get customer order history report" that takes a customer_id and returns their orders with items.

---

🔥 **Challenge**: Create a complete application-layer order processing system with:
1. A view that shows top customers by revenue
2. A trigger that logs all order status changes
3. A trigger that prevents orders with zero items
4. A Python function `process_order(customer_id, items[])` that creates the order, inserts items, updates stock, and returns the order_id — all in a single transaction with proper error handling
