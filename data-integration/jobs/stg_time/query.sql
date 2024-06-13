truncate table  stg.time;
WITH RECURSIVE date_range AS (
    SELECT
        DATE '2020-01-01' AS date
    UNION ALL
    SELECT
        (date + INTERVAL '1 day')::DATE
    FROM
        date_range
    WHERE
        date < DATE '2025-12-31'
)
INSERT INTO stg.time (date, year, quarter, month, day, day_of_week, day_name, week_of_year, is_weekend)
SELECT
    date,
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(QUARTER FROM date) AS quarter,
    EXTRACT(MONTH FROM date) AS month,
    EXTRACT(DAY FROM date) AS day,
    EXTRACT(DOW FROM date) + 1 AS day_of_week,
    TO_CHAR(date, 'Day') AS day_name,
    EXTRACT(WEEK FROM date) AS week_of_year,
    CASE WHEN EXTRACT(DOW FROM date) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend
FROM
    date_range
ORDER BY date