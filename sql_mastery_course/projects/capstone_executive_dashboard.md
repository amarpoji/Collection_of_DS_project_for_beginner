# 🏆 Capstone Project: Executive Business Dashboard

> **Scenario:** You are the **Head of Analytics** at a growing e-commerce company. The CEO needs a comprehensive business performance report covering sales, customers, operations, and strategic insights. Your analysis will drive the Q2 board meeting decisions.

**Datasets Used:** customers, orders, order_items, products, employees, departments

**Skills Tested:** All topics — SELECT, WHERE, JOINs, GROUP BY, HAVING, subqueries, CTEs, window functions, CASE WHEN, date functions, string functions, views

---

## Section A: Revenue & Sales Analysis

### Q1: Monthly Revenue Trend
Show total revenue (sum of total_amount) for each month in 2024. Include the month name, revenue, and number of orders.

```sql
-- Expected output format:
-- month    | revenue | order_count
-- January  | 1596.72 | 10
-- February | 1799.73 | 11
-- March    | 1516.24 | 10
-- April    | 1960.74 | 10
-- May      | 1112.50 | 5
```

**Business Insight:** Identify seasonal patterns and growth/decline months.

---

### Q2: Year-over-Year Growth
Since we only have 2024 data, simulate YoY by comparing monthly revenue to the previous month's revenue (MoM growth). Show month, revenue, previous_month_revenue, and growth_percentage.

**Business Insight:** Which months had the strongest growth? Where did revenue decline?

---

### Q3: Product Category Performance
Calculate total revenue, total quantity sold, and number of unique products sold for each product category. Rank categories by revenue in descending order.

**Business Insight:** Which category drives the most revenue? Which sells the most units?

---

## Section B: Customer Analysis

### Q4: Customer Acquisition Trends
Show how many new customers registered each month. Group by registration month.

```sql
-- Expected:
-- month    | new_customers
-- 2022-09  | 1
-- 2022-10  | 2
-- 2022-11  | 1
-- 2022-12  | 2
-- 2023-01  | 3
-- ...
```

**Business Insight:** When did marketing campaigns work best?

---

### Q5: Customer Lifetime Value (CLV)
For each customer, show their total spend, total orders, average order value, and days since last order. Rank customers by total spend.

**Business Insight:** Who are your top 5 most valuable customers? Who's at risk of churning?

---

### Q6: Repeat Purchase Rate
Calculate what percentage of customers have placed more than one order. Also show the distribution: count of customers by number of orders placed (1 order, 2 orders, 3+ orders).

**Business Insight:** How loyal is your customer base?

---

## Section C: Operations Analysis

### Q7: Order Fulfillment Performance
Show the count and percentage of orders in each status (Delivered, Shipped, Pending, Cancelled). Also calculate the average days between order_date and delivery for delivered orders.

**Business Insight:** How efficient is your fulfillment process? Are cancellations a concern?

---

### Q8: Shipping Analysis
Show the number of orders and total revenue by shipping state. Include percentage of total. Rank by revenue descending.

**Business Insight:** Which states are your biggest markets?

---

### Q9: Payment Method Preferences
Calculate revenue and order count for each payment method. Show what percentage of customers prefer each method.

**Business Insight:** Should you optimize checkout for the most popular payment method?

---

## Section D: Strategic Insights

### Q10: Employee Productivity
Calculate revenue per employee (total company revenue / total employees). Then calculate revenue per department by joining orders → departments.

**Business Insight:** Which department generates the most revenue per employee?

---

### Q11: Market Basket Analysis (Product Affinity)
Find pairs of products that are frequently bought together in the same order. Show product pairs and how many times they appear together.

> **Hint:** Self-join order_items aliased as a and b, matching on order_id but different product_id.

**Business Insight:** Which products should be marketed together or placed next to each other?

---

### Q12: Executive KPI Summary
Create a single query that produces a one-row KPI dashboard:

| Metric | Value |
|--------|-------|
| Total Revenue | |
| Total Orders | |
| Avg Order Value | |
| Total Customers | |
| Repeat Customer % | |
| Total Products Sold | |
| Revenue per Customer | |
| Most Popular Category | |
| Best-Selling Product | |

**Business Insight:** This is the **one report** the CEO wants to see every morning.

---

## 🔥 Challenge Extensions

1. **Cohort Retention Analysis:** Group customers by their registration month. For each cohort, calculate what percentage placed an order in Month 0, Month 1, Month 2, etc.

2. **Revenue Forecasting:** Using a 3-month moving average, predict next month's revenue.

3. **Anomaly Detection:** Identify orders that are outliers — total_amount more than 2 standard deviations from the mean.

4. **Employee of the Month:** Create a ranking system that identifies the department generating the most profit per employee, adjusted for salary costs.

---

## Submission Requirements

For each question, provide:
1. ✅ The SQL query
2. ✅ The output/result
3. ✅ A 1-2 sentence business insight explaining what it means and what action to take

**Good luck! This capstone proves you're job-ready in SQL.**
