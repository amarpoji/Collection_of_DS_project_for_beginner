# Project 3: Movie Database Insights

## Scenario

You work as a data analyst at a film production company. Your executive team is evaluating which genres, directors, and studios to invest in for the upcoming fiscal year. You've been given a dataset of 40 movies spanning 5 decades. Your task is to uncover actionable insights: which genres have the best ROI, which directors consistently deliver, which decades produced the highest-quality films, and where the best and worst investments lie.

This is an **intermediate-level** project focused on statistical aggregation, window functions, and business-oriented analysis.

## Datasets Used

| Table | Rows | Description |
|-------|------|-------------|
| `movies` | 40 | Movie attributes (title, genre, year, rating, duration, director, studio, budget, revenue) |

## Prerequisites

- GROUP BY with multiple aggregate functions
- Window functions: ROW_NUMBER, RANK
- Derived calculations (ROI, profit)
- CASE expressions for bucketing

---

## Step-by-Step Tasks

---

### Task 1: Top-Rated Movies Per Genre

**Objective:** Find the single highest-rated movie in each genre.

**Hint:** Use `ROW_NUMBER() OVER (PARTITION BY genre ORDER BY rating DESC)` in a subquery, then filter for rank = 1.

**Query:**
```sql
SELECT
  genre,
  title,
  rating,
  release_year,
  revenue_millions
FROM (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY genre
      ORDER BY rating DESC
    ) AS rank_in_genre
  FROM movies
) ranked
WHERE rank_in_genre = 1
ORDER BY genre;
```

**Expected Output:**

| genre | title | rating | release_year | revenue_millions |
|-------|-------|--------|-------------|-----------------|
| Action | The Dark Knight | 9.0 | 2008 | 1005 |
| Animation | Spirited Away | 8.6 | 2001 | 395 |
| Comedy | The Grand Budapest Hotel | 8.1 | 2014 | 173 |
| Crime | The Godfather | 9.2 | 1972 | 246 |
| Drama | The Shawshank Redemption | 9.3 | 1994 | 73 |
| Horror | Get Out | 7.7 | 2017 | 255 |
| Musical | La La Land | 8.0 | 2016 | 447 |
| Mystery | The Prestige | 8.5 | 2006 | 109 |
| Sci-Fi | Inception | 8.8 | 2010 | 836 |
| Thriller | Parasite | 8.5 | 2019 | 258 |
| War | 1917 | 8.3 | 2019 | 385 |

**Business Insight:** Drama leads with the highest rating (9.3 - The Shawshank Redemption), but Sci-Fi generates the most revenue among top-rated films (Inception at $836M). Horror's top film (Get Out) had a tiny budget ($4.5M) with huge returns — a pattern worth exploring.

---

### Task 2: ROI Analysis (Revenue vs Budget by Genre and Director)

**Objective:** Calculate Return on Investment (ROI) as `(revenue - budget) / budget` and compare across genres. Also identify the most profitable directors.

**Query (by genre):**
```sql
SELECT
  genre,
  COUNT(*) AS movie_count,
  ROUND(AVG((revenue_millions - budget_millions) / budget_millions), 2) AS avg_roi,
  ROUND(SUM(revenue_millions), 1) AS total_revenue,
  ROUND(SUM(budget_millions), 1) AS total_budget,
  ROUND(SUM(revenue_millions - budget_millions), 1) AS total_profit
FROM movies
GROUP BY genre
ORDER BY avg_roi DESC;
```

**Expected Output (by genre):**

| genre | movie_count | avg_roi | total_revenue | total_budget | total_profit |
|-------|-------------|---------|---------------|--------------|--------------|
| Horror | 2 | 37.36 | 596.0 | 21.5 | 574.5 |
| Thriller | 1 | 22.45 | 258.0 | 11.0 | 247.0 |
| Animation | 7 | 18.87 | 3635.0 | 631.5 | 3003.5 |
| Crime | 5 | 17.45 | 1871.0 | 184.0 | 1687.0 |
| Musical | 1 | 13.90 | 447.0 | 30.0 | 417.0 |
| Drama | 6 | 5.95 | 1388.0 | 246.3 | 1141.7 |
| Comedy | 1 | 5.92 | 173.0 | 25.0 | 148.0 |
| Action | 5 | 5.73 | 5236.0 | 921.0 | 4315.0 |
| Mystery | 2 | 3.74 | 716.0 | 160.0 | 556.0 |
| Sci-Fi | 8 | 3.46 | 3122.0 | 825.0 | 2297.0 |
| War | 1 | 3.05 | 385.0 | 95.0 | 290.0 |

**Key Insight:** Horror has the highest average ROI (37x!) because movies like Get Out cost almost nothing to produce. Action generates the most total profit ($4.3B) despite modest average ROI. Animation is a reliable high-ROI category.

---

### Task 3: Year-over-Year Trends in Ratings and Revenue

**Objective:** Track how average ratings and total revenue changed year by year.

**Hint:** Aggregate by `release_year` and use `LAG()` to compute year-over-year changes.

**Query:**
```sql
WITH yearly_stats AS (
  SELECT
    release_year,
    COUNT(*) AS movie_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(SUM(revenue_millions), 1) AS total_revenue
  FROM movies
  GROUP BY release_year
)
SELECT
  release_year,
  movie_count,
  avg_rating,
  ROUND(avg_rating - LAG(avg_rating) OVER (ORDER BY release_year), 2) AS rating_change,
  total_revenue,
  ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY release_year)) * 100.0 /
    LAG(total_revenue) OVER (ORDER BY release_year), 1) AS revenue_growth_pct
FROM yearly_stats
ORDER BY release_year;
```

**Expected Output (sample):**

| release_year | movie_count | avg_rating | rating_change | total_revenue | revenue_growth_% |
|-------------|-------------|------------|--------------|---------------|-----------------|
| 1972 | 1 | 9.20 | NULL | 246.0 | NULL |
| 1993 | 1 | 8.20 | ... | 1057.0 | ... |
| 1994 | 4 | 8.88 | +0.68 | 1931.0 | +82.7% |
| 2019 | 4 | 8.28 | ... | 2029.0 | ... |
| 2022 | 2 | 7.80 | -0.48 | 915.0 | -54.9% |

**Business Insight:** The 1990s was a golden era for quality (1994 avg rating 8.88 with 4 movies). There's a slight downward trend in average ratings in recent years (2020s avg 7.78), though revenue remains strong.

---

### Task 4: Director Analysis — Who Makes the Most Profitable Movies

**Objective:** Identify the directors with the highest total profit and best average ROI.

**Query:**
```sql
SELECT
  director,
  COUNT(*) AS movie_count,
  ROUND(AVG(rating), 2) AS avg_rating,
  ROUND(SUM(revenue_millions - budget_millions), 1) AS total_profit,
  ROUND(AVG(revenue_millions - budget_millions), 1) AS avg_profit_per_movie,
  ROUND(AVG((revenue_millions - budget_millions) / budget_millions), 2) AS avg_roi
FROM movies
GROUP BY director
ORDER BY total_profit DESC
LIMIT 10;
```

**Expected Output:**

| director | movie_count | avg_rating | total_profit | avg_profit_per_movie | avg_roi |
|----------|-------------|------------|-------------|---------------------|---------|
| Christopher Nolan | 5 | 8.44 | 2266.0 | 453.2 | 2.89 |
| Joss Whedon | 1 | 8.00 | 1299.0 | 1299.0 | 5.90 |
| Todd Phillips | 1 | 8.40 | 1019.0 | 1019.0 | 18.53 |
| Steven Spielberg | 1 | 8.20 | 994.0 | 994.0 | 15.78 |
| Roger Allers | 1 | 8.50 | 923.0 | 923.0 | 20.51 |
| Lee Unkrich | 1 | 8.40 | 639.0 | 639.0 | 3.65 |
| Robert Zemeckis | 1 | 8.80 | 622.0 | 622.0 | 11.31 |
| Matt Reeves | 1 | 7.80 | 572.0 | 572.0 | 2.86 |
| Brad Bird | 1 | 8.00 | 541.0 | 541.0 | 5.88 |
| Ron Clements | 1 | 7.60 | 493.0 | 493.0 | 3.29 |

**Business Insight:** Christopher Nolan is the most valuable director overall — 5 movies with $2.3B total profit and consistently high ratings (avg 8.44). Todd Phillips had the best ROI (18.53x) with Joker. Directors with only 1 film may show inflated metrics.

---

### Task 5: Runtime Analysis — Correlation with Rating

**Objective:** Bucket movies by runtime and see if longer or shorter films tend to have higher ratings.

**Hint:** Use `CASE` to create runtime buckets: <100 min, 100-129 min, 130-159 min, 160+ min.

**Query:**
```sql
SELECT
  CASE
    WHEN duration_min < 100 THEN '< 100 min (Short)'
    WHEN duration_min BETWEEN 100 AND 129 THEN '100-129 min (Standard)'
    WHEN duration_min BETWEEN 130 AND 159 THEN '130-159 min (Long)'
    ELSE '160+ min (Epic)'
  END AS runtime_category,
  COUNT(*) AS movie_count,
  ROUND(AVG(rating), 2) AS avg_rating,
  ROUND(AVG(revenue_millions), 1) AS avg_revenue,
  ROUND(AVG(duration_min), 0) AS avg_duration
FROM movies
GROUP BY runtime_category
ORDER BY avg_rating DESC;
```

**Expected Output:**

| runtime_category | movie_count | avg_rating | avg_revenue | avg_duration |
|------------------|-------------|------------|-------------|--------------|
| 160+ min (Epic) | 3 | 8.53 | 573.0 | 167 |
| 130-159 min (Long) | 18 | 8.46 | 423.4 | 142 |
| 100-129 min (Standard) | 16 | 8.09 | 437.8 | 116 |
| < 100 min (Short) | 3 | 8.03 | 494.0 | 94 |

**Business Insight:** There's a positive correlation between runtime and rating — longer movies (130+ min) tend to score higher. However, short and standard-length films still generate strong revenue. This suggests that quality storytelling, not just length, drives ratings.

---

### Task 6: Studio Performance Comparison

**Objective:** Rank film studios by total profit, average rating, and ROI to determine which studio is the best investment partner.

**Query:**
```sql
SELECT
  studio,
  COUNT(*) AS movie_count,
  ROUND(AVG(rating), 2) AS avg_rating,
  ROUND(SUM(revenue_millions), 1) AS total_revenue,
  ROUND(SUM(budget_millions), 1) AS total_budget,
  ROUND(SUM(revenue_millions - budget_millions), 1) AS total_profit,
  ROUND(AVG((revenue_millions - budget_millions) / budget_millions), 2) AS avg_roi
FROM movies
GROUP BY studio
ORDER BY total_profit DESC;
```

**Expected Output:**

| studio | movie_count | avg_rating | total_revenue | total_budget | total_profit | avg_roi |
|--------|-------------|------------|---------------|--------------|-------------|---------|
| Warner Bros | 11 | 8.35 | 5131.0 | 1385.0 | 3746.0 | 4.10 |
| Paramount | 7 | 8.34 | 2490.0 | 477.0 | 2013.0 | 11.86 |
| Universal | 4 | 8.18 | 2097.5 | 219.5 | 1878.0 | 19.60 |
| Disney | 2 | 8.05 | 1611.0 | 195.0 | 1416.0 | 11.90 |
| Marvel | 1 | 8.00 | 1519.0 | 220.0 | 1299.0 | 5.90 |
| Pixar | 3 | 8.13 | 1589.0 | 417.0 | 1172.0 | 3.16 |

**Business Insight:** Warner Bros dominates in total profit ($3.7B) and has the most movies (11). However, Universal has the best average ROI (19.6x) despite fewer films. Studio Ghibli shows the highest ROI per movie (49.4x) due to extremely low budgets.

---

### Task 7: Identify the Best and Worst Investments

**Objective:** Find which movies had the highest and lowest ROI to learn what makes a good investment.

**Query (Best Investments):**
```sql
SELECT
  title,
  genre,
  release_year,
  budget_millions,
  revenue_millions,
  ROUND((revenue_millions - budget_millions) / budget_millions, 2) AS roi,
  ROUND(revenue_millions - budget_millions, 1) AS profit_millions
FROM movies
ORDER BY roi DESC
LIMIT 5;
```

**Expected Output — Best Investments:**

| title | genre | release_year | budget_millions | revenue_millions | roi | profit_millions |
|-------|-------|-------------|----------------|------------------|-----|----------------|
| Whisper of the Heart | Animation | 1995 | 0.5 | 40.0 | 79.00 | 39.5 |
| Get Out | Horror | 2017 | 4.5 | 255.0 | 55.67 | 250.5 |
| The Godfather | Crime | 1972 | 6.0 | 246.0 | 40.00 | 240.0 |
| Pulp Fiction | Crime | 1994 | 8.0 | 213.0 | 25.63 | 205.0 |
| Parasite | Thriller | 2019 | 11.0 | 258.0 | 22.45 | 247.0 |

**Query (Worst Investments):**
```sql
SELECT
  title,
  genre,
  release_year,
  budget_millions,
  revenue_millions,
  ROUND((revenue_millions - budget_millions) / budget_millions, 2) AS roi,
  ROUND(revenue_millions - budget_millions, 1) AS profit_millions
FROM movies
ORDER BY roi ASC
LIMIT 5;
```

**Expected Output — Worst Investments:**

| title | genre | release_year | budget_millions | revenue_millions | roi | profit_millions |
|-------|-------|-------------|----------------|------------------|-----|----------------|
| Soul | Animation | 2020 | 150.0 | 142.0 | -0.05 | -8.0 |
| Fight Club | Drama | 1999 | 63.0 | 101.0 | 0.60 | 38.0 |
| Tenet | Sci-Fi | 2020 | 200.0 | 365.0 | 0.82 | 165.0 |
| Goodfellas | Crime | 1990 | 25.0 | 47.0 | 0.88 | 22.0 |
| Dune | Sci-Fi | 2021 | 165.0 | 407.0 | 1.47 | 242.0 |

**Business Insight:** The best investments share a common pattern: low budget, high cultural impact, and strong word-of-mouth. The worst investments are typically big-budget films that underperformed relative to their cost. Notably, even "worst" investments like Dune still turned a profit — just not proportionally to their budget.

---

### Task 8: Find Decades with Highest Average Ratings

**Objective:** Aggregate movies by decade to see which era produced the highest quality films on average.

**Hint:** Calculate decade using integer division: `(release_year / 10) * 10`.

**Query:**
```sql
SELECT
  ((release_year / 10) * 10) || 's' AS decade,
  COUNT(*) AS movie_count,
  ROUND(AVG(rating), 2) AS avg_rating,
  ROUND(MAX(rating), 2) AS highest_rated,
  ROUND(MIN(rating), 2) AS lowest_rated,
  ROUND(AVG(revenue_millions), 1) AS avg_revenue,
  ROUND(AVG(budget_millions), 1) AS avg_budget,
  ROUND(AVG((revenue_millions - budget_millions) / budget_millions), 2) AS avg_roi
FROM movies
GROUP BY decade
ORDER BY avg_rating DESC;
```

**Expected Output:**

| decade | movie_count | avg_rating | highest | lowest | avg_revenue | avg_budget | avg_roi |
|--------|-------------|------------|---------|--------|-------------|------------|---------|
| 1970s | 1 | 9.20 | 9.2 | 9.2 | 246.0 | 6.0 | 40.00 |
| 1990s | 10 | 8.60 | 9.3 | 7.9 | 390.7 | 30.2 | 14.31 |
| 2000s | 6 | 8.52 | 9.0 | 8.0 | 489.3 | 83.2 | 7.97 |
| 2010s | 18 | 8.12 | 8.5 | 7.5 | 494.9 | 79.7 | 15.44 |
| 2020s | 5 | 7.78 | 8.0 | 7.3 | 365.8 | 148.0 | 1.95 |

**Business Insight:** The 1970s had the single highest-rated film (The Godfather, 9.2), but the 1990s was the best decade overall — highest average rating (8.60) across 10 movies with excellent ROI (14.31x). The 2020s show a concerning trend: declining average ratings and significantly lower ROI (1.95x) combined with the highest average budgets ($148M), suggesting blockbuster spending isn't translating to quality or proportional returns.

---

## Bonus Challenge

**Question:** Which directors have the most consistent track record (lowest variance in ratings across their films)?

```sql
WITH director_stats AS (
  SELECT
    director,
    COUNT(*) AS movie_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(SQRT(AVG(rating * rating) - AVG(rating) * AVG(rating)), 3) AS rating_stddev
  FROM movies
  GROUP BY director
  HAVING COUNT(*) >= 2
)
SELECT
  director,
  movie_count,
  avg_rating,
  rating_stddev
FROM director_stats
ORDER BY rating_stddev ASC;
```

## Learning Outcomes

- Complex aggregations with multiple metrics
- Window functions: `ROW_NUMBER`, `LAG`
- Financial calculations: ROI, profit
- Data bucketing with `CASE` expressions
- Decade/cohort analysis via integer division
- Statistical measures: average, min, max
- Business interpretation of entertainment industry data
