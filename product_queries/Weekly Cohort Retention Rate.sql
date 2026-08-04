-- Weekly Cohort Retention Rate
-- Calculate what percentage of users return in the weeks following their first session.

WITH user_cohorts AS (
  SELECT
    user_id,
    DATE_TRUNC(DATE(MIN(session_start_at)),WEEK) AS cohort_week
  FROM `product-analytics-494706.dbt_health_app.fct_user_activity`
  GROUP BY
    user_id
),
user_activity AS (
  SELECT DISTINCT
    user_id,
    DATE_TRUNC(DATE(session_start_at),WEEK) AS activity_week
  FROM `product-analytics-494706.dbt_health_app.fct_user_activity`
),

cohort_sizes AS (
  SELECT
    cohort_week,
    COUNT(DISTINCT user_id) AS cohort_size
  FROM user_cohorts
  GROUP BY
    user_cohorts.cohort_week
),

retention_data AS (
  SELECT
    c.cohort_week,
    s.cohort_size,
    DATE_DIFF(a.activity_week,c.cohort_week,WEEK) AS weeks_since_first_visit,
    COUNT(DISTINCT a.user_id) AS active_users
  FROM user_cohorts AS c
  INNER JOIN user_activity AS a
    ON c.user_id = a.user_id
  INNER JOIN cohort_sizes AS s
    ON c.cohort_week = s.cohort_week
  GROUP BY
    c.cohort_week,
    s.cohort_size,
    weeks_since_first_visit
)

SELECT
  cohort_week,
  cohort_size,
  retention_data.weeks_since_first_visit,
  active_users,
  ROUND((active_users/ cohort_size)*100,2) AS retention_rate_pct
FROM retention_data
WHERE weeks_since_first_visit <=4
ORDER BY
  cohort_week DESC,
  weeks_since_first_visit;
