# Project 1: E-commerce Sales Analysis

## Scenario

You are a junior data analyst at an e-commerce company. The sales director has asked you to prepare a comprehensive analysis of sales performance. Your job is to extract insights from the company's transactional data — orders, customers, products, and order items — to understand revenue trends, customer behavior, and product performance.

This project is **beginner-friendly** and covers fundamental SQL concepts: JOINs, GROUP BY, aggregation, subqueries, and basic window functions.

## Datasets Used

| Table | Rows | Description |
|-------|------|-------------|
| `customers` | 20 | Customer profiles (name, email, city, state, registration date) |
| `orders` | 50 | Transaction records (date, status, total amount, payment method) |
| `order_items` | 88 | Line items per order (product, quantity, unit price) |
| `products` | 20 | Product catalog (name, category, unit price, stock) |

## Prerequisites

- Basic understanding of SQL SELECT statements
- Familiarity with WHERE, JOIN, GROUP BY, ORDER BY
- Access to the database file: `sql_mastery.db`
- SQLite (or any SQL database engine)

## Step-by-Step Tasks

---

### Task 1: List All Orders with Customer Names

**Objective:** Create a complete order ledger showing each order with the customer's full name.

**Hint:** Use `INNER JOIN` to combine the `orders` and `customers` tables on `customer_id`.

**Query:**
```sql
SELECT
  o.order_id,
  c.first_name || ' ' || c.last_name AS customer_name,
  o.order_date,
  o.status,
  o.total_amount,
  o.payment_method,
  o.shipping_city,
  o.shipping_state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;
```

**Expected Output (first 5 rows):**

| order_id | customer_name | order_date | status | total_amount | payment_method | shipping_city | shipping_state |
|----------|---------------|------------|--------|-------------|----------------|---------------|----------------|
| 1001 | Sarah Johnson | 2024-01-05 | Delivered | 125.99 | Credit Card | New York | NY |
| 1002 | Mike Chen | 2024-01-07 | Delivered | 89.50 | PayPal | San Francisco | CA |
| 1003 | Emma Davis | 2024-01-10 | Delivered | 249.99 | Debit Card | Chicago | IL |
| 1004 | Alex Kumar | 2024-01-12 | Shipped | 45.00 | Credit Card | Austin | TX |
| 1005 | Olivia Martinez | 2024-01-15 | Delivered | 310.25 | PayPal | Los Angeles | CA |

---

### Task 2: Total Sales Amount and Order Count by Status

**Objective:** Summarize sales metrics grouped by order status to understand the fulfillment pipeline.

**Hint:** Use `GROUP BY status` with `COUNT(*)` and `SUM(total_amount)`.

**Query:**
```sql
SELECT
  status,
  COUNT(*) AS order_count,
  ROUND(SUM(total_amount), 2) AS total_sales
FROM orders
GROUP BY status
ORDER BY total_sales DESC;
```

**Expected Output:**

| status | order_count | total_sales |
|--------|-------------|-------------|
| Delivered | 32 | 6599.19 |
| Shipped | 9 | 1758.50 |
| Pending | 5 | 990.48 |
| Cancelled | 4 | 220.49 |

**Business Insight:** 64% of orders are delivered. Cancelled orders account for only 2.3% of total revenue, suggesting good order accuracy.

---

### Task 3: Top 5 Customers by Total Spend

**Objective:** Identify the highest-value customers who contribute the most revenue.

**Hint:** Join `customers` → `orders`, `GROUP BY` customer, `ORDER BY` total spend descending, `LIMIT 5`.

**Query:**
```sql
SELECT
  c.customer_id,
  c.first_name || ' ' || c.last_name AS customer_name,
  c.city,
  c.state,
  COUNT(o.order_id) AS order_count,
  ROUND(SUM(o.total_amount), 2) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_spend DESC
LIMIT 5;
```

**Expected Output:**

| customer_id | customer_name | city | state | order_count | total_spend |
|-------------|---------------|------|-------|-------------|-------------|
| 14 | Benjamin Thomas | Dallas | TX | 3 | 1190.00 |
| 3 | Emma Davis | Chicago | IL | 3 | 894.99 |
| 11 | Isabella Lee | Houston | TX | 3 | 805.50 |
| 5 | Olivia Martinez | Los Angeles | CA | 3 | 729.75 |
| 1 | Sarah Johnson | New York | NY | 4 | 691.47 |

**Business Insight:** The top 5 customers contribute approximately 42% of total revenue. Benjamin Thomas from Dallas is the highest spender at $1,190.

---

### Task 4: Calculate Average Order Value (AOV)

**Objective:** Determine the average monetary value of each order placed.

**Hint:** Simple `AVG()` aggregation on the `total_amount` column.

**Query:**
```sql
SELECT
  ROUND(AVG(total_amount), 2) AS avg_order_value,
  ROUND(SUM(total_amount), 2) AS total_revenue,
  COUNT(*) AS total_orders
FROM orders;
```

**Expected Output:**

| avg_order_value | total_revenue | total_orders |
|-----------------|---------------|--------------|
| 191.37 | 9568.66 | 50 |

**Business Insight:** The average order value is $191.37. This is a key KPI for tracking pricing strategy and upselling effectiveness.

---

### Task 5: Monthly Revenue Trend

**Objective:** Show how revenue and order volume evolved month-over-month across the 2024 data.

**Hint:** Use `strftime('%Y-%m', order_date)` to extract the year-month for grouping.

**Query:**
```sql
SELECT
  strftime('%Y-%m', order_date) AS month,
  COUNT(*) AS order_count,
  ROUND(SUM(total_amount), 2) AS revenue
FROM orders
GROUP BY month
ORDER BY month;
```

**Expected Output:**

| month | order_count | revenue |
|-------|-------------|---------|
| 2024-01 | 10 | 1641.97 |
| 2024-02 | 12 | 2265.72 |
| 2024-03 | 11 | 2031.24 |
| 2024-04 | 12 | 2517.23 |
| 2024-05 | 5 | 1112.50 |

**Business Insight:** Revenue peaked in April 2024 at $2,517.23. May is incomplete (only 5 orders), but the trend shows consistent monthly revenue between $1,600 and $2,500.

---

### Task 6: Find Bestselling Products by Quantity

**Objective:** Identify which products sell the most units, combining `order_items` with `products`.

**Hint:** Join `order_items` → `products`, sum quantity, group by product.

**Query:**
```sql
SELECT
  p.product_name,
  p.category,
  p.unit_price,
  SUM(oi.quantity) AS total_units_sold,
  ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_units_sold DESC
LIMIT 10;
```

**Expected Output:**

| product_name | category | unit_price | total_units_sold | total_revenue |
|--------------|----------|------------|-----------------|---------------|
| Cable Organizer | Accessories | 9.99 | 47 | 469.53 |
| Notebook Set | Accessories | 12.50 | 36 | 450.00 |
| Wireless Mouse | Electronics | 25.99 | 15 | 388.86 |
| Standing Desk | Furniture | 599.00 | 13 | 4803.75 |
| Water Bottle | Accessories | 19.99 | 13 | 259.87 |
| Noise Canceling Headphones | Electronics | 199.99 | 7 | 1270.74 |
| Coffee Mug | Accessories | 14.99 | 5 | 74.95 |
| Mechanical Keyboard | Electronics | 89.99 | 4 | 358.49 |
| 27-inch Monitor | Electronics | 349.99 | 4 | 960.49 |
| Webcam HD | Electronics | 79.99 | 4 | 242.97 |

**Business Insight:** Accessories dominate by volume (Cable Organizer, Notebook Set), but Furniture generates the most revenue despite fewer units sold (Standing Desk at $4,803.75).

---

### Task 7: Identify Repeat Customers vs One-Time Buyers

**Objective:** Classify customers based on how many orders they've placed to understand loyalty.

**Hint:** Use a subquery to count orders per customer, then classify with `CASE`.

**Query:**
```sql
WITH customer_order_counts AS (
  SELECT
    customer_id,
    COUNT(*) AS order_count
  FROM orders
  GROUP BY customer_id
)
SELECT
  CASE
    WHEN order_count >= 3 THEN 'VIP (3+ Orders)'
    WHEN order_count = 2 THEN 'Repeat Customer'
    ELSE 'One-Time Buyer'
  END AS customer_type,
  COUNT(*) AS customer_count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 1) AS percentage
FROM customer_order_counts
GROUP BY customer_type
ORDER BY customer_count DESC;
```

**Expected Output:**

| customer_type | customer_count | percentage |
|---------------|----------------|------------|
| Repeat Customer (2 Orders) | 11 | 55.0% |
| VIP (3+ Orders) | 9 | 45.0% |

**Business Insight:** All 20 customers have placed more than 1 order — there are no one-time buyers. 45% of customers are VIPs with 3+ orders, indicating strong customer retention.

---

## Bonus Challenge

**Question:** Which customers have the highest average order value, and what products do they typically buy?

```sql
SELECT
  c.first_name || ' ' || c.last_name AS customer_name,
  COUNT(o.order_id) AS orders,
  ROUND(AVG(o.total_amount), 2) AS avg_order_value,
  ROUND(SUM(o.total_amount), 2) AS total_spend,
  GROUP_CONCAT(DISTINCT p.category) AS categories_purchased
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY avg_order_value DESC
LIMIT 5;
```

## Learning Outcomes

- Writing `JOIN` queries across 3+ tables
- Using `GROUP BY` with aggregate functions (`SUM`, `COUNT`, `AVG`)
- Creating computed columns with `CASE` expressions
- Using Common Table Expressions (CTEs) with `WITH`
- Extracting date components with `strftime`
- Ordering and limiting results for top-N analysis
