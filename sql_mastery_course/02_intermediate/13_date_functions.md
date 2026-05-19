# Lesson 13: Date Functions — Working with Time

## Why Date Functions Matter

Dates and times are the backbone of business analysis — monthly trends, customer tenure, order aging, day-of-week patterns. SQLite has powerful (though sometimes quirky) date functions that let you slice and dice temporal data.

> **Note:** SQLite stores dates as TEXT in ISO format: `'YYYY-MM-DD'`. The date functions understand this format. Times include `'YYYY-MM-DD HH:MM:SS'`.

---

## 1. DATE() — Get Current Date or Parse a Date

### Syntax
```sql
DATE(timestring, modifier1, modifier2, ...)
```

### Examples
```sql
SELECT DATE('now') AS today;
-- 2026-05-18

SELECT DATE('2024-03-15') AS parsed;
-- 2024-03-15
```

---

## 2. TIME() — Get Time Component

```sql
SELECT TIME('now') AS current_time;
-- 14:24:00 (varies)

SELECT TIME('2024-03-15 09:30:00') AS time_part;
-- 09:30:00
```

---

## 3. STRFTIME() — Format Dates as Strings

The most flexible date function. Format codes let you extract any component.

### Common format codes

| Code | Meaning            | Example        |
|------|--------------------|----------------|
| %Y   | 4-digit year       | 2024           |
| %m   | 2-digit month      | 03             |
| %d   | 2-digit day        | 15             |
| %j   | Day of year (001-366) | 075         |
| %W   | Week number        | 11             |
| %w   | Day of week (0=Sun, 6=Sat) | 6       |
| %H   | Hour (00-23)       | 14             |
| %M   | Minute (00-59)     | 30             |
| %S   | Second (00-59)     | 00             |

### Example: Extract components from order dates

```sql
SELECT order_id, order_date,
       strftime('%Y', order_date) AS year,
       strftime('%m', order_date) AS month,
       strftime('%d', order_date) AS day,
       strftime('%w', order_date) AS weekday_num,
       strftime('%Y-%m', order_date) AS year_month
FROM orders
LIMIT 5;
```

**Expected output**
```
order_id|order_date|year|month|day|weekday_num|year_month
1001|2024-01-05|2024|01|05|5|2024-01
1002|2024-01-07|2024|01|07|0|2024-01
1003|2024-01-10|2024|01|10|3|2024-01
1004|2024-01-12|2024|01|12|5|2024-01
1005|2024-01-15|2024|01|15|1|2024-01
```

---

## 4. JULIANDAY() — Date Differences in Days

Returns the Julian day number (continuous count of days since a reference date). Subtract two Julian day numbers to get the difference in days.

### Example: Order age in days (as of June 1, 2024)

```sql
SELECT order_id, order_date,
       ROUND(JULIANDAY('2024-06-01') - JULIANDAY(order_date)) AS days_old
FROM orders
LIMIT 8;
```

**Expected output**
```
order_id|order_date|days_old
1001|2024-01-05|148
1002|2024-01-07|146
1003|2024-01-10|143
1004|2024-01-12|141
1005|2024-01-15|138
1006|2024-01-18|135
1007|2024-01-20|133
1008|2024-01-22|131
```

### Example: Customer tenure in days

```sql
SELECT first_name || ' ' || last_name AS customer,
       registration_date,
       ROUND(JULIANDAY('2024-06-01') - JULIANDAY(registration_date)) AS tenure_days
FROM customers
ORDER BY tenure_days DESC
LIMIT 5;
```

**Expected output**
```
customer|registration_date|tenure_days
Ethan Williams|2022-11-18|561
James Taylor|2022-12-05|544
Ava Rodriguez|2022-09-22|618
Charlotte Jackson|2022-10-30|580
Noah Wilson|2023-07-14|323
```

---

## 5. DATE Arithmetic — Add/Subtract Time Intervals

### Syntax
```sql
DATE(date_string, '+N days')
DATE(date_string, '-N months')
DATE(date_string, '+N years')
DATE(date_string, '+N hours', '+N minutes')  -- for datetime
```

### Example 1: Estimated delivery date (+7 days from order)

```sql
SELECT order_id, order_date,
       DATE(order_date, '+7 days') AS est_delivery
FROM orders
LIMIT 5;
```

**Expected output**
```
order_id|order_date|est_delivery
1001|2024-01-05|2024-01-12
1002|2024-01-07|2024-01-14
1003|2024-01-10|2024-01-17
1004|2024-01-12|2024-01-19
1005|2024-01-15|2024-01-22
```

### Example 2: Add 1 month to registration for follow-up

```sql
SELECT first_name || ' ' || last_name AS customer,
       registration_date,
       DATE(registration_date, '+1 month') AS follow_up_date
FROM customers
LIMIT 5;
```

**Expected output**
```
customer|registration_date|follow_up_date
Sarah Johnson|2023-01-15|2023-02-15
Mike Chen|2023-02-20|2023-03-20
Emma Davis|2023-03-10|2023-04-10
Alex Kumar|2023-01-25|2023-02-25
Olivia Martinez|2023-04-05|2023-05-05
```

---

## 6. GROUP BY Date Parts — Monthly / Weekly Analysis

### Example 1: Monthly revenue trends

```sql
SELECT strftime('%Y-%m', order_date) AS month,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS revenue
FROM orders
WHERE status != 'Cancelled'
GROUP BY month
ORDER BY month;
```

**Expected output**
```
month|order_count|revenue
2024-01|8|1515.98
2024-02|11|2230.73
2024-03|9|1975.74
2024-04|11|2442.23
2024-05|4|1112.5
```

### Example 2: Day-of-week analysis — which days have most orders?

```sql
SELECT CASE CAST(strftime('%w', order_date) AS INTEGER)
           WHEN 0 THEN 'Sunday'
           WHEN 1 THEN 'Monday'
           WHEN 2 THEN 'Tuesday'
           WHEN 3 THEN 'Wednesday'
           WHEN 4 THEN 'Thursday'
           WHEN 5 THEN 'Friday'
           WHEN 6 THEN 'Saturday'
       END AS weekday,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS revenue
FROM orders
GROUP BY strftime('%w', order_date)
ORDER BY strftime('%w', order_date);
```

**Expected output**
```
weekday|order_count|revenue
Sunday|7|1374.72
Monday|8|1660.74
Tuesday|6|1243.49
Wednesday|9|1725.98
Thursday|8|1591.5
Friday|7|1096.73
Saturday|5|583.25
```

### Example 3: Movies released by decade

```sql
SELECT (CAST(strftime('%Y', release_year || '-01-01') AS INTEGER) / 10) * 10 AS decade,
       COUNT(*) AS movie_count,
       ROUND(AVG(rating), 2) AS avg_rating
FROM movies
GROUP BY decade
ORDER BY decade;
```

**Expected output**
```
decade|movie_count|avg_rating
1970|1|9.2
1990|8|8.41
2000|10|8.38
2010|14|8.07
2020|7|7.87
```

---

## 7. Real Business Examples

### Example: Customer purchase recency (days since last order)

```sql
SELECT c.first_name || ' ' || c.last_name AS customer,
       MAX(o.order_date) AS last_order_date,
       ROUND(JULIANDAY('2024-06-01') - JULIANDAY(MAX(o.order_date))) AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status != 'Cancelled'
GROUP BY c.customer_id
ORDER BY days_since_last_order DESC
LIMIT 5;
```

**Expected output**
```
customer|last_order_date|days_since_last_order
Sarah Johnson|2024-05-03|29
Mike Chen|2024-03-22|71
Emma Davis|2024-04-05|57
Alex Kumar|2024-04-22|40
Olivia Martinez|2024-04-08|54
```

### Example: Employee tenure in years

```sql
SELECT first_name || ' ' || last_name AS employee,
       hire_date,
       ROUND((JULIANDAY('2024-06-01') - JULIANDAY(hire_date)) / 365.25, 1) AS tenure_years
FROM employees
ORDER BY tenure_years DESC;
```

**Expected output (first 3)**
```
employee|hire_date|tenure_years
George Harris|2016-05-22|8.0
John Smith|2018-03-15|6.2
Julia Roberts|2018-08-08|5.8
```

---

## Exercises

1. **Weekend vs weekday orders** — Count how many orders were placed on weekends (Sat/Sun) vs weekdays. Show weekend_count and weekday_count.

2. **Quarterly revenue** — Group orders by quarter (use strftime and CASE or arithmetic) and show total revenue for each quarter of 2024.

3. **Order aging** — For pending orders only, calculate how many days ago they were placed (use JULIANDAY with 'now' or a fixed date). Show order_id, order_date, days_pending.

4. **Employee anniversary** — Show employees hired in each month. Group by month name (January, February, etc.) and count them.

5. **7-day rolling orders** — For each order date, count how many orders were placed in the 7 days before it. (Hint: self-join with DATE arithmetic.)

---

## 🔥 Mini Challenges

1. **First order of each month** — For each month in 2024, find the earliest order placed. Show month and the order_id of the first order.

2. **Revenue growth month-over-month** — Calculate month-over-month revenue growth percentage. Use LAG or a self-join to compare each month's revenue to the previous month. Show month, revenue, prev_month_revenue, growth_pct.
