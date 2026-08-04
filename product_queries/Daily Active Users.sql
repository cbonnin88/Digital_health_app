-- Daily Active Users (DAU)
-- Calculate the total number of unique users interacting with the app per day.
SELECT
  DATE(session_start_at) AS activity_date,
  COUNT(DISTINCT user_id) AS daily_active_users  
FROM `product-analytics-494706.dbt_health_app.fct_user_activity`
GROUP BY
  activity_date
ORDER BY
  activity_date DESC;