SELECT
  f.user_id,
  -- String function to format the name
  CONCAT(UPPER(u.last_name), ' , ', u.first_name) AS full_name,
  COUNT(d.document_id) AS total_documents_uploaded,
  -- Categorical Calssification
  CASE
    WHEN COUNT(d.document_id) >= 10 THEN 'Power User'
    WHEN COUNT(d.document_id) BETWEEN 1 AND 9 THEN 'Casual User'
    ELSE 'Inactive Uploader'
  END AS usage_tier
FROM `product-analytics-494706.dbt_health_app.fct_user_activity` AS f
-- Connecting the user facts with raw users for names
INNER JOIN `product-analytics-494706.dbt_health_app.stg_users` AS u
  ON f.user_id = u.user_id
LEFT JOIN `product-analytics-494706.dbt_health_app.sgt_documents` AS d
  ON f.user_id = d.user_id
GROUP BY
  f.user_id,
  full_name
HAVING total_documents_uploaded > 0
ORDER BY
  total_documents_uploaded DESC;