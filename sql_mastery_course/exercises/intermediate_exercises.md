# Intermediate SQL Exercises

Practice exercises covering CASE WHEN, String Functions, Date Functions, NULL Handling, Views, CTEs, and Window Functions.

Database: `/mnt/c/Users/USER/Desktop/agentic ai/notebook_ds/sql_mastery_course/sql_mastery.db`

---

## CASE WHEN (Lesson 11)

### 1. Customer Age Groups
Categorize customers into age groups: 'Young' (under 25), 'Adult' (25-40), 'Senior' (over 40). Show first_name, last_name, age, and age_group. Order by age.

### 2. Order Priority
Create a priority column for orders:
- 'High' if total_amount > 400
- 'Medium' if total_amount 150-400
- 'Low' if total_amount < 150
Show order_id, total_amount, and priority. Order by total_amount DESC.

### 3. Movie ROI Buckets
Calculate return_on_investment = (revenue_millions - budget_millions) / budget_millions * 100. Then bucket into:
- 'Blockbuster' if ROI > 500%
- 'Hit' if 100-500%
- 'Moderate' if 0-100%
- 'Loss' if negative
Show title, roi_pct, and category. Order by roi_pct DESC.

### 4. Pivot: Orders by Payment Method per Month
Using CASE inside COUNT, create a pivot showing how many orders used each payment method (Credit Card, PayPal, Debit Card) per month. Show month, credit_card_count, paypal_count, debit_card_count.

---

## String Functions (Lesson 12)

### 5. Email Domain Extraction
Extract the domain (everything after '@') from all customer emails. Group by domain and count how many customers use each domain. Show domain and customer_count.

### 6. Product Name Cleanup
Products with hyphens in their names (like '27-inch Monitor' and 'USB-C Hub') need to be cleaned. Replace '-' with a space AND convert to proper case (first letter uppercase, rest lowercase). Show original_name and cleaned_name.

### 7. Employee Initials Badge
Generate a badge string for each employee: first initial + last initial + last 4 digits of phone. Example: John Smith with phone 555-0101 → "JS0101"
Uppercase the initials. Show employee_name and badge_id.

### 8. City Name Analysis
Find the 3 shortest and 3 longest city names from the customers table. Show city, length, and a label 'Shortest' or 'Longest'. Use UNION.

---

## Date Functions (Lesson 13)

### 9. Weekend Order Analysis
Count how many orders were placed on weekends (Saturday or Sunday) vs weekdays. Also calculate the percentage of total orders that fall on weekends. Show weekend_count, weekday_count, weekend_pct.

### 10. Employee Anniversary Report
Find employees hired in each month. For each month name (January, February, etc.), show the month, hire_count, and the names of employees hired that month (comma-separated — use GROUP_CONCAT).

### 11. Days Between Customer Orders
For each customer's orders, calculate the number of days between consecutive orders. Show customer_id, order_id, order_date, and days_since_previous_order. Use JULIANDAY and LAG or a self-join.

### 12. Quarterly Performance
Calculate total revenue per quarter in 2024. Exclude cancelled orders. Show quarter (Q1, Q2, etc.), total_revenue, order_count, and avg_order_value.

---

## NULL Handling & Views (Lesson 14)

### 13. Safe Aggregation with IFNULL
Count orders per customer using a LEFT JOIN (customers LEFT JOIN orders). Use IFNULL to show 0 instead of NULL for customers with no orders. Show customer name and order_count. (Note: in our db all customers have orders, but practice the pattern.)

### 14. Create a View for Marketing
Create a view called `marketing_customers` that shows customer_id, first_name, last_name, email, city, and state for customers who are active (is_active = 1) AND live in CA or NY. Then query the view to find how many are in each city.

### 15. Safety Net with COALESCE
Write a query against the employees table that shows first_name, last_name, salary, and a column `manager_info`. Use COALESCE or CASE to show 'Top-Level' for employees whose manager_id is 'NULL', otherwise show the manager's name (requires a self-join + COALESCE on the joined table's name).

---

## CTEs (Lesson 15)

### 16. Multi-Step: Top Categories
Use a CTE pipeline:
1. `product_sales`: product_id, product_name, category, revenue
2. `category_totals`: category, total_revenue, avg_revenue_per_product
3. Final: top 3 categories by total_revenue

### 17. Compare Employee to Department Average (CTE)
Use a CTE to compute each department's average salary. Then in the main query, show each employee's name, salary, department, dept_avg, and a column `above_avg` ('Yes' or 'No') indicating if their salary exceeds the department average.

### 18. Recursive Date Series for Full Coverage
Generate a complete date series for April 2024. LEFT JOIN it with actual orders. For each date, show the date, count of orders placed, and the total revenue. Dates with no orders should show 0.

---

## Window Functions (Lesson 16)

### 19. Department Salary Leaderboard
Rank employees by salary within each department using RANK(). Show department, employee name, salary, and rank. Only show the top 3 per department.

### 20. Running Total with Comparison
For customer_id = 3 (Emma Davis), show each order: order_id, order_date, total_amount, and a running total of their spending. Also use LAG to show the difference from the previous order amount. Order by order_date.

### 21. Genre Popularity Trend
For each genre, rank movies by rating (ROW_NUMBER) and also calculate the average rating of the top 2 movies in each genre. Use a window function + CTE.

### 22. Moving Average of Daily Orders
Calculate a 3-day moving average of order count. Generate daily order counts, then use AVG() OVER(ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW). Show date, daily_orders, moving_avg_3d.

---

## 🔥 Bonus Challenge: Comprehensive Analysis

### 23. Executive Dashboard Query
Create a single query (using CTEs and window functions) that produces a monthly dashboard:
- month
- total_orders
- revenue
- running_total_revenue (cumulative)
- revenue_change_pct (month-over-month % change)
- avg_order_value
- top_category (category with highest revenue that month)

Hint: You'll need at least 4 CTEs and a window function for running totals and LAG for change_pct.
