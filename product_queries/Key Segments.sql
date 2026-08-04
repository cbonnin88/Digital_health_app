SELECT
  DISTINCT user_id,
  'Uploaded Prescription' AS segment_reason
FROM `product-analytics-494706.dbt_health_app.sgt_documents`
WHERE document_type = 'Ordonnance'

UNION DISTINCT

SELECT
  DISTINCT user_id,
  'Booked Appointment' AS segment_reason
FROM `product-analytics-494706.dbt_health_app.fct_user_activity`
WHERE user_id IN (
  SELECT
    user_id
  FROM `product-analytics-494706.dbt_health_app.fct_user_activity`
  WHERE appointment_clicks >0
);