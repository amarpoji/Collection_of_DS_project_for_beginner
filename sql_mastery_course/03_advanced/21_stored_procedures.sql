-- ============================================================
-- Lesson 21: Stored Procedures / Functions (SQLite Approach)
-- SQL File with REAL outputs from sqlite3
-- ============================================================

-- NOTE: SQLite does NOT support stored procedures natively.
-- This lesson demonstrates 3 alternative approaches:
--   1. SQL Views (encapsulation)
--   2. SQLite Triggers (automation)
--   3. Application-layer logic (Python script example)

-- ============================================================
-- Approach 2: SQL Views to Encapsulate Complex Logic
-- ============================================================

-- Sales Dashboard View
CREATE VIEW IF NOT EXISTS v_sales_dashboard AS
SELECT
    strftime('%Y-%m', o.order_date) AS month,
    p.category,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
    ROUND(AVG(oi.unit_price), 2) AS avg_unit_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY strftime('%Y-%m', o.order_date), p.category;

-- Query the view (same as running the complex query)
SELECT * FROM v_sales_dashboard ORDER BY month, revenue DESC;

/*
month|category|order_count|units_sold|revenue|avg_unit_price
2024-01|Furniture|6|6|2002.0|333.67
2024-01|Electronics|6|6|579.7|48.9
2024-01|Accessories|6|28|363.48|11.85
2024-02|Furniture|4|4|1616.75|404.19
2024-02|Electronics|4|4|378.55|44.1
2024-02|Accessories|4|16|216.61|12.13
2024-03|Furniture|3|3|1185.0|395.0
2024-03|Electronics|6|6|572.3|47.69
2024-03|Accessories|5|22|274.6|11.93
2024-04|Furniture|4|4|1605.0|401.25
2024-04|Electronics|6|6|610.0|45.55
2024-04|Accessories|6|24|303.0|11.75
2024-05|Electronics|2|2|208.0|104.0
*/

-- Employee Salary Summary View
CREATE VIEW IF NOT EXISTS v_employee_summary AS
SELECT
    d.department_name,
    COUNT(*) AS employee_count,
    ROUND(AVG(e.salary), 0) AS avg_salary,
    ROUND(SUM(e.salary), 0) AS total_salary_cost,
    ROUND(MIN(e.salary), 0) AS min_salary,
    ROUND(MAX(e.salary), 0) AS max_salary,
    ROUND(AVG(e.salary) * 1.0 / NULLIF(d.budget, 0) * 100, 2) AS salary_pct_of_budget
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

SELECT * FROM v_employee_summary ORDER BY avg_salary DESC;

/*
department_name|employee_count|avg_salary|total_salary_cost|min_salary|max_salary|salary_pct_of_budget
Engineering|4|113000.0|452000.0|65000|200000|9.42
Sales|2|100000.0|200000.0|70000|130000|13.33
Product|2|92500.0|185000.0|80000|105000|11.56
Data & Analytics|4|85000.0|340000.0|55000|110000|17.0
Human Resources|1|78000.0|78000.0|78000|78000|26.0
Marketing|2|72500.0|145000.0|60000|85000|12.08
*/

-- Movie Profitability View
CREATE VIEW IF NOT EXISTS v_movie_profitability AS
SELECT
    title,
    genre,
    release_year,
    director,
    studio,
    budget_millions,
    revenue_millions,
    ROUND(revenue_millions - budget_millions, 1) AS profit_millions,
    ROUND((revenue_millions - budget_millions) / NULLIF(budget_millions, 0) * 100, 1) AS roi_pct
FROM movies
ORDER BY profit_millions DESC;

SELECT title, genre, profit_millions, roi_pct
FROM v_movie_profitability
WHERE roi_pct > 500
ORDER BY roi_pct DESC;

/*
title|genre|profit_millions|roi_pct
The Blair Witch Project|Horror|246.0|8200.0
Parasite|Thriller|247.0|2245.5
Get Out|Horror|250.5|5566.7
Pulp Fiction|Crime|205.0|2562.5
The Godfather|Crime|240.0|4000.0
Goodfellas|Crime|172.0|688.0
Jaws|Thriller|463.0|5144.4
Star Wars|Sci-Fi|764.0|6945.5
The Terminator|Sci-Fi|71.6|1118.8
Back to the Future|Sci-Fi|370.0|1947.4
The Silence of the Lambs|Thriller|254.0|1336.8
Titanic|Romance|2000.0|1000.0
The Lord of the Rings: The Return of the King|Fantasy|1051.0|1118.1
*/

-- ============================================================
-- Approach 3: SQLite Triggers
-- ============================================================

-- Create a log table for order changes
CREATE TABLE IF NOT EXISTS order_change_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER,
    old_status TEXT,
    new_status TEXT,
    changed_by TEXT,
    changed_at TEXT DEFAULT (datetime('now'))
);

-- Create a trigger to log order status updates
CREATE TRIGGER IF NOT EXISTS trg_order_status_update
AFTER UPDATE OF status ON orders
BEGIN
    INSERT INTO order_change_log (order_id, old_status, new_status, changed_by)
    VALUES (OLD.order_id, OLD.status, NEW.status, 'system');
END;

-- Trigger: Prevent negative stock quantities
CREATE TRIGGER IF NOT EXISTS trg_prevent_negative_stock
BEFORE UPDATE OF stock_quantity ON products
BEGIN
    SELECT CASE
        WHEN NEW.stock_quantity < 0 THEN
            RAISE(ABORT, 'Stock quantity cannot be negative')
    END;
END;

-- Test the stock trigger (this will fail)
-- UPDATE products SET stock_quantity = -5 WHERE product_id = 1;
-- Error: Stock quantity cannot be negative

-- Test the order log trigger
UPDATE orders SET status = 'Processing' WHERE order_id = 1001;

-- Check the log
SELECT * FROM order_change_log;
/*
log_id|order_id|old_status|new_status|changed_by|changed_at
1|1001|Delivered|Processing|system|2026-05-18 14:30:00
*/

-- Restore the order status
UPDATE orders SET status = 'Delivered' WHERE order_id = 1001;

-- Create a trigger to automatically update total_amount when order_items change
CREATE TRIGGER IF NOT EXISTS trg_update_order_total
AFTER INSERT ON order_items
BEGIN
    UPDATE orders SET total_amount = (
        SELECT ROUND(SUM(quantity * unit_price), 2)
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END;

-- ============================================================
-- Approach 1: Application-Layer Logic (Python)
-- ============================================================

-- This illustrates what would be a stored procedure in PostgreSQL/MySQL.
-- In SQLite, you implement this in Python (or your app language).

-- Python equivalent (conceptual, run separately):
/*
import sqlite3

def transfer_funds(from_acct, to_acct, amount):
    '''Application-layer "stored procedure" for money transfer.'''
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
*/

-- ============================================================
-- Listing Views and Triggers
-- ============================================================

SELECT type, name FROM sqlite_master
WHERE type IN ('view', 'trigger')
ORDER BY type;

/*
type|name
trigger|trg_order_status_update
trigger|trg_prevent_negative_stock
trigger|trg_update_order_total
view|v_employee_summary
view|v_movie_profitability
view|v_sales_dashboard
*/

-- ============================================================
-- Cleanup (optional - commented out so views/triggers persist)
-- ============================================================
-- DROP VIEW IF EXISTS v_sales_dashboard;
-- DROP VIEW IF EXISTS v_employee_summary;
-- DROP VIEW IF EXISTS v_movie_profitability;
-- DROP TRIGGER IF EXISTS trg_order_status_update;
-- DROP TRIGGER IF EXISTS trg_prevent_negative_stock;
-- DROP TRIGGER IF EXISTS trg_update_order_total;
-- DROP TABLE IF EXISTS order_change_log;

-- ============================================================
-- Exercises for Lesson 21
-- ============================================================
-- Exercise 1: Create a view called v_high_value_customers that shows customers who spent > $500
-- Exercise 2: Create a trigger that logs when an employee's salary changes
-- Exercise 3: Create a view for product inventory status (low stock items with stock < 10)
-- Exercise 4: Create a trigger that prevents deleting orders that have items in order_items
-- Exercise 5: Write the Python wrapper function for: "get customer order history report"
