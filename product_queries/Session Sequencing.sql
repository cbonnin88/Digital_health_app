WITH SessionSequences AS (
  SELECT
    user_id,
    session_id,
    session_start_at,
    -- Rank sesison chronologically per user
    ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY session_start_at) AS session_number,
    -- Grabbing teh timestamp of the previous session
    LAG(session_start_at) OVER(PARTITION BY user_id ORDER BY session_start_at) AS previous_session_time
  FROM `product-analytics-494706.dbt_health_app.fct_user_activity`
)

SELECT
  user_id,
  session_id,
  session_number,
  session_start_at,
  previous_session_time,
  -- Calculate difference in days
  TIMESTAMP_DIFF(session_start_at,previous_session_time, DAY) as days_since_last_session
FROM SessionSequences
WHERE session_number <= 5
ORDER BY
  user_id,
  session_number;