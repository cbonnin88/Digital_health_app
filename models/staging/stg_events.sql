WITH raw_events AS (
    SELECT * FROM {{source('digital_health_app_raw','events')}}
)

SELECT
    CAST(event_id AS INT64) AS event_id,
    CAST(session_id AS INT64) AS session_id,
    CAST(event_type AS STRING) AS event_type,
    CAST(event_timestamp AS TIMESTAMP) AS event_timestamp
FROM raw_events