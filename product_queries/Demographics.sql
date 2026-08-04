-- The top five regions by average age of active users, skipping the top 1.
SELECT
  region,
  COUNT(user_id) AS total_active_users,
  ROUND(AVG(age),1) AS average_age  
FROM `product-analytics-494706.dbt_health_app.fct_user_activity`
WHERE is_active = TRUE
GROUP BY
  region
ORDER BY
  total_active_users DESC
LIMIT 5
OFFSET 1;