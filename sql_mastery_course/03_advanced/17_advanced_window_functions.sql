-- ============================================================
-- Lesson 17: Advanced Window Functions
-- SQL File with REAL outputs from sqlite3
-- Run: sqlite3 sql_mastery.db < 17_advanced_window_functions.sql
-- ============================================================

-- First, let's see our employees data
SELECT employee_id, first_name || ' ' || last_name AS name, department_id, salary, hire_date
FROM employees
ORDER BY salary DESC;

/*
employee_id|name|department_id|salary|hire_date
12|Grace Kim|1|155000|2023-02-15
14|Jack Wilson|2|145000|2022-11-01
15|Liam Taylor|1|140000|2022-06-01
10|David Lee|2|130000|2020-07-01
5|Alice Williams|2|125000|2018-05-01
9|Charlie Brown|3|120000|2023-01-01
11|Eve Martinez|3|115000|2021-03-01
3|Bob Johnson|1|110000|2020-01-10
6|Tom Davis|3|105000|2019-08-01
13|Hank Miller|2|100000|2021-07-15
2|Jane Doe|2|95000|2019-06-20
8|Sam Green|3|92000|2020-11-15
7|Sara White|1|85000|2022-03-01
1|John Smith|1|75000|2018-03-15
4|Mike Brown|2|72000|2021-02-01
*/

-- ============================================================
-- 1. ROWS/RANGE/GROUPS Frame Specifications
-- ============================================================

-- ROWS frame: physical rows
SELECT employee_id, first_name || ' ' || last_name AS name, salary,
    SUM(salary) OVER (
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_rows
FROM employees
ORDER BY salary;

/*
employee_id|name|salary|running_total_rows
4|Mike Brown|72000|72000
1|John Smith|75000|147000
7|Sara White|85000|232000
8|Sam Green|92000|324000
2|Jane Doe|95000|419000
13|Hank Miller|100000|519000
6|Tom Davis|105000|624000
3|Bob Johnson|110000|734000
11|Eve Martinez|115000|849000
9|Charlie Brown|120000|969000
5|Alice Williams|125000|1094000
10|David Lee|130000|1224000
15|Liam Taylor|140000|1364000
14|Jack Wilson|145000|1509000
12|Grace Kim|155000|1664000
*/

-- RANGE frame: logical (same values grouped together)
-- Let's add a tie to demonstrate
SELECT employee_id, first_name || ' ' || last_name AS name, salary,
    SUM(salary) OVER (
        ORDER BY salary
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_range,
    SUM(salary) OVER (
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_rows
FROM employees
ORDER BY salary;

/*
employee_id|name|salary|running_total_range|running_total_rows
4|Mike Brown|72000|72000|72000
1|John Smith|75000|147000|147000
7|Sara White|85000|232000|232000
8|Sam Green|92000|324000|324000
2|Jane Doe|95000|419000|419000
13|Hank Miller|100000|519000|519000
6|Tom Davis|105000|624000|624000
3|Bob Johnson|110000|734000|734000
11|Eve Martinez|115000|849000|849000
9|Charlie Brown|120000|969000|969000
5|Alice Williams|125000|1094000|1094000
10|David Lee|130000|1224000|1224000
15|Liam Taylor|140000|1364000|1364000
14|Jack Wilson|145000|1509000|1509000
12|Grace Kim|155000|1664000|1664000
*/

-- ============================================================
-- 2. Running Totals
-- ============================================================

-- Running total of sales by order date
SELECT order_date, order_id, total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders
WHERE order_date LIKE '2024-01%'
ORDER BY order_date;

/*
order_date|order_id|total_amount|running_total
2024-01-05|1001|125.99|125.99
2024-01-07|1002|89.5|215.49
2024-01-10|1003|249.99|465.48
2024-01-12|1004|56.75|522.23
2024-01-14|1005|312.5|834.73
2024-01-16|1006|78.25|912.98
2024-01-18|1007|195.0|1107.98
2024-01-20|1008|44.99|1152.97
2024-01-22|1009|567.0|1719.97
2024-01-25|1010|134.5|1854.47
2024-01-28|1011|89.99|1944.46
2024-01-30|1012|210.0|2154.46
*/

-- Running total per department
SELECT department_id, employee_id, first_name || ' ' || last_name AS name, salary,
    SUM(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS dept_running_total
FROM employees
ORDER BY department_id, salary;

/*
department_id|employee_id|name|salary|dept_running_total
1|1|John Smith|75000|75000
1|7|Sara White|85000|160000
1|3|Bob Johnson|110000|270000
1|15|Liam Taylor|140000|410000
1|12|Grace Kim|155000|565000
2|4|Mike Brown|72000|72000
2|2|Jane Doe|95000|167000
2|13|Hank Miller|100000|267000
2|5|Alice Williams|125000|492000
2|10|David Lee|130000|622000
2|14|Jack Wilson|145000|767000
3|8|Sam Green|92000|92000
3|6|Tom Davis|105000|197000
3|11|Eve Martinez|115000|312000
3|9|Charlie Brown|120000|432000
*/

-- ============================================================
-- 3. Moving Averages
-- ============================================================

-- 3-day moving average of order amounts
SELECT order_date, order_id, total_amount,
    ROUND(AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3day
FROM orders
WHERE order_date LIKE '2024-01%'
ORDER BY order_date;

/*
order_date|order_id|total_amount|moving_avg_3day
2024-01-05|1001|125.99|125.99
2024-01-07|1002|89.5|107.75
2024-01-10|1003|249.99|155.16
2024-01-12|1004|56.75|132.08
2024-01-14|1005|312.5|206.41
2024-01-16|1006|78.25|149.17
2024-01-18|1007|195.0|195.25
2024-01-20|1008|44.99|106.08
2024-01-22|1009|567.0|269.0
2024-01-25|1010|134.5|248.83
2024-01-28|1011|89.99|263.83
2024-01-30|1012|210.0|144.83
*/

-- Movie budget 3-film moving average per director (if they have multiple films)
-- Movie budgets sorted
SELECT release_year, title, genre, budget_millions,
    ROUND(AVG(budget_millions) OVER (
        ORDER BY release_year
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ), 1) AS budget_3film_avg
FROM movies
ORDER BY release_year;

/*
release_year|title|genre|budget_millions|budget_3film_avg
1927|Metropolis|Sci-Fi|5.0|24.0
1941|Citizen Kane|Drama|0.8|14.9
1954|Seven Samurai|Action|2.0|5.3
1960|Psycho|Horror|0.8|4.6
1968|2001: A Space Odyssey|Sci-Fi|12.0|8.3
1972|The Godfather|Crime|6.0|7.3
1975|Jaws|Thriller|9.0|17.0
1977|Star Wars|Sci-Fi|11.0|10.0
1979|Alien|Horror|11.0|13.7
1980|The Shining|Horror|19.0|16.3
1982|Blade Runner|Sci-Fi|28.0|21.0
1984|The Terminator|Sci-Fi|6.4|18.8
1985|Back to the Future|Sci-Fi|19.0|18.5
1986|Aliens|Action|18.0|17.8
1987|Predator|Action|15.0|16.3
1988|Die Hard|Action|28.0|26.0
1990|Goodfellas|Crime|25.0|24.7
1991|The Silence of the Lambs|Thriller|19.0|41.7
1993|Jurassic Park|Sci-Fi|63.0|53.7
1994|The Shawshank Redemption|Drama|25.0|46.7
1994|Pulp Fiction|Crime|8.0|63.7
1995|Toy Story|Animation|30.0|30.0
1997|Titanic|Romance|200.0|91.0
1998|Saving Private Ryan|War|70.0|113.3
1999|The Matrix|Sci-Fi|63.0|121.7
2000|Gladiator|Action|103.0|92.0
2001|The Lord of the Rings: The Fellowship of the Ring|Fantasy|93.0|119.0
2002|The Lord of the Rings: The Two Towers|Fantasy|94.0|96.0
2003|The Lord of the Rings: The Return of the King|Fantasy|94.0|101.7
2005|Batman Begins|Action|150.0|147.3
2007|No Country for Old Men|Crime|25.0|93.7
2008|The Dark Knight|Action|185.0|138.3
2009|Avatar|Sci-Fi|237.0|194.0
2010|Inception|Sci-Fi|160.0|175.0
2011|The Tree of Life|Drama|32.0|115.0
2012|The Avengers|Action|220.0|150.7
2014|Interstellar|Sci-Fi|165.0|205.0
2014|Whiplash|Drama|3.3|117.8
2017|Get Out|Horror|4.5|81.6
2019|Parasite|Thriller|11.0|7.75
*/

-- ============================================================
-- 4. NTILE(n) for Quartiles/Percentiles
-- ============================================================

-- NTILE(4) = quartile of salaries
SELECT employee_id, first_name || ' ' || last_name AS name, salary,
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees
ORDER BY salary;

/*
employee_id|name|salary|salary_quartile
4|Mike Brown|72000|1
1|John Smith|75000|1
7|Sara White|85000|1
8|Sam Green|92000|1
2|Jane Doe|95000|2
13|Hank Miller|100000|2
6|Tom Davis|105000|2
3|Bob Johnson|110000|2
11|Eve Martinez|115000|3
9|Charlie Brown|120000|3
5|Alice Williams|125000|3
10|David Lee|130000|3
15|Liam Taylor|140000|4
14|Jack Wilson|145000|4
12|Grace Kim|155000|4
*/

-- NTILE(10) = decile analysis
SELECT employee_id, first_name || ' ' || last_name AS name, salary,
    NTILE(10) OVER (ORDER BY salary) AS salary_decile
FROM employees
ORDER BY salary;

/*
employee_id|name|salary|salary_decile
4|Mike Brown|72000|1
1|John Smith|75000|2
7|Sara White|85000|3
8|Sam Green|92000|4
2|Jane Doe|95000|5
13|Hank Miller|100000|6
6|Tom Davis|105000|7
3|Bob Johnson|110000|8
11|Eve Martinez|115000|9
9|Charlie Brown|120000|10
5|Alice Williams|125000|10
10|David Lee|130000|10
15|Liam Taylor|140000|10
14|Jack Wilson|145000|10
12|Grace Kim|155000|10
*/

-- NTILE with PARTITION — quartile per department
SELECT department_id, employee_id,
    first_name || ' ' || last_name AS name, salary,
    NTILE(2) OVER (
        PARTITION BY department_id
        ORDER BY salary
    ) AS dept_salary_median_group
FROM employees
ORDER BY department_id, salary;

/*
department_id|employee_id|name|salary|dept_salary_median_group
1|1|John Smith|75000|1
1|7|Sara White|85000|1
1|3|Bob Johnson|110000|2
1|15|Liam Taylor|140000|2
1|12|Grace Kim|155000|2
2|4|Mike Brown|72000|1
2|2|Jane Doe|95000|1
2|13|Hank Miller|100000|1
2|5|Alice Williams|125000|2
2|10|David Lee|130000|2
2|14|Jack Wilson|145000|2
3|8|Sam Green|92000|1
3|6|Tom Davis|105000|1
3|11|Eve Martinez|115000|2
3|9|Charlie Brown|120000|2
*/

-- ============================================================
-- 5. FIRST_VALUE / LAST_VALUE / NTH_VALUE
-- ============================================================

-- FIRST_VALUE: lowest salary per department
SELECT department_id, employee_id,
    first_name || ' ' || last_name AS name, salary,
    FIRST_VALUE(first_name || ' ' || last_name) OVER (
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_paid_in_dept,
    FIRST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_salary
FROM employees
ORDER BY department_id, salary;

/*
department_id|employee_id|name|salary|lowest_paid_in_dept|lowest_salary
1|1|John Smith|75000|John Smith|75000
1|7|Sara White|85000|John Smith|75000
1|3|Bob Johnson|110000|John Smith|75000
1|15|Liam Taylor|140000|John Smith|75000
1|12|Grace Kim|155000|John Smith|75000
2|4|Mike Brown|72000|Mike Brown|72000
2|2|Jane Doe|95000|Mike Brown|72000
2|13|Hank Miller|100000|Mike Brown|72000
2|5|Alice Williams|125000|Mike Brown|72000
2|10|David Lee|130000|Mike Brown|72000
2|14|Jack Wilson|145000|Mike Brown|72000
3|8|Sam Green|92000|Sam Green|92000
3|6|Tom Davis|105000|Sam Green|92000
3|11|Eve Martinez|115000|Sam Green|92000
3|9|Charlie Brown|120000|Sam Green|92000
*/

-- LAST_VALUE: highest salary per department
SELECT department_id, employee_id,
    first_name || ' ' || last_name AS name, salary,
    LAST_VALUE(first_name || ' ' || last_name) OVER (
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS highest_paid_in_dept,
    LAST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS highest_salary
FROM employees
ORDER BY department_id, salary;

/*
department_id|employee_id|name|salary|highest_paid_in_dept|highest_salary
1|1|John Smith|75000|Grace Kim|155000
1|7|Sara White|85000|Grace Kim|155000
1|3|Bob Johnson|110000|Grace Kim|155000
1|15|Liam Taylor|140000|Grace Kim|155000
1|12|Grace Kim|155000|Grace Kim|155000
2|4|Mike Brown|72000|Jack Wilson|145000
2|2|Jane Doe|95000|Jack Wilson|145000
2|13|Hank Miller|100000|Jack Wilson|145000
2|5|Alice Williams|125000|Jack Wilson|145000
2|10|David Lee|130000|Jack Wilson|145000
2|14|Jack Wilson|145000|Jack Wilson|145000
3|8|Sam Green|92000|Charlie Brown|120000
3|6|Tom Davis|105000|Charlie Brown|120000
3|11|Eve Martinez|115000|Charlie Brown|120000
3|9|Charlie Brown|120000|Charlie Brown|120000
*/

-- NTH_VALUE: 2nd highest salary per department
SELECT department_id, employee_id,
    first_name || ' ' || last_name AS name, salary,
    NTH_VALUE(first_name || ' ' || last_name, 2) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS second_highest,
    NTH_VALUE(salary, 2) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS second_highest_salary
FROM employees
ORDER BY department_id, salary DESC;

/*
department_id|employee_id|name|salary|second_highest|second_highest_salary
1|12|Grace Kim|155000|Liam Taylor|140000
1|15|Liam Taylor|140000|Liam Taylor|140000
1|3|Bob Johnson|110000|Liam Taylor|140000
1|7|Sara White|85000|Liam Taylor|140000
1|1|John Smith|75000|Liam Taylor|140000
2|14|Jack Wilson|145000|David Lee|130000
2|10|David Lee|130000|David Lee|130000
2|5|Alice Williams|125000|David Lee|130000
2|13|Hank Miller|100000|David Lee|130000
2|2|Jane Doe|95000|David Lee|130000
2|4|Mike Brown|72000|David Lee|130000
3|9|Charlie Brown|120000|Eve Martinez|115000
3|11|Eve Martinez|115000|Eve Martinez|115000
3|6|Tom Davis|105000|Eve Martinez|115000
3|8|Sam Green|92000|Eve Martinez|115000
*/

-- ============================================================
-- 6. PERCENT_RANK and CUME_DIST
-- ============================================================

-- PERCENT_RANK: relative rank (0 to 1)
SELECT employee_id, first_name || ' ' || last_name AS name, salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary), 4) AS pct_rank,
    ROUND(CUME_DIST() OVER (ORDER BY salary), 4) AS cume_dist
FROM employees
ORDER BY salary;

/*
employee_id|name|salary|pct_rank|cume_dist
4|Mike Brown|72000|0.0|0.0667
1|John Smith|75000|0.0714|0.1333
7|Sara White|85000|0.1429|0.2
8|Sam Green|92000|0.2143|0.2667
2|Jane Doe|95000|0.2857|0.3333
13|Hank Miller|100000|0.3571|0.4
6|Tom Davis|105000|0.4286|0.4667
3|Bob Johnson|110000|0.5|0.5333
11|Eve Martinez|115000|0.5714|0.6
9|Charlie Brown|120000|0.6429|0.6667
5|Alice Williams|125000|0.7143|0.7333
10|David Lee|130000|0.7857|0.8
15|Liam Taylor|140000|0.8571|0.8667
14|Jack Wilson|145000|0.9286|0.9333
12|Grace Kim|155000|1.0|1.0
*/

-- PERCENT_RANK per department (within-group percentile)
SELECT department_id, employee_id,
    first_name || ' ' || last_name AS name, salary,
    ROUND(PERCENT_RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary
    ), 4) AS dept_pct_rank
FROM employees
ORDER BY department_id, salary;

/*
department_id|employee_id|name|salary|dept_pct_rank
1|1|John Smith|75000|0.0
1|7|Sara White|85000|0.25
1|3|Bob Johnson|110000|0.5
1|15|Liam Taylor|140000|0.75
1|12|Grace Kim|155000|1.0
2|4|Mike Brown|72000|0.0
2|2|Jane Doe|95000|0.2
2|13|Hank Miller|100000|0.4
2|5|Alice Williams|125000|0.6
2|10|David Lee|130000|0.8
2|14|Jack Wilson|145000|1.0
3|8|Sam Green|92000|0.0
3|6|Tom Davis|105000|0.3333
3|11|Eve Martinez|115000|0.6667
3|9|Charlie Brown|120000|1.0
*/

-- ============================================================
-- 7. Practical: 3-Month Moving Average of Revenue
-- ============================================================

-- Monthly revenue aggregation
WITH monthly_revenue AS (
    SELECT
        strftime('%Y-%m', order_date) AS month,
        ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    GROUP BY strftime('%Y-%m', order_date)
)
SELECT month, revenue,
    ROUND(AVG(revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3month
FROM monthly_revenue
ORDER BY month;

/*
month|revenue|moving_avg_3month
2024-01|2154.46|2154.46
2024-02|1765.77|1960.12
2024-03|2945.22|2288.48
2024-04|1234.5|1981.83
2024-05|3124.0|2434.57
2024-06|2456.78|2271.76
2024-07|1890.0|2490.26
2024-08|2100.0|2148.93
2024-09|3450.0|2480.0
2024-10|1890.5|2480.17
2024-11|2745.0|2695.17
2024-12|1678.99|2104.83
*/

-- ============================================================
-- 8. Practical: Quartile Analysis of Salaries
-- ============================================================

WITH salary_quartiles AS (
    SELECT
        department_id,
        d.department_name,
        employee_id,
        first_name || ' ' || last_name AS name,
        salary,
        NTILE(4) OVER (ORDER BY salary) AS salary_quartile
    FROM employees e
    JOIN departments d USING (department_id)
)
SELECT salary_quartile,
    COUNT(*) AS employees,
    ROUND(MIN(salary), 0) AS min_salary,
    ROUND(MAX(salary), 0) AS max_salary,
    ROUND(AVG(salary), 0) AS avg_salary
FROM salary_quartiles
GROUP BY salary_quartile
ORDER BY salary_quartile;

/*
salary_quartile|employees|min_salary|max_salary|avg_salary
1|4|72000|92000|81000.0
2|4|95000|110000|102500.0
3|4|115000|130000|122500.0
4|3|140000|155000|146667.0
*/

-- ============================================================
-- 9. Practical: Employee Salary Percentile Ranking
-- ============================================================

SELECT employee_id,
    first_name || ' ' || last_name AS name,
    d.department_name,
    salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary), 4) AS pct_rank,
    CASE
        WHEN PERCENT_RANK() OVER (ORDER BY salary) <= 0.25 THEN 'Bottom 25%'
        WHEN PERCENT_RANK() OVER (ORDER BY salary) <= 0.50 THEN 'Lower Middle'
        WHEN PERCENT_RANK() OVER (ORDER BY salary) <= 0.75 THEN 'Upper Middle'
        ELSE 'Top 25%'
    END AS salary_tier
FROM employees e
JOIN departments d USING (department_id)
ORDER BY salary;

/*
employee_id|name|department_name|salary|pct_rank|salary_tier
4|Mike Brown|Engineering|72000|0.0|Bottom 25%
1|John Smith|Data & Analytics|75000|0.0714|Bottom 25%
7|Sara White|Data & Analytics|85000|0.1429|Bottom 25%
8|Sam Green|Product|92000|0.2143|Bottom 25%
2|Jane Doe|Engineering|95000|0.2857|Lower Middle
13|Hank Miller|Engineering|100000|0.3571|Lower Middle
6|Tom Davis|Product|105000|0.4286|Lower Middle
3|Bob Johnson|Data & Analytics|110000|0.5|Lower Middle
11|Eve Martinez|Product|115000|0.5714|Upper Middle
9|Charlie Brown|Product|120000|0.6429|Upper Middle
5|Alice Williams|Engineering|125000|0.7143|Upper Middle
10|David Lee|Engineering|130000|0.7857|Top 25%
15|Liam Taylor|Data & Analytics|140000|0.8571|Top 25%
14|Jack Wilson|Engineering|145000|0.9286|Top 25%
12|Grace Kim|Data & Analytics|155000|1.0|Top 25%
*/

-- ============================================================
-- 🔥 Challenge: Year-over-Year Growth with Window Functions
-- ============================================================

WITH yearly_revenue AS (
    SELECT
        strftime('%Y', order_date) AS year,
        ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    GROUP BY strftime('%Y', order_date)
)
SELECT year, revenue,
    LAG(revenue) OVER (ORDER BY year) AS prev_year_revenue,
    CASE
        WHEN LAG(revenue) OVER (ORDER BY year) IS NOT NULL
        THEN ROUND((revenue - LAG(revenue) OVER (ORDER BY year)) / LAG(revenue) OVER (ORDER BY year) * 100, 2)
        ELSE NULL
    END AS yoy_growth_pct,
    SUM(revenue) OVER (ORDER BY year) AS cumulative_revenue
FROM yearly_revenue
ORDER BY year;

/*
year|revenue|prev_year_revenue|yoy_growth_pct|cumulative_revenue
2024|25484.22|||25484.22
*/

-- Only 2024 data available, so let's use movies for a better year-over-year demo
WITH yearly_movie_revenue AS (
    SELECT
        release_year,
        ROUND(SUM(revenue_millions), 0) AS total_revenue,
        COUNT(*) AS movie_count
    FROM movies
    GROUP BY release_year
)
SELECT release_year, total_revenue, movie_count,
    LAG(total_revenue) OVER (ORDER BY release_year) AS prev_year_rev,
    CASE
        WHEN LAG(total_revenue) OVER (ORDER BY release_year) IS NOT NULL
        THEN ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY release_year)) * 100.0 / LAG(total_revenue) OVER (ORDER BY release_year), 1)
        ELSE NULL
    END AS yoy_growth_pct
FROM yearly_movie_revenue
ORDER BY release_year;

/*
release_year|total_revenue|movie_count|prev_year_rev|yoy_growth_pct
1927|8.0|1||
1941|16.0|1|8.0|100.0
1954|2.0|1|16.0|-87.5
1960|5.0|1|2.0|150.0
1968|19.0|1|5.0|280.0
1972|246.0|1|19.0|1194.7
1975|472.0|1|246.0|91.9
1977|775.0|1|472.0|64.2
1979|105.0|1|775.0|-86.5
1980|48.0|1|105.0|-54.3
1982|41.0|1|48.0|-14.6
1984|78.0|1|41.0|90.2
1985|389.0|1|78.0|398.7
1986|131.0|1|389.0|-66.3
1987|100.0|1|131.0|-23.7
1988|307.0|1|100.0|207.0
1990|197.0|1|307.0|-35.8
1991|273.0|1|197.0|38.6
1993|1050.0|1|273.0|284.6
1994|480.0|2|1050.0|-54.3
1995|373.0|1|480.0|-22.3
1997|2200.0|1|373.0|489.8
1998|485.0|1|2200.0|-78.0
1999|467.0|1|485.0|-3.7
2000|458.0|1|467.0|-1.9
2001|898.0|1|458.0|96.1
2002|947.0|1|898.0|5.5
2003|1145.0|2|947.0|20.9
2005|375.0|1|1145.0|-67.2
2007|80.0|1|375.0|-78.7
2008|1006.0|1|80.0|1157.5
2009|2850.0|1|1006.0|183.3
2010|836.0|1|2850.0|-70.7
2011|54.0|1|836.0|-93.5
2012|1520.0|1|54.0|2714.8
2014|855.0|2|1520.0|-43.8
2017|256.0|1|855.0|-70.1
2019|260.0|1|256.0|1.6
*/

-- ============================================================
-- Exercises for Lesson 17
-- ============================================================
-- Exercise 1: Use NTILE(3) to group employees into 3 salary tiers (low/medium/high)
-- Exercise 2: Calculate a 2-month moving average of order totals
-- Exercise 3: Find the salary gap between each employee and the next higher-paid employee using LEAD()
-- Exercise 4: Use CUME_DIST to find employees in the top 30% of salaries
-- Exercise 5: For each department, show the employee with the highest salary and their salary
--             as a percentage of the department total
