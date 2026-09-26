- ============================================================
-- Weather ETLT Pipeline: In-Database Transformations & Modeling
-- Description: Creating analytical views using Window Functions
-- ============================================================

-- 1. Full Analytical View for Riyadh
CREATE VIEW riyadh_full_analysis AS
WITH temp_lag AS (
    SELECT time, celsius,
           LAG(celsius) OVER (ORDER BY time) AS prev_temperature
    FROM weather_riyadh
),
humidity_lag AS (
    SELECT time, relative_humidity_2m,
           LAG(relative_humidity_2m) OVER (ORDER BY time) AS prev_humidity
    FROM weather_riyadh
),
temp_rank_overall AS (
    SELECT time, celsius,
           DENSE_RANK() OVER (ORDER BY celsius DESC) AS rnk
    FROM weather_riyadh
),
humidity_rank_overall AS (
    SELECT time, relative_humidity_2m,
           DENSE_RANK() OVER (ORDER BY relative_humidity_2m DESC) AS rnk
    FROM weather_riyadh
),
temp_rank_daily AS (
    SELECT time, celsius,
           DENSE_RANK() OVER (PARTITION BY DATE(time) ORDER BY celsius DESC) AS rnk
    FROM weather_riyadh
),
humidity_rank_daily AS (
    SELECT time, relative_humidity_2m,
           DENSE_RANK() OVER (PARTITION BY DATE(time) ORDER BY relative_humidity_2m DESC) AS rnk
    FROM weather_riyadh
)
SELECT tl.time, tl.celsius, tl.prev_temperature,
       hl.relative_humidity_2m, hl.prev_humidity,
       tro.rnk AS temp_rank_overall,
       hro.rnk AS humidity_rank_overall,
       trd.rnk AS temp_rank_daily,
       hrd.rnk AS humidity_rank_daily
FROM temp_lag tl
JOIN humidity_lag hl ON tl.time = hl.time
JOIN temp_rank_overall tro ON tl.time = tro.time
JOIN humidity_rank_overall hro ON tl.time = hro.time
JOIN temp_rank_daily trd ON tl.time = trd.time
JOIN humidity_rank_daily hrd ON tl.time = hrd.time;

-- 2. Full Analytical View for Jeddah
CREATE VIEW jeddah_full_analysis AS
WITH temp_lag AS (
    SELECT time, celsius,
           LAG(celsius) OVER (ORDER BY time) AS prev_temperature
    FROM weather_jeddah
),
humidity_lag AS (
    SELECT time, relative_humidity_2m,
           LAG(relative_humidity_2m) OVER (ORDER BY time) AS prev_humidity
    FROM weather_jeddah
),
temp_rank_overall AS (
    SELECT time, celsius,
           DENSE_RANK() OVER (ORDER BY celsius DESC) AS rnk
    FROM weather_jeddah
),
humidity_rank_overall AS (
    SELECT time, relative_humidity_2m,
           DENSE_RANK() OVER (ORDER BY relative_humidity_2m DESC) AS rnk
    FROM weather_jeddah
),
temp_rank_daily AS (
    SELECT time, celsius,
           DENSE_RANK() OVER (PARTITION BY DATE(time) ORDER BY celsius DESC) AS rnk
    FROM weather_jeddah
),
humidity_rank_daily AS (
    SELECT time, relative_humidity_2m,
           DENSE_RANK() OVER (PARTITION BY DATE(time) ORDER BY relative_humidity_2m DESC) AS rnk
    FROM weather_jeddah
)
SELECT tl.time, tl.celsius, tl.prev_temperature,
       hl.relative_humidity_2m, hl.prev_humidity,
       tro.rnk AS temp_rank_overall,
       hro.rnk AS humidity_rank_overall,
       trd.rnk AS temp_rank_daily,
       hrd.rnk AS humidity_rank_daily
FROM temp_lag tl
JOIN humidity_lag hl ON tl.time = hl.time
JOIN temp_rank_overall tro ON tl.time = tro.time
JOIN humidity_rank_overall hro ON tl.time = hro.time
JOIN temp_rank_daily trd ON tl.time = trd.time
JOIN humidity_rank_daily hrd ON tl.time = hrd.time;

-- 3. Daily Summary View
CREATE VIEW weather_daily_summary AS
WITH riyadh_daily AS (
    SELECT DATE(time) AS day,
           AVG(celsius) AS riyadh_avg_temp,
           AVG(relative_humidity_2m) AS riyadh_avg_humidity
    FROM weather_riyadh
    GROUP BY DATE(time)
),
jeddah_daily AS (
    SELECT DATE(time) AS day,
           AVG(celsius) AS jeddah_avg_temp,
           AVG(relative_humidity_2m) AS jeddah_avg_humidity
    FROM weather_jeddah
    GROUP BY DATE(time)
)
SELECT r.day, r.riyadh_avg_temp, r.riyadh_avg_humidity,
       j.jeddah_avg_temp, j.jeddah_avg_humidity
FROM riyadh_daily r
JOIN jeddah_daily j ON r.day = j.day;

-- 4. Hourly City Comparison View
CREATE VIEW weather_comparison AS
SELECT r.time, 
       r.celsius AS riyadh_temp, 
       j.celsius AS jeddah_temp,
       r.relative_humidity_2m AS riyadh_humidity, 
       j.relative_humidity_2m AS jeddah_humidity
FROM weather_riyadh r
JOIN weather_jeddah j ON r.time = j.time;