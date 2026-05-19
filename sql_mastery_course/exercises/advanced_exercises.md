# Advanced SQL Exercises

Practice exercises covering advanced window functions, query optimization, multi-table analytical queries, business intelligence queries, and database design challenges.

Database: `/mnt/c/Users/USER/Desktop/agentic ai/notebook_ds/sql_mastery_course/sql_mastery.db`

---

## Advanced Window Functions (Lessons 17, 24)

### 1. Revenue Contribution by Category (Percent of Total)
Using SUM() OVER() without a PARTITION BY, calculate each product's revenue as a percentage of total company revenue. Show product_name, category, revenue, pct_of_total. Round to 2 decimal places.

### 2. Customer Order Gap Analysis
For each customer, use LAG() to calculate the number of days between consecutive orders. Show customer_id, order_id, order_date, previous_order_date, and days_gap. Only show gaps greater than 14 days. Order by days_gap DESC.

### 3. Rolling 90th Percentile Threshold
Using NTILE(10) over a sliding window of 20 orders (ROWS BETWEEN 19 PRECEDING AND CURRENT ROW), identify orders in the top 10% of their window. Show order_id, total_amount, and a flag 'High Value' or 'Normal'. Compare against the overall average.

### 4. First Purchase vs Repeat Purchase Metrics
For each customer, use FIRST_VALUE() to get their first order amount, then compare each subsequent order to it. Show customer_id, order_id, order_date, total_amount, first_order_amount, and a column `above_first` that says 'Yes' if the current order exceeds the first order.

### 5. Department Salary Compression Analysis
Calculate the spread between the highest and lowest salary in each department using FIRST_VALUE and LAST_VALUE. Show department_name, lowest_salary, highest_salary, spread, and the ratio of highest-to-lowest. Order by spread DESC.

---

## Query Optimization (Lesson 18)

### 6. EXPLAIN QUERY PLAN: JOIN Strategies
Write three different queries that find all customers who placed orders for 'Standing Desk' (product_id=7):
- One using a subquery with IN
- One using EXISTS
- One using a JOIN
Run EXPLAIN QUERY PLAN on each. Write a brief comment explaining which is most efficient and why.

### 7. Index Analysis
Create an index on orders(order_date, status) if not already present. Then run EXPLAIN QUERY PLAN on this query:
```sql
SELECT order_date, total_amount FROM orders
WHERE order_date >= '2024-03-01' AND status = 'Delivered'
ORDER BY order_date;
```
Now drop the index and run the same EXPLAIN QUERY PLAN. Compare the two plans in a comment.

### 8. Subquery vs CTE Performance
Write the same analytical query using both a subquery approach and a CTE approach:
- Find each department's total salary budget
- Then show each employee with their salary as a percentage of their department's budget
Use EXPLAIN QUERY PLAN on both. Are there any differences? Explain.

### 9. IN vs EXISTS Deep Dive
You have a slow query filtering orders by customers from California:
```sql
SELECT * FROM orders WHERE customer_id IN (
    SELECT customer_id FROM customers WHERE state = 'CA'
);
```
Rewrite this query three ways: (1) IN, (2) EXISTS, (3) JOIN. Run EXPLAIN QUERY PLAN on all three. Which is the most efficient? Why? Write your analysis as SQL comments.

---

## Multi-Table Analytical Queries (Lessons 15-17, 24)

### 10. Monthly Retention Cohort Pivot
Build a cohort retention matrix. For each registration month (cohort), show:
- Total customers in cohort
- Month 0 (first month) active customers
- Month 1 active customers
- Month 2 active customers
- Month 3 active customers
(Hint: Use CASE statements inside COUNT with a conditional on months_since_registration)

### 11. Product Affinity Analysis (Basket Analysis)
Find products that are frequently purchased together. For each pair of products that appear in the same order at least 2 times, show:
- product_1_name, product_2_name
- times_bought_together
- support_pct (orders containing both / total orders)
Use a self-join on order_items. You may need CTEs.

### 12. Employee-Product Cross-Analysis
Find which departments are responsible for the products generating the most revenue. For each department (from employees), show:
- department_name
- The product category they sell the most of (by revenue)
- Total revenue from that category
- How that compares to the next department (use LEAD/LAG)

This is a creative exercise — you'll need to join employees → departments → ???. There's no direct link between employees and products. Join employees → departments, and products → order_items → orders → customers. Then infer department involvement through customer geography or another meaningful relationship.

---

## Business Intelligence Queries (Lesson 24)

### 13. Executive Dashboard: Single-Query Monthly Report
Write a single query (using CTEs and window functions) that produces a monthly executive dashboard with these metrics:
- month
- total_orders (excluding cancelled)
- total_revenue
- cumulative_revenue (running total)
- revenue_growth_pct (month-over-month %)
- avg_order_value
- aov_change_pct (month-over-month AOV %)
- top_category (the product category with highest revenue that month)
- top_category_revenue

Hint: You'll need at least 5 CTEs and several window functions. Use LAG for growth calculations.

### 14. Customer Lifetime Value Prediction (Simple Model)
Predict CLV using this formula:
`predicted_clv = avg_order_value * purchase_frequency * estimated_lifetime_months`

For each customer:
- Calculate their actual avg_order_value and monthly purchase frequency
- Estimate lifetime = 24 months (2 years) for active customers, 1 month for inactive
- Show actual total_revenue, predicted_clv, and the ratio predicted/actual
- Round all monetary values to 2 decimal places

### 15. Anomaly Detection: Unusual Order Amounts
Find orders where the total_amount deviates significantly from the customer's normal behavior. Use:
- Customer's average order value (their personal baseline)
- Customer's standard deviation of order value
- Flag orders where amount > avg + 2 * stdev as 'Anomaly High' or amount < avg - 2 * stdev as 'Anomaly Low'

Note: SQLite doesn't have a built-in STDEV function, so calculate it manually using:
`SQRT(AVG(amount * amount) - AVG(amount) * AVG(amount))`

### 16. Daily Revenue Forecasting (7-Day Moving Average)
Create a daily revenue forecast using a 7-day moving average. Generate:
- date (every day, even those with no orders — use a recursive CTE to generate dates)
- actual_daily_revenue (NULL for future dates or days with no orders)
- forecast (7-day moving average of actual revenue, trailing)
- Only show dates from April 1 to May 31, 2024

---

## Database Design Challenges (Lessons 22-23)

### 17. Design a Subscription Platform Schema
Design a normalized schema for a subscription-based SaaS platform. Requirements:
- Users can subscribe to plans (Free, Pro, Enterprise)
- Subscriptions have start/end dates, auto-renewal flag
- Users can have multiple payment methods
- Invoices are generated monthly per subscription
- Each invoice has line items (usage-based charges)
- Users can have team members with different roles (Admin, Member, Viewer)

Write the CREATE TABLE statements with:
- Appropriate primary keys and foreign keys
- CHECK constraints where sensible
- At least one junction table
- Indexes on commonly queried columns
- A comment explaining which normal form each table satisfies

### 18. Normalize a Denormalized Event Log
You're given this denormalized table from a legacy event tracking system:
```sql
event_log(
    log_id INTEGER PRIMARY KEY,
    event_date TEXT,
    user_id INTEGER,
    user_name TEXT,
    user_email TEXT,
    event_type TEXT,
    event_data TEXT,    -- JSON blob: {"page":"/dashboard","duration_sec":45,"browser":"Chrome"}
    ip_address TEXT,
    session_id TEXT,
    session_start TEXT,
    session_end TEXT,
    device_type TEXT,
    device_os TEXT
);
```

Normalize it to 3NF. Write the CREATE TABLE statements and INSERT statements that extract the data into your normalized schema. Discuss which design decisions you made and why.

### 19. Build a Product Review System Schema
Design a normalized database for a product review platform with:
- Products (id, name, category, manufacturer)
- Users (id, name, email, join_date)
- Reviews (id, product_id, user_id, rating 1-5, title, body, created_at)
- Review votes (users can upvote/downvote reviews)
- Review comments (threaded — comments can reply to other comments)
- Review photos (each review can have multiple photos)

Include all constraints, foreign keys, and a strategy for:
- Ensuring one review per user per product
- Preventing voting on your own review
- Efficiently finding the top-rated products (average rating with minimum 5 reviews)

### 20. Denormalization Trade-Off Analysis
Take the normalized e-commerce schema (customers, orders, order_items, products) and design a denormalized version optimized specifically for this query:
```sql
-- Find total revenue per customer by category for the last 3 months
```

Create the denormalized table, explain the trade-offs (SELECT speed vs UPDATE complexity, storage cost, data integrity risks), and write the query against both schemas. Compare the query complexity and expected performance using EXPLAIN QUERY PLAN.

---

## 🔥 Bonus Challenges

### 21. Recursive CTE: BOM Explosion (Bill of Materials)
Assume products can be kits containing other products. Design a `product_components` table (kit_id, component_id, quantity) and populate it. Then use a recursive CTE to calculate the total cost of each kit by summing component costs (recursing through all levels).

### 22. Window Function Gauntlet
Write a single query that uses ALL of these window functions on the same dataset:
- ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE(4)
- LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()
- PERCENT_RANK(), CUME_DIST()
- SUM() OVER(), AVG() OVER()
The query should provide meaningful business analysis, not just demonstrate syntax.

### 23. Full-Text Search vs LIKE Performance
Compare `LIKE '%search%'` vs SQLite's FTS5 for finding products. Create an FTS virtual table, populate it with product data, and compare query performance and result quality for searches like "wireless", "desk", "chair". Measure execution time using timestamps.

### 24. Trigger-Based Audit Trail
Design and implement a trigger-based audit system for the orders table. Every time an order's status changes, log the old status, new status, and timestamp to an `order_audit_log` table. Write test queries that demonstrate the audit trail working.

### 25. Cumulative SQL Proficiency Challenge
Using only CTEs and window functions (no subqueries in FROM/JOIN), write a query against the employees table that produces:
1. Each employee's rank by salary within their department
2. The salary difference from the next higher-paid employee in their department
3. The running total of salaries in their department
4. The percentage of the department total that their salary represents
5. A column showing 'Top Earner' if they're the highest in their dept, 'Above Avg' if above dept average, 'Below Avg' if below

---

## Evaluation Criteria

For each exercise, check:
- [ ] Query runs without errors
- [ ] Output matches expected format
- [ ] Window functions used correctly with proper framing
- [ ] EXPLAIN QUERY PLAN analysis is accurate
- [ ] Schema designs are normalized to at least 3NF
- [ ] Indexes are justified (not over-indexed)
- [ ] CASE expressions handle NULLs appropriately
- [ ] COALESCE/IFNULL used where values might be NULL

---

## Tips for Success

1. **Start simple**: Write the core query first, then add complexity
2. **Test incrementally**: Run intermediate CTEs to verify results
3. **Use EXPLAIN**: Always check query plans for optimization exercises
4. **Document assumptions**: Comment your reasoning, especially for design challenges
5. **Compare approaches**: When asked to write the same query multiple ways, compare results and plans
6. **Think about scale**: For design questions, consider how the schema performs at 1M+ rows
