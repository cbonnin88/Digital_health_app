-- Funnel Conversion
-- Track the drop-off rate from Login -> Dashboard -> Upload Click
WITH session_events AS (
  SELECT
    session_id,
    COUNT(CASE WHEN event_type = 'login' THEN 1 END) AS logged_in,
    COUNT(CASE WHEN event_type = 'view_dashboard' THEN 1 END) AS viewed_dashboard,
    COUNT(CASE WHEN event_type = 'click_upload' THEN 1 END) AS clicked_upload
  FROM `product-analytics-494706.dbt_health_app.stg_events`
  GROUP BY
    session_id
)

SELECT
  COUNT(DISTINCT CASE WHEN logged_in > 0 THEN session_id END) as step_1_logins,
  COUNT(DISTINCT CASE WHEN viewed_dashboard > 0 THEN session_id END) AS step_2_dashboard,
  COUNT(DISTINCT CASE WHEN clicked_upload > 0 THEN session_id END) AS step_3_upload_clicks,
  ROUND(
    COUNT(DISTINCT CASE WHEN clicked_upload > 0 THEN session_id END) /
    NULLIF(COUNT(DISTINCT CASE WHEN logged_in > 0 THEN session_id END),0)*100,2
  ) AS funnel_conversion_rate_pct
FROM session_events;