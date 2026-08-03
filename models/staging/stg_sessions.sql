WITH raw_sessions AS (
    SELECT * FROM {{source('digital_health_app_raw','sessions')}}
)

SELECT
    CAST(session_id AS INT64) AS session_id,
    CAST(user_id AS INT64) AS user_id,
    CAST(session_start_at AS TIMESTAMP) AS session_start_at,
    CAST(session_end_at AS TIMESTAMP) AS session_end_at,
    CAST(device_type AS STRING) AS device_type
FROM raw_sessions