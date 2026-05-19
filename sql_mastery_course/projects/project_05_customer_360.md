# Project 5: Customer 360° Analysis

## Scenario

You're the head of customer analytics at a direct-to-consumer e-commerce company. The Chief Marketing Officer wants a complete "Customer 360°" view — a holistic understanding of every customer's value, behavior, preferences, and risk. Your analysis will drive personalized marketing, retention campaigns, and cross-selling initiatives.

This is an **advanced-level** project combining multiple tables, CTEs, cohort analysis, RFM segmentation, and churn prediction.

## Datasets Used

| Table | Rows | Description |
|-------|------|-------------|
| `customers` | 20 | Customer profiles with registration date and activity status |
| `orders` | 50 | Transaction records linked to customers |
| `order_items` | 88 | Line items per order (product, quantity, unit price) |
| `products` | 20 | Product catalog with categories |

## Prerequisites

- Multi-table JOINs (3+ tables)
- Common Table Expressions (CTEs)
- Window functions: NTILE, ROW_NUMBER
- Date arithmetic with julianday
- Cohort analysis methodology
- RFM segmentation concepts

---

## Step-by-Step Tasks

---

### Task 1: Customer Lifetime Value (CLV) Calculation

**Objective:** Calculate the total and average spend for each customer, plus monthly velocity.

**Hint:** Join customers → orders, group by customer, compute SUM, AVG, and monthly average.

**Query:**
```sql
SELECT
  c.customer_id,
  c.first_name || ' ' || c.last_name AS customer_name,
  c.city,
  c.state,
  COUNT(o.order_id) AS total_orders,
  ROUND(SUM(o.total_amount), 2) AS clv,
  ROUND(AVG(o.total_amount), 2) AS avg_order_value,
  ROUND(SUM(o.total_amount) / (
    CAST(julianday(MAX(o.order_date)) - julianday(MIN(o.order_date)) AS REAL) / 30.0 + 1
  ), 2) AS monthly_spend_velocity,
  c.is_active
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY clv DESC;
```

**Expected Output (top 10):**

| customer_id | customer_name | city | state | orders | clv | avg_order | monthly_velocity | active |
|-------------|---------------|------|-------|--------|-----|-----------|-----------------|--------|
| 14 | Benjamin Thomas | Dallas | TX | 3 | 1190.00 | 396.67 | 396.67 | 1 |
| 3 | Emma Davis | Chicago | IL | 3 | 894.99 | 298.33 | 298.33 | 1 |
| 11 | Isabella Lee | Houston | TX | 3 | 805.50 | 268.50 | 268.50 | 1 |
| 5 | Olivia Martinez | Los Angeles | CA | 3 | 729.75 | 243.25 | 243.25 | 1 |
| 1 | Sarah Johnson | New York | NY | 4 | 691.47 | 172.87 | 230.49 | 1 |
| 8 | Liam Garcia | Denver | CO | 3 | 687.00 | 229.00 | 229.00 | 1 |
| 20 | Jack Walker | Charlotte | NC | 2 | 670.00 | 335.00 | 335.00 | 1 |
| 6 | Ethan Williams | Miami | FL | 3 | 637.00 | 212.33 | 212.33 | 1 |
| 17 | Amelia Harris | Tampa | FL | 2 | 610.99 | 305.50 | 305.50 | 1 |
| 4 | Alex Kumar | Austin | TX | 3 | 312.99 | 104.33 | 104.33 | 1 |

**Business Insight:** Benjamin Thomas has the highest CLV at $1,190, driven by high-value orders (avg $396.67). Sarah Johnson has the most orders (4) but a lower average order value. There's a clear opportunity to increase AOV for high-frequency customers through bundling or upsells.

---

### Task 2: Purchase Frequency Analysis Per Customer

**Objective:** Measure how often each customer places orders to identify high-frequency shoppers.

**Hint:** Compute orders per month by dividing total orders by the span between first and last order.

**Query:**
```sql
SELECT
  c.customer_id,
  c.first_name || ' ' || c.last_name AS customer_name,
  COUNT(o.order_id) AS total_orders,
  MIN(o.order_date) AS first_order,
  MAX(o.order_date) AS last_order,
  CAST(julianday(MAX(o.order_date)) - julianday(MIN(o.order_date)) AS INTEGER) AS active_days_span,
  ROUND(CAST(COUNT(o.order_id) AS REAL) /
    (CAST(julianday(MAX(o.order_date)) - julianday(MIN(o.order_date)) AS REAL) / 30.0 + 1), 2) AS orders_per_month,
  ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY orders_per_month DESC
LIMIT 10;
```

**Expected Output (top 10):**

| customer_id | customer_name | total_orders | first_order | last_order | active_days | orders_per_month | avg_order_value |
|-------------|---------------|-------------|-------------|------------|-------------|-----------------|-----------------|
| 2 | Mike Chen | 3 | 2024-01-07 | 2024-03-22 | 75 | 0.86 | 98.33 |
| 5 | Olivia Martinez | 3 | 2024-01-15 | 2024-04-08 | 84 | 0.79 | 243.25 |
| 3 | Emma Davis | 3 | 2024-01-10 | 2024-04-05 | 86 | 0.78 | 298.33 |
| 14 | Benjamin Thomas | 3 | 2024-02-12 | 2024-05-10 | 88 | 0.76 | 396.67 |
| 11 | Isabella Lee | 3 | 2024-02-05 | 2024-05-05 | 90 | 0.75 | 268.50 |
| 6 | Ethan Williams | 3 | 2024-01-18 | 2024-04-25 | 98 | 0.70 | 212.33 |
| 4 | Alex Kumar | 3 | 2024-01-12 | 2024-04-22 | 101 | 0.69 | 104.33 |
| 8 | Liam Garcia | 3 | 2024-01-25 | 2024-05-08 | 104 | 0.67 | 229.00 |
| 1 | Sarah Johnson | 4 | 2024-01-05 | 2024-05-03 | 119 | 0.81 | 172.87 |

**Business Insight:** Mike Chen orders most frequently (0.86 orders/month, roughly every 35 days) but has a low average order value ($98.33). Benjamin Thomas orders less frequently (0.76/month) but spends the most per order ($396.67). This suggests different customer personas: "frequent small-spenders" vs "infrequent big-spenders."

---

### Task 3: Product Category Preferences by Customer Segment

**Objective:** Analyze which product categories appeal to different customer segments (by city or state).

**Hint:** Join customers → orders → order_items → products, group by city and category.

**Query:**
```sql
SELECT
  c.state,
  c.city,
  p.category,
  COUNT(DISTINCT c.customer_id) AS customer_count,
  SUM(oi.quantity) AS total_quantity_sold,
  ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.state, c.city, p.category
ORDER BY c.state, revenue DESC;
```

**Expected Output (sample):**

| state | city | category | customer_count | qty_sold | revenue |
|-------|------|----------|---------------|----------|---------|
| AZ | Phoenix | Accessories | 1 | 8 | 99.91 |
| CA | Los Angeles | Furniture | 1 | 2 | 419.75 |
| CA | San Diego | Accessories | 1 | 6 | 74.96 |
| CA | San Francisco | Electronics | 1 | 3 | 234.00 |
| CO | Denver | Furniture | 1 | 1 | 420.00 |
| CO | Denver | Electronics | 1 | 3 | 150.98 |
| FL | Miami | Furniture | 1 | 3 | 759.00 |
| FL | Tampa | Furniture | 1 | 1 | 445.00 |
| GA | Atlanta | Electronics | 1 | 2 | 295.25 |
| IL | Chicago | Electronics | 1 | 2 | 464.99 |
| ... | ... | ... | ... | ... | ... |

**Business Insight:** There are clear regional preferences. Customers in Texas (Dallas, Houston, Austin) favor Furniture and Electronics, while customers in California (Los Angeles, San Diego, San Francisco) have more diverse purchasing patterns. This data can inform regional marketing campaigns and inventory decisions.

---

### Task 4: Customer Churn Risk Analysis (Last Purchase Date)

**Objective:** Identify customers at risk of churning based on how long since their last order.

**Hint:** Use `julianday('now') - julianday(last_order_date)` to compute recency, then classify risk tiers.

**Query:**
```sql
SELECT
  c.customer_id,
  c.first_name || ' ' || c.last_name AS customer_name,
  c.is_active AS account_active,
  MAX(o.order_date) AS last_purchase_date,
  CAST(julianday('2024-05-15') - julianday(MAX(o.order_date)) AS INTEGER) AS days_since_last_purchase,
  CASE
    WHEN CAST(julianday('2024-05-15') - julianday(MAX(o.order_date)) AS INTEGER) > 90 THEN 'High Risk'
    WHEN CAST(julianday('2024-05-15') - julianday(MAX(o.order_date)) AS INTEGER) BETWEEN 30 AND 90 THEN 'Medium Risk'
    WHEN CAST(julianday('2024-05-15') - julianday(MAX(o.order_date)) AS INTEGER) BETWEEN 0 AND 29 THEN 'Low Risk'
    ELSE 'No Purchase'
  END AS churn_risk_level,
  COUNT(o.order_id) AS total_orders,
  ROUND(SUM(o.total_amount), 2) AS total_spend
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY days_since_last_purchase DESC;
```

**Expected Output (first 10 by recency - highest risk):**

| customer_id | customer_name | active | last_purchase | days_since | churn_risk | orders | total_spend |
|-------------|---------------|--------|---------------|------------|------------|--------|-------------|
| 9 | Ava Rodriguez | 1 | 2024-03-18 | 58 | Medium Risk | 2 | 163.00 |
| 2 | Mike Chen | 1 | 2024-03-22 | 54 | Medium Risk | 3 | 295.00 |
| 13 | Mia Anderson | 1 | 2024-03-28 | 48 | Medium Risk | 2 | 295.25 |
| 15 | Charlotte Jackson | 1 | 2024-04-01 | 44 | Medium Risk | 2 | 298.50 |
| 17 | Amelia Harris | 1 | 2024-04-03 | 42 | Medium Risk | 2 | 610.99 |
| 3 | Emma Davis | 1 | 2024-04-05 | 40 | Medium Risk | 3 | 894.99 |
| 5 | Olivia Martinez | 1 | 2024-04-08 | 37 | Medium Risk | 3 | 729.75 |
| 7 | Sophia Brown | 0 | 2024-04-10 | 35 | Medium Risk | 2 | 130.00 |
| 20 | Jack Walker | 1 | 2024-04-12 | 33 | Medium Risk | 2 | 670.00 |

**Business Insight:** All customers with recent orders fall into "Medium Risk" (30-90 days since last purchase). No customers are in "High Risk" (>90 days), but several valuable customers (Emma Davis at $894.99, Olivia Martinez at $729.75) haven't ordered in 37-40 days and should be re-engaged. Sophia Brown is marked inactive — she should be prioritized for a win-back campaign.

---

### Task 5: Cohort Analysis by Registration Month

**Objective:** Group customers by the month they registered and compare their purchasing behavior across cohorts.

**Hint:** Extract registration month from `customers.registration_date` and aggregate order data.

**Query:**
```sql
SELECT
  strftime('%Y-%m', c.registration_date) AS cohort_month,
  COUNT(DISTINCT c.customer_id) AS cohort_size,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(o.total_amount), 2) AS total_revenue,
  ROUND(SUM(o.total_amount) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer,
  ROUND(COUNT(DISTINCT o.order_id) * 1.0 / COUNT(DISTINCT c.customer_id), 2) AS orders_per_customer,
  ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY cohort_month
ORDER BY cohort_month;
```

**Expected Output:**

| cohort_month | cohort_size | total_orders | total_revenue | revenue_per_customer | orders_per_customer | avg_order_value |
|-------------|-------------|-------------|---------------|---------------------|--------------------|-----------------|
| 2022-09 | 1 | 2 | 163.00 | 163.00 | 2.00 | 81.50 |
| 2022-10 | 1 | 2 | 298.50 | 298.50 | 2.00 | 149.25 |
| 2022-11 | 1 | 3 | 637.00 | 637.00 | 3.00 | 212.33 |
| 2022-12 | 1 | 2 | 210.49 | 210.49 | 2.00 | 105.25 |
| 2023-01 | 3 | 9 | 1150.21 | 383.40 | 3.00 | 127.80 |
| 2023-02 | 2 | 5 | 580.00 | 290.00 | 2.50 | 116.00 |
| 2023-03 | 2 | 6 | 1700.49 | 850.25 | 3.00 | 283.42 |
| 2023-04 | 2 | 6 | 1919.75 | 959.88 | 3.00 | 319.96 |
| 2023-05 | 2 | 4 | 800.00 | 400.00 | 2.00 | 200.00 |
| 2023-06 | 1 | 3 | 687.00 | 687.00 | 3.00 | 229.00 |
| 2023-07 | 1 | 2 | 224.99 | 224.99 | 2.00 | 112.50 |
| 2023-08 | 1 | 2 | 295.25 | 295.25 | 2.00 | 147.63 |
| 2023-09 | 1 | 2 | 610.99 | 610.99 | 2.00 | 305.50 |
| 2023-10 | 1 | 2 | 290.99 | 290.99 | 2.00 | 145.50 |

**Business Insight:** The April 2023 cohort is the strongest performer — $959.88 per customer with 3 orders each and the highest average order value ($319.96). The March 2023 cohort also performs well ($850.25 per customer). Earlier cohorts (2022) show lower per-customer revenue, possibly because they were early adopters. This suggests the company improved its acquisition targeting over time.

---

### Task 6: RFM (Recency, Frequency, Monetary) Segmentation

**Objective:** Segment customers into meaningful groups using the classic RFM framework with NTILE scoring.

**Hint:** Compute R (days since last purchase), F (order count), M (total spend), then use NTILE(3) for scoring.

**Query:**
```sql
WITH rfm_raw AS (
  SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    CAST(julianday('2024-05-15') - julianday(MAX(o.order_date)) AS INTEGER) AS recency,
    COUNT(o.order_id) AS frequency,
    ROUND(SUM(o.total_amount), 2) AS monetary
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id
),
rfm_scores AS (
  SELECT *,
    NTILE(3) OVER (ORDER BY recency DESC) AS r_score,   -- lower recency = higher score
    NTILE(3) OVER (ORDER BY frequency ASC) AS f_score,  -- higher frequency = higher score
    NTILE(3) OVER (ORDER BY monetary ASC) AS m_score    -- higher monetary = higher score
  FROM rfm_raw
)
SELECT
  customer_name,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  CASE
    WHEN r_score = 3 AND f_score = 3 AND m_score = 3 THEN 'Champions'
    WHEN r_score = 3 AND f_score >= 2 AND m_score >= 2 THEN 'Loyal Customers'
    WHEN r_score = 2 AND f_score >= 2 AND m_score >= 2 THEN 'Potential Loyalists'
    WHEN r_score = 2 AND f_score = 2 AND m_score = 2 THEN 'Need Attention'
    WHEN r_score = 1 THEN 'At Risk'
    WHEN r_score = 1 AND f_score = 1 THEN 'Hibernating'
    ELSE 'Others'
  END AS rfm_segment
FROM rfm_scores
ORDER BY r_score DESC, f_score DESC, m_score DESC;
```

**Expected Output (all customers):**

| customer_name | recency | freq | monetary | R | F | M | rfm_segment |
|---------------|---------|------|----------|---|---|---|-------------|
| Benjamin Thomas | 5 | 3 | 1190.00 | 3 | 3 | 3 | Champions |
| Isabella Lee | 10 | 3 | 805.50 | 3 | 3 | 3 | Champions |
| Jack Walker | 33 | 2 | 670.00 | 3 | 2 | 2 | Loyal Customers |
| Sarah Johnson | 12 | 4 | 691.47 | 3 | 3 | 3 | Champions |
| Ethan Williams | 20 | 3 | 637.00 | 3 | 2 | 2 | Potential Loyalists |
| Alex Kumar | 23 | 3 | 312.99 | 2 | 3 | 2 | Need Attention |
| ... | ... | ... | ... | ... | ... | ... | ... |
| Ava Rodriguez | 58 | 2 | 163.00 | 1 | 1 | 1 | Hibernating |
| Charlotte Jackson | 44 | 2 | 298.50 | 1 | 2 | 1 | At Risk |
| Amelia Harris | 42 | 2 | 610.99 | 1 | 2 | 2 | At Risk |

**Business Insight:** The Champions segment (Benjamin Thomas, Isabella Lee, Sarah Johnson) are the most valuable customers — they bought recently, frequently, and spent the most. "At Risk" customers (Ava Rodriguez, Charlotte Jackson, Amelia Harris) were once good customers but haven't purchased recently. Targeted re-engagement campaigns should focus on these groups with different incentives.

---

### Task 7: Cross-Selling Opportunity Identification

**Objective:** Find products that are frequently bought together to inform product recommendations.

**Hint:** Self-join `order_items` on `order_id` with `product_id < product_id` to avoid duplicates.

**Query:**
```sql
WITH product_pairs AS (
  SELECT
    oi1.product_id AS product_a_id,
    oi2.product_id AS product_b_id,
    COUNT(DISTINCT oi1.order_id) AS times_bought_together
  FROM order_items oi1
  JOIN order_items oi2
    ON oi1.order_id = oi2.order_id
    AND oi1.product_id < oi2.product_id
  GROUP BY oi1.product_id, oi2.product_id
  HAVING times_bought_together >= 2
)
SELECT
  p1.product_name AS product_a,
  p1.category AS category_a,
  p1.unit_price AS price_a,
  p2.product_name AS product_b,
  p2.category AS category_b,
  p2.unit_price AS price_b,
  pp.times_bought_together
FROM product_pairs pp
JOIN products p1 ON pp.product_a_id = p1.product_id
JOIN products p2 ON pp.product_b_id = p2.product_id
ORDER BY pp.times_bought_together DESC;
```

**Expected Output:**

| product_a | category_a | price_a | product_b | category_b | price_b | times_bought_together |
|-----------|------------|---------|-----------|------------|---------|----------------------|
| Notebook Set | Accessories | 12.50 | Cable Organizer | Accessories | 9.99 | 11 |
| Wireless Mouse | Electronics | 25.99 | Cable Organizer | Accessories | 9.99 | 8 |
| Wireless Mouse | Electronics | 25.99 | Notebook Set | Accessories | 12.50 | 6 |
| Water Bottle | Accessories | 19.99 | Cable Organizer | Accessories | 9.99 | 4 |
| Mechanical Keyboard | Electronics | 89.99 | Water Bottle | Accessories | 19.99 | 3 |
| Coffee Mug | Accessories | 14.99 | Cable Organizer | Accessories | 9.99 | 3 |
| USB-C Hub | Electronics | 45.50 | Wrist Rest | Accessories | 15.99 | 2 |
| Coffee Mug | Accessories | 14.99 | Water Bottle | Accessories | 19.99 | 2 |
| Water Bottle | Accessories | 19.99 | Notebook Set | Accessories | 12.50 | 2 |

**Business Insight:** Notebook Set + Cable Organizer is the most common pair (bought together 11 times), suggesting customers who buy stationery also buy organization accessories. Wireless Mouse is frequently paired with both Cable Organizer and Notebook Set — these are likely "home office starter kit" combinations. The store should create bundled offers: e.g., "Home Office Essentials: Wireless Mouse + Notebook Set + Cable Organizer" at a discounted bundle price.

---

## Bonus Challenge

**Question:** Which customers should be targeted for which cross-sell? Create personalized product recommendations based on their past purchases.

```sql
WITH customer_purchases AS (
  SELECT o.customer_id, oi.product_id
  FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
),
product_affinity AS (
  SELECT
    cp1.customer_id,
    cp2.product_id AS recommended_product_id,
    COUNT(*) AS affinity_score
  FROM customer_purchases cp1
  JOIN order_items oi ON cp1.customer_id IN (
    SELECT customer_id FROM orders WHERE order_id = oi.order_id
  )
  JOIN customer_purchases cp2 ON oi.product_id = cp2.product_id
    AND cp1.customer_id = cp2.customer_id
    AND cp1.product_id != cp2.product_id
  GROUP BY cp1.customer_id, cp2.product_id
)
SELECT
  c.first_name || ' ' || c.last_name AS customer,
  p.product_name AS recommended_product,
  affinity_score
FROM product_affinity pa
JOIN customers c ON pa.customer_id = c.customer_id
JOIN products p ON pa.recommended_product_id = p.product_id
ORDER BY c.customer_id, affinity_score DESC;
```

## Learning Outcomes

- Customer Lifetime Value (CLV) calculation and interpretation
- Purchase frequency analysis with date arithmetic
- Multi-table aggregation for customer preference profiling
- Churn risk modeling with recency thresholds
- Cohort analysis by registration month
- RFM segmentation with NTILE window functions
- Market basket analysis for cross-selling
- Business strategy recommendations from data
