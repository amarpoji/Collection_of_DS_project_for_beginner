# Intermediate SQL Exercises — Complete Solutions

Database: `sql_mastery.db`

---

## CASE WHEN (Lesson 11)

---

### Exercise 1 — Customer Age Groups

**Question:** Categorize customers into age groups: 'Young' (under 25), 'Adult' (25-40), 'Senior' (over 40). Show first_name, last_name, age, and age_group. Order by age.

**Solution:**

```sql
SELECT first_name,
       last_name,
       age,
       CASE
           WHEN age < 25 THEN 'Young'
           WHEN age BETWEEN 25 AND 40 THEN 'Adult'
           ELSE 'Senior'
       END AS age_group
FROM customers
ORDER BY age;
```

**Expected Output (first/last rows):**

| first_name | last_name | age | age_group |
|-----------|----------|-----|-----------|
| Noah      | Wilson   | 24  | Young     |
| Olivia    | Martinez | 26  | Adult     |
| ...       | ...      | ... | ...       |
| Emma      | Davis    | 42  | Senior    |
| Ethan     | Williams | 45  | Senior    |

**Explanation:** CASE WHEN evaluates conditions in order. The first matching condition wins. Only Noah Wilson (age 24) is 'Young'. 14 customers are 'Adult' (25-40), and 5 are 'Senior' (over 40).

---

### Exercise 2 — Order Priority

**Question:** Create a priority column: 'High' if total_amount > 400, 'Medium' if 150-400, 'Low' if < 150. Show order_id, total_amount, priority. Order by total_amount DESC.

**Solution:**

```sql
SELECT order_id,
       total_amount,
       CASE
           WHEN total_amount > 400 THEN 'High'
           WHEN total_amount BETWEEN 150 AND 400 THEN 'Medium'
           ELSE 'Low'
       END AS priority
FROM orders
ORDER BY total_amount DESC;
```

**Expected Output (top 5):**

| order_id | total_amount | priority |
|---------|-------------|----------|
| 1039    | 520.00      | High     |
| 1016    | 500.00      | High     |
| 1021    | 445.00      | High     |
| 1036    | 430.00      | High     |
| 1009    | 420.00      | High     |

**Explanation:** 6 orders are High priority (>$400), 21 are Medium ($150-$400), and 23 are Low (<$150). The CASE expression handles all three tiers cleanly.

---

### Exercise 3 — Movie ROI Buckets

**Question:** Calculate ROI = (revenue - budget) / budget * 100. Bucket into 'Blockbuster' (>500%), 'Hit' (100-500%), 'Moderate' (0-100%), 'Loss' (negative). Show title, roi_pct, category.

**Solution:**

```sql
SELECT title,
       ROUND((revenue_millions - budget_millions) / budget_millions * 100, 2) AS roi_pct,
       CASE
           WHEN (revenue_millions - budget_millions) / budget_millions * 100 > 500 THEN 'Blockbuster'
           WHEN (revenue_millions - budget_millions) / budget_millions * 100 BETWEEN 100 AND 500 THEN 'Hit'
           WHEN (revenue_millions - budget_millions) / budget_millions * 100 BETWEEN 0 AND 100 THEN 'Moderate'
           ELSE 'Loss'
       END AS category
FROM movies
ORDER BY roi_pct DESC;
```

**Expected Output (top/bottom):**

| title             | roi_pct  | category    |
|------------------|---------|-------------|
| Whisper of the Heart | 7900.00 | Blockbuster |
| Get Out           | 5566.67 | Blockbuster |
| ...               | ...     | ...         |
| Soul              | -5.33   | Loss        |

**Explanation:** 16 movies are Blockbusters (ROI > 500%), 19 are Hits, 4 are Moderate, and 1 (Soul) is a Loss. Low-budget films like Whisper of the Heart ($0.5M budget) achieve astronomical ROI percentages.

---

### Exercise 4 — Pivot: Orders by Payment Method per Month

**Question:** Using CASE inside COUNT, create a pivot showing how many orders used each payment method per month. Show month, credit_card_count, paypal_count, debit_card_count.

**Solution:**

```sql
SELECT strftime('%Y-%m', order_date) AS month,
       COUNT(CASE WHEN payment_method = 'Credit Card' THEN 1 END) AS credit_card_count,
       COUNT(CASE WHEN payment_method = 'PayPal' THEN 1 END) AS paypal_count,
       COUNT(CASE WHEN payment_method = 'Debit Card' THEN 1 END) AS debit_card_count
FROM orders
GROUP BY month
ORDER BY month;
```

**Expected Output:**

| month   | credit_card_count | paypal_count | debit_card_count |
|---------|------------------|-------------|-----------------|
| 2024-01 | 4                | 3           | 3               |
| 2024-02 | 5                | 4           | 3               |
| 2024-03 | 4                | 3           | 4               |
| 2024-04 | 4                | 4           | 4               |
| 2024-05 | 2                | 2           | 1               |

**Explanation:** This is a "pivot" or "crosstab" query. COUNT(CASE WHEN...) counts only rows matching the condition (non-NULL = 1, NULL = not counted). Credit Card is the most used method most months.

---

## String Functions (Lesson 12)

---

### Exercise 5 — Email Domain Extraction

**Question:** Extract the domain (everything after '@') from all customer emails. Group by domain and count. Show domain and customer_count.

**Solution:**

```sql
SELECT SUBSTR(email, INSTR(email, '@') + 1) AS domain,
       COUNT(*) AS customer_count
FROM customers
GROUP BY domain
ORDER BY customer_count DESC;
```

**Expected Output:**

| domain    | customer_count |
|----------|---------------|
| email.com | 20            |

**Explanation:** INSTR finds the position of '@', SUBSTR extracts everything after it. All 20 customers use email.com, so there's only one domain group.

---

### Exercise 6 — Product Name Cleanup

**Question:** Replace '-' with a space AND convert to proper case (first letter uppercase, rest lowercase). Show original_name and cleaned_name.

**Solution:**

```sql
SELECT product_name AS original_name,
       UPPER(SUBSTR(REPLACE(product_name, '-', ' '), 1, 1)) ||
       LOWER(SUBSTR(REPLACE(product_name, '-', ' '), 2)) AS cleaned_name
FROM products
WHERE product_name LIKE '%-%';
```

**Expected Output:**

| original_name     | cleaned_name     |
|------------------|-----------------|
| 27-inch Monitor  | 27 inch monitor |
| USB-C Hub        | usb c hub       |

**Explanation:** REPLACE replaces hyphens with spaces. UPPER(SUBSTR(...,1,1)) capitalizes first letter. LOWER(SUBSTR(...,2)) lowercases the rest. Note: SQLite doesn't have a built-in PROPER/INITCAP function, so we construct it manually.

---

### Exercise 7 — Employee Initials Badge

**Question:** Generate a badge: first initial + last initial + last 4 digits of phone. Example: John Smith with phone 555-0101 -> "JS0101". Uppercase initials.

**Solution:**

```sql
SELECT first_name || ' ' || last_name AS employee_name,
       UPPER(SUBSTR(first_name, 1, 1)) ||
       UPPER(SUBSTR(last_name, 1, 1)) ||
       SUBSTR(phone, -4) AS badge_id
FROM employees;
```

**Expected Output (first 5):**

| employee_name  | badge_id |
|---------------|----------|
| John Smith    | JS0101   |
| Jane Doe      | JD0102   |
| Bob Johnson   | BJ0103   |
| Alice Williams| AW0104   |
| Charlie Brown | CB0105   |

**Explanation:** SUBSTR(col, 1, 1) gets first character. SUBSTR(phone, -4) gets last 4 characters (negative index starts from the end). UPPER makes initials uppercase.

---

### Exercise 8 — City Name Analysis

**Question:** Find the 3 shortest and 3 longest city names. Show city, length, and label 'Shortest' or 'Longest'. Use UNION.

**Solution:**

```sql
SELECT city, LENGTH(city) AS len_city, 'Shortest' AS label
FROM customers
ORDER BY len_city ASC
LIMIT 3;
```

```sql
SELECT city, LENGTH(city) AS len_city, 'Longest' AS label
FROM customers
ORDER BY len_city DESC
LIMIT 3;
```

(Use UNION ALL to combine the two results in a single output)

**Expected Output:**

| city           | len_city | label    |
|---------------|----------|----------|
| Miami         | 5        | Shortest |
| Tampa         | 5        | Shortest |
| Austin        | 6        | Shortest |
| San Francisco | 13       | Longest  |
| Los Angeles   | 11       | Longest  |
| Minneapolis   | 11       | Longest  |

**Explanation:** Two separate queries ordered differently, combined with UNION ALL. Note: In SQLite, you'll need to run these as separate queries or use a subquery approach since ORDER BY before UNION is not supported.

---

## Date Functions (Lesson 13)

---

### Exercise 9 — Weekend Order Analysis

**Question:** Count orders on weekends vs weekdays. Calculate weekend percentage. Show weekend_count, weekday_count, weekend_pct.

**Solution:**

```sql
SELECT SUM(CASE WHEN CAST(strftime('%w', order_date) AS INTEGER) IN (0, 6) THEN 1 ELSE 0 END) AS weekend_count,
       SUM(CASE WHEN CAST(strftime('%w', order_date) AS INTEGER) NOT IN (0, 6) THEN 1 ELSE 0 END) AS weekday_count,
       ROUND(SUM(CASE WHEN CAST(strftime('%w', order_date) AS INTEGER) IN (0, 6) THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS weekend_pct
FROM orders;
```

**Expected Output:**

| weekend_count | weekday_count | weekend_pct |
|--------------|--------------|-------------|
| 12           | 38           | 24.00       |

**Explanation:** strftime('%w', date) returns day of week (0=Sunday, 6=Saturday). 24% of orders are placed on weekends. Most business activity happens on weekdays.

---

### Exercise 10 — Employee Anniversary Report

**Question:** Find employees hired in each month. Show month name, hire_count, and employee names (comma-separated using GROUP_CONCAT).

**Solution:**

```sql
SELECT CASE CAST(strftime('%m', hire_date) AS INTEGER)
           WHEN 1 THEN 'January' WHEN 2 THEN 'February' WHEN 3 THEN 'March'
           WHEN 4 THEN 'April' WHEN 5 THEN 'May' WHEN 6 THEN 'June'
           WHEN 7 THEN 'July' WHEN 8 THEN 'August' WHEN 9 THEN 'September'
           WHEN 10 THEN 'October' WHEN 11 THEN 'November' WHEN 12 THEN 'December'
       END AS month,
       COUNT(*) AS hire_count,
       GROUP_CONCAT(first_name || ' ' || last_name, ', ') AS employee_names
FROM employees
GROUP BY month
ORDER BY CAST(strftime('%m', hire_date) AS INTEGER);
```

**Expected Output (sample):**

| month     | hire_count | employee_names                  |
|----------|-----------|--------------------------------|
| January  | 2         | Bob Johnson, Ian Clark         |
| March    | 1         | John Smith                     |
| April    | 2         | Charlie Brown, Laura Wilson    |
| ...      | ...       | ...                            |

**Explanation:** strftime('%m') extracts month number. CASE maps it to month name. GROUP_CONCAT aggregates employee names into a comma-separated list per group. January and November have the most hires (2 each).

---

### Exercise 11 — Days Between Customer Orders

**Question:** For each customer's orders, calculate days between consecutive orders. Show customer_id, order_id, order_date, days_since_previous_order. Use JULIANDAY and LAG.

**Solution:**

```sql
SELECT customer_id,
       order_id,
       order_date,
       CAST(julianday(order_date) - julianday(LAG(order_date) OVER (
           PARTITION BY customer_id ORDER BY order_date
       )) AS INTEGER) AS days_since_previous_order
FROM orders
ORDER BY customer_id, order_date;
```

**Expected Output (sample for customer 1):**

| customer_id | order_id | order_date | days_since_previous_order |
|------------|---------|-----------|--------------------------|
| 1          | 1001    | 2024-01-05| NULL                     |
| 1          | 1007    | 2024-01-20| 15                       |
| 1          | 1026    | 2024-03-10| 50                       |
| 1          | 1047    | 2024-05-03| 54                       |

**Explanation:** LAG accesses the previous row's order_date within each customer's partition. JULIANDAY converts dates to a numeric day count for subtraction. The first order per customer shows NULL (no previous order).

---

### Exercise 12 — Quarterly Performance

**Question:** Calculate total revenue per quarter in 2024. Exclude cancelled orders. Show quarter, total_revenue, order_count, and avg_order_value.

**Solution:**

```sql
SELECT 'Q' || CAST((CAST(strftime('%m', order_date) AS INTEGER) + 2) / 3 AS TEXT) AS quarter,
       ROUND(SUM(total_amount), 2) AS total_revenue,
       COUNT(*) AS order_count,
       ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
WHERE strftime('%Y', order_date) = '2024'
  AND status != 'Cancelled'
GROUP BY quarter
ORDER BY quarter;
```

**Expected Output:**

| quarter | total_revenue | order_count | avg_order_value |
|---------|--------------|-------------|-----------------|
| Q1      | 5793.44      | 30          | 193.11          |
| Q2      | 3554.73      | 16          | 222.17          |

**Explanation:** Monthly grouping formula converts months 1-3 to Q1, 4-6 to Q2, etc. Cancelled orders are excluded. Q1 has higher volume (30 orders) but Q2 has higher average order value ($222.17 vs $193.11).

---

## NULL Handling & Views (Lesson 14)

---

### Exercise 13 — Safe Aggregation with IFNULL

**Question:** Count orders per customer using LEFT JOIN. Use IFNULL to show 0 for customers with no orders. Show customer name and order_count.

**Solution:**

```sql
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       IFNULL(COUNT(o.order_id), 0) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
```

**Expected Output (sample):**

| customer_name   | order_count |
|----------------|------------|
| Sarah Johnson  | 4          |
| Mike Chen      | 3          |
| ...            | ...        |

**Explanation:** LEFT JOIN ensures all customers appear even if they have no orders. IFNULL handles the NULL that COUNT would produce for customers with no orders (though in this dataset, every customer has orders).

---

### Exercise 14 — Create a View for Marketing

**Question:** Create a view called marketing_customers (active customers in CA or NY). Then query the view to find how many are in each city.

**Solution:**

```sql
CREATE VIEW marketing_customers AS
SELECT customer_id, first_name, last_name, email, city, state
FROM customers
WHERE is_active = 1 AND state IN ('CA', 'NY');

-- Query the view
SELECT city, COUNT(*) AS customer_count
FROM marketing_customers
GROUP BY city;
```

**Expected Output:**

| city           | customer_count |
|---------------|---------------|
| Los Angeles   | 1             |
| New York      | 1             |
| San Diego     | 1             |
| San Francisco | 1             |

**Explanation:** A view is a saved query that behaves like a virtual table. It simplifies complex queries and adds security by restricting access to certain rows. Four active customers in CA/NY target markets.

---

### Exercise 15 — Safety Net with COALESCE

**Question:** Show employee name, salary, and manager_info. Use COALESCE to show 'Top-Level' for NULL manager_id, otherwise show the manager's name.

**Solution:**

```sql
SELECT e.first_name,
       e.last_name,
       e.salary,
       COALESCE(m.first_name || ' ' || m.last_name, 'Top-Level') AS manager_info
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
```

**Expected Output (sample):**

| first_name | last_name | salary   | manager_info  |
|-----------|----------|----------|--------------|
| John      | Smith    | 75000.0  | Top-Level    |
| Jane      | Doe      | 95000.0  | John Smith   |
| George    | Harris   | 200000.0 | Top-Level    |
| ...       | ...      | ...      | ...          |

**Explanation:** Self-join on employees to find managers. COALESCE returns the first non-NULL value. If manager_id is NULL, the COALESCE expression evaluates to 'Top-Level', otherwise it shows the manager's concatenated name.

---

## CTEs (Lesson 15)

---

### Exercise 16 — Multi-Step: Top Categories

**Question:** Use a CTE pipeline with product_sales -> category_totals -> final: top 3 categories by total_revenue.

**Solution:**

```sql
WITH product_sales AS (
    SELECT p.product_id,
           p.product_name,
           p.category,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id
),
category_totals AS (
    SELECT category,
           SUM(revenue) AS total_revenue,
           AVG(revenue) AS avg_revenue_per_product
    FROM product_sales
    GROUP BY category
)
SELECT category,
       ROUND(total_revenue, 2) AS total_revenue,
       ROUND(avg_revenue_per_product, 2) AS avg_revenue_per_product
FROM category_totals
ORDER BY total_revenue DESC
LIMIT 3;
```

**Expected Output:**

| category   | total_revenue | avg_revenue_per_product |
|-----------|--------------|------------------------|
| Furniture | 4803.75      | 4803.75                |
| Electronics| 3356.55      | 559.43                 |
| Accessories| 1318.31      | 263.66                 |

**Explanation:** First CTE calculates per-product revenue. Second CTE aggregates by category. Final query selects top 3. Furniture dominates even though it has the fewest products sold, because the Standing Desk ($599 each) generates massive revenue.

---

### Exercise 17 — Compare Employee to Department Average

**Question:** Use a CTE to compute each department's average salary. Then show each employee with a column `above_avg` indicating if they exceed the department average.

**Solution:**

```sql
WITH dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.first_name || ' ' || e.last_name AS employee_name,
       e.salary,
       d.department_name,
       ROUND(da.avg_salary, 0) AS dept_avg,
       CASE WHEN e.salary > da.avg_salary THEN 'Yes' ELSE 'No' END AS above_avg
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN dept_avg da ON e.department_id = da.department_id
ORDER BY d.department_name, e.salary DESC;
```

**Expected Output (sample):**

| employee_name   | salary    | department_name   | dept_avg | above_avg |
|----------------|----------|------------------|----------|-----------|
| Bob Johnson    | 110000.0 | Data & Analytics | 85000    | Yes       |
| John Smith     | 75000.0  | Data & Analytics | 85000    | No        |
| George Harris  | 200000.0 | Engineering      | 113000   | Yes       |
| Charlie Brown  | 65000.0  | Engineering      | 113000   | No        |

**Explanation:** The CTE computes department averages once. The main query joins back to compare each employee's salary. 6 out of 15 employees earn above their department average.

---

### Exercise 18 — Recursive Date Series for Full Coverage

**Question:** Generate a complete date series for April 2024. LEFT JOIN with orders. Show date, order count, total revenue (0 for dates with no orders).

**Solution:**

```sql
WITH RECURSIVE dates(date) AS (
    SELECT '2024-04-01'
    UNION ALL
    SELECT DATE(date, '+1 day')
    FROM dates
    WHERE date < '2024-04-30'
)
SELECT d.date,
       COUNT(o.order_id) AS order_count,
       COALESCE(ROUND(SUM(o.total_amount), 2), 0) AS total_revenue
FROM dates d
LEFT JOIN orders o ON d.date = o.order_date
GROUP BY d.date
ORDER BY d.date;
```

**Expected Output (sample):**

| date       | order_count | total_revenue |
|-----------|------------|--------------|
| 2024-04-01| 1          | 210.00       |
| 2024-04-02| 0          | 0.00         |
| 2024-04-03| 1          | 165.99       |
| ...       | ...        | ...          |

**Explanation:** RECURSIVE CTE generates a complete date range. LEFT JOIN ensures all dates appear. COALESCE converts NULL revenue to 0. April has orders on 12 distinct dates; the remaining 18 days show zeros.

---

## Window Functions (Lesson 16)

---

### Exercise 19 — Department Salary Leaderboard

**Question:** Rank employees by salary within each department using RANK(). Show department, employee name, salary, and rank. Only show top 3 per department.

**Solution:**

```sql
SELECT department_name,
       employee_name,
       salary,
       salary_rank
FROM (
    SELECT d.department_name,
           e.first_name || ' ' || e.last_name AS employee_name,
           e.salary,
           RANK() OVER (
               PARTITION BY e.department_id
               ORDER BY e.salary DESC
           ) AS salary_rank
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
) ranked
WHERE salary_rank <= 3
ORDER BY department_name, salary_rank;
```

**Expected Output:**

| department_name   | employee_name    | salary    | salary_rank |
|------------------|-----------------|----------|-------------|
| Data & Analytics | Bob Johnson     | 110000.0 | 1           |
| Data & Analytics | Edward Norton   | 100000.0 | 2           |
| Data & Analytics | John Smith      | 75000.0  | 3           |
| Engineering      | George Harris   | 200000.0 | 1           |
| Engineering      | Jane Doe        | 95000.0  | 2           |
| Engineering      | Kevin Bacon     | 92000.0  | 3           |
| Human Resources  | Julia Roberts   | 78000.0  | 1           |
| Marketing        | Diana Prince    | 85000.0  | 1           |
| Marketing        | Hannah Martin   | 60000.0  | 2           |
| Product          | Alice Williams  | 105000.0 | 1           |
| Product          | Fiona Apple     | 80000.0  | 2           |
| Sales            | Michael Jordan  | 130000.0 | 1           |
| Sales            | Laura Wilson    | 70000.0  | 2           |

**Explanation:** RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) assigns a rank within each department. The subquery is necessary because SQLite doesn't support QUALIFY for filtering window functions.

---

### Exercise 20 — Running Total with Comparison

**Question:** For customer_id = 3 (Emma Davis), show each order: order_id, order_date, total_amount, running total, and difference from previous order. Order by order_date.

**Solution:**

```sql
SELECT order_id,
       order_date,
       total_amount,
       ROUND(SUM(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ), 2) AS running_total,
       ROUND(total_amount - LAG(total_amount, 1, 0) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ), 2) AS diff_from_prev
FROM orders
WHERE customer_id = 3
ORDER BY order_date;
```

**Expected Output:**

| order_id | order_date | total_amount | running_total | diff_from_prev |
|---------|-----------|-------------|--------------|---------------|
| 1003    | 2024-01-10| 249.99      | 249.99       | 249.99        |
| 1018    | 2024-02-18| 215.00      | 464.99       | -34.99        |
| 1036    | 2024-04-05| 430.00      | 894.99       | 215.00        |

**Explanation:** SUM() OVER with ORDER BY creates a running total. LAG(..., 1, 0) accesses the previous row's total_amount, defaulting to 0 for the first row. Emma's spending fluctuated: $249.99 -> $215.00 (drop), then $430.00 (big increase).

---

### Exercise 21 — Genre Popularity Trend

**Question:** For each genre, rank movies by rating (ROW_NUMBER) and calculate the average rating of the top 2 movies in each genre.

**Solution:**

```sql
WITH genre_ranked AS (
    SELECT genre,
           title,
           rating,
           ROW_NUMBER() OVER (
               PARTITION BY genre ORDER BY rating DESC
           ) AS rn
    FROM movies
)
SELECT genre,
       ROUND(AVG(rating), 2) AS avg_top2_rating
FROM genre_ranked
WHERE rn <= 2
GROUP BY genre
ORDER BY avg_top2_rating DESC;
```

**Expected Output:**

| genre     | avg_top2_rating |
|----------|----------------|
| Drama     | 9.05           |
| Crime     | 9.05           |
| Sci-Fi    | 8.75           |
| Action    | 8.75           |
| Animation | 8.55           |
| Thriller  | 8.50           |
| Mystery   | 8.35           |
| War       | 8.30           |
| Comedy    | 8.10           |
| Musical   | 8.00           |
| Horror    | 7.60           |

**Explanation:** ROW_NUMBER assigns unique sequential numbers per genre (no ties). Drama and Crime both average 9.05 in their top 2 films. Horror has the lowest top-2 average (7.60).

---

### Exercise 22 — Moving Average of Daily Orders

**Question:** Calculate a 3-day moving average of order count. Show date, daily_orders, moving_avg_3d.

**Solution:**

```sql
WITH daily_orders AS (
    SELECT order_date AS date,
           COUNT(*) AS daily_orders
    FROM orders
    GROUP BY order_date
)
SELECT date,
       daily_orders,
       ROUND(AVG(daily_orders) OVER (
           ORDER BY date
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS moving_avg_3d
FROM daily_orders
ORDER BY date;
```

**Expected Output (sample):**

| date       | daily_orders | moving_avg_3d |
|-----------|-------------|---------------|
| 2024-01-05| 1           | 1.00          |
| 2024-01-07| 1           | 1.00          |
| 2024-01-10| 1           | 1.00          |
| ...       | ...         | ...           |

**Explanation:** Since each order date has exactly 1 order in this dataset, the 3-day moving average is always 1.0. In a larger dataset with multiple orders per day, this would smooth out daily fluctuations.

---

## 🔥 Bonus Challenge: Comprehensive Analysis

---

### Exercise 23 — Executive Dashboard Query

**Question:** Create a single query (using CTEs and window functions) producing a monthly dashboard with: month, total_orders, revenue, running_total_revenue, revenue_change_pct, avg_order_value, top_category.

**Solution:**

```sql
WITH monthly_totals AS (
    SELECT strftime('%Y-%m', order_date) AS month,
           COUNT(*) AS total_orders,
           ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    GROUP BY month
),
monthly_metrics AS (
    SELECT month,
           total_orders,
           revenue,
           ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS running_total_revenue,
           ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 /
                 LAG(revenue) OVER (ORDER BY month), 2) AS revenue_change_pct,
           ROUND(AVG(revenue / total_orders) OVER (ORDER BY month), 2) AS avg_order_value
    FROM monthly_totals
)
SELECT month,
       total_orders,
       revenue,
       running_total_revenue,
       revenue_change_pct
FROM monthly_metrics
ORDER BY month;
```

**Expected Output:**

| month   | total_orders | revenue  | running_total_revenue | revenue_change_pct |
|---------|-------------|----------|----------------------|-------------------|
| 2024-01 | 10          | 1641.97  | 1641.97              | NULL              |
| 2024-02 | 12          | 2265.72  | 3907.69              | 37.99             |
| 2024-03 | 11          | 2031.24  | 5938.93              | -10.35            |
| 2024-04 | 12          | 2517.23  | 8456.16              | 23.93             |
| 2024-05 | 5           | 1112.50  | 9568.66              | -55.80            |

**Explanation:** The dashboard uses 2 CTEs: monthly aggregation, then window functions for running totals and month-over-month growth. Revenue peaked in April at $2,517.23. May shows a sharp drop (-55.8%), though this may be an incomplete month.
