# Lesson 11: CASE WHEN — Conditional Logic in SQL

## Why CASE WHEN?

CASE WHEN brings if-then-else logic into SQL. Without it, you'd need multiple queries or application-level code to bucket, categorize, or pivot data. CASE WHEN lets you do it all in one SELECT.

---

## 1. Simple CASE Expression

Compares one expression against multiple literal values — like a switch statement.

### Syntax

```sql
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ...
    ELSE default_result
END
```

### Example: Categorize departments by location

```sql
SELECT department_name, location,
       CASE location
           WHEN 'New York' THEN 'Headquarters'
           WHEN 'San Francisco' THEN 'West Coast Hub'
           ELSE 'Regional Office'
       END AS office_type
FROM departments;
```

**Expected output**
```
department_name|location|office_type
Data & Analytics|New York|Headquarters
Engineering|San Francisco|West Coast Hub
Product|New York|Headquarters
Marketing|Chicago|Regional Office
Human Resources|New York|Headquarters
Sales|Denver|Regional Office
```

---

## 2. Searched CASE Expression

Evaluates independent Boolean conditions — much more flexible than simple CASE. Each WHEN has its own condition.

### Syntax

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    ELSE default_result
END
```

### Example 1: Salary brackets (Low / Medium / High / Executive)

```sql
SELECT first_name || ' ' || last_name AS employee,
       salary,
       CASE
           WHEN salary < 65000 THEN 'Low'
           WHEN salary BETWEEN 65000 AND 90000 THEN 'Medium'
           WHEN salary BETWEEN 90001 AND 130000 THEN 'High'
           ELSE 'Executive'
       END AS salary_bracket
FROM employees
ORDER BY salary;
```

**Expected output (first/last few rows)**
```
employee|salary|salary_bracket
Ian Clark|55000.0|Low
Hannah Martin|60000.0|Low
Charlie Brown|65000.0|Medium
Laura Wilson|70000.0|Medium
John Smith|75000.0|Medium
...
Bob Johnson|110000.0|High
Michael Jordan|130000.0|High
George Harris|200000.0|Executive
```

### Example 2: Order size categories

```sql
SELECT order_id, total_amount,
       CASE
           WHEN total_amount < 100 THEN 'Small'
           WHEN total_amount BETWEEN 100 AND 300 THEN 'Medium'
           ELSE 'Large'
       END AS order_size
FROM orders
LIMIT 10;
```

**Expected output**
```
order_id|total_amount|order_size
1001|125.99|Medium
1002|89.5|Small
1003|249.99|Medium
1004|45.0|Small
1005|310.25|Large
1006|78.5|Small
1007|199.99|Medium
1008|55.0|Small
1009|420.0|Large
1010|67.75|Small
```

### Example 3: Movie rating buckets

```sql
SELECT title, rating,
       CASE
           WHEN rating >= 9.0 THEN 'Masterpiece'
           WHEN rating >= 8.0 THEN 'Excellent'
           WHEN rating >= 7.0 THEN 'Good'
           ELSE 'Average'
       END AS rating_category
FROM movies
ORDER BY rating DESC
LIMIT 10;
```

**Expected output**
```
title|rating|rating_category
The Shawshank Redemption|9.3|Masterpiece
The Godfather|9.2|Masterpiece
The Dark Knight|9.0|Masterpiece
Pulp Fiction|8.9|Excellent
Inception|8.8|Excellent
Forrest Gump|8.8|Excellent
Fight Club|8.8|Excellent
The Matrix|8.7|Excellent
Goodfellas|8.7|Excellent
Spirited Away|8.6|Excellent
```

### Example 4: Property revenue tiers

```sql
SELECT property_name, price, nights_booked,
       price * nights_booked AS estimated_revenue,
       CASE
           WHEN price * nights_booked < 15000 THEN 'Bronze'
           WHEN price * nights_booked BETWEEN 15000 AND 30000 THEN 'Silver'
           WHEN price * nights_booked BETWEEN 30001 AND 50000 THEN 'Gold'
           ELSE 'Platinum'
       END AS revenue_tier
FROM airbnb_listings
ORDER BY estimated_revenue DESC
LIMIT 8;
```

**Expected output**
```
property_name|price|nights_booked|estimated_revenue|revenue_tier
The Penthouse Suite|600.0|60|36000|Gold
City View Penthouse|450.0|90|40500|Gold
Luxury Condo Midtown|320.0|110|35200|Gold
Modern Riverside Apt|210.0|150|31500|Gold
Spacious Family Apt|130.0|85|11050|Bronze
Charming Brownstone|175.0|130|22750|Silver
Artsy Loft Williamsburg|195.0|95|18525|Silver
Hipster Hideaway|70.0|250|17500|Silver
```

---

## 3. CASE with GROUP BY — Pivot-Style Analysis

CASE inside aggregate functions lets you create cross-tab reports (pivot tables).

### Example 1: Count orders by status per month

```sql
SELECT strftime('%Y-%m', order_date) AS month,
       COUNT(CASE WHEN status = 'Delivered' THEN 1 END) AS delivered,
       COUNT(CASE WHEN status = 'Shipped' THEN 1 END) AS shipped,
       COUNT(CASE WHEN status = 'Pending' THEN 1 END) AS pending,
       COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancelled,
       COUNT(*) AS total
FROM orders
GROUP BY month
ORDER BY month;
```

**Expected output**
```
month|delivered|shipped|pending|cancelled|total
2024-01|6|1|1|1|9
2024-02|8|2|1|1|12
2024-03|6|2|1|1|10
2024-04|6|3|2|1|12
2024-05|3|1|0|0|4
```

### Example 2: Revenue by payment method per quarter

```sql
SELECT CASE
           WHEN order_date BETWEEN '2024-01-01' AND '2024-03-31' THEN 'Q1'
           WHEN order_date BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Q2'
       END AS quarter,
       ROUND(SUM(CASE WHEN payment_method = 'Credit Card' THEN total_amount ELSE 0 END), 2) AS credit_card,
       ROUND(SUM(CASE WHEN payment_method = 'PayPal' THEN total_amount ELSE 0 END), 2) AS paypal,
       ROUND(SUM(CASE WHEN payment_method = 'Debit Card' THEN total_amount ELSE 0 END), 2) AS debit_card,
       ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
WHERE status != 'Cancelled'
GROUP BY quarter
ORDER BY quarter;
```

**Expected output**
```
quarter|credit_card|paypal|debit_card|total_revenue
Q1|1435.46|1450.23|1266.52|4152.21
Q2|1888.49|1068.74|1400.73|4357.96
```

### Example 3: Employee count by department and salary tier

```sql
SELECT d.department_name,
       COUNT(CASE WHEN e.salary < 70000 THEN 1 END) AS junior,
       COUNT(CASE WHEN e.salary BETWEEN 70000 AND 100000 THEN 1 END) AS mid,
       COUNT(CASE WHEN e.salary > 100000 THEN 1 END) AS senior,
       COUNT(*) AS total_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY d.department_name;
```

**Expected output**
```
department_name|junior|mid|senior|total_employees
Data & Analytics|1|1|2|4
Engineering|1|1|2|4
Human Resources|0|1|0|1
Marketing|1|1|0|2
Product|0|1|1|2
Sales|0|1|1|2
```

---

## Exercises

1. **Customer age groups** — Categorize customers into age brackets: 'Young' (< 25), 'Adult' (25-40), 'Senior' (> 40). Show name, age, and bracket.

2. **Product stock status** — Using products, create a column 'stock_status': 'Low' (< 50), 'Medium' (50-150), 'High' (> 150). Show product name, stock, and status.

3. **Movie profitability** — Create a column 'profit_category': 'Blockbuster' (revenue > 500M), 'Hit' (200-500M), 'Moderate' (50-200M), 'Flop' (< 50M). Show title, revenue, category.

4. **Revenue by room type across neighbourhoods** — Use CASE + GROUP BY to pivot: count listings by neighbourhood and room type ('Entire home/apt' vs 'Private room').

5. **Order value segments** — Bucket customers into segments based on their total spend: 'Low' (< $200), 'Medium' ($200-$500), 'High' (> $500). Show customer name and segment.

---

## 🔥 Mini Challenges

1. **Dynamic salary band report** — Create a pivot showing how many employees fall into each salary band ($0-60k, $60-80k, $80-100k, $100-130k, $130k+) for each department. Use 5 CASE WHENs inside COUNT.

2. **Conditional bonus calculation** — Calculate a hypothetical bonus: 15% of salary if salary < 70k, 10% if 70k-100k, 5% if > 100k. Show employee name, salary, bonus_pct, and bonus_amount.
