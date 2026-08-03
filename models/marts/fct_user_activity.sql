WITH users AS (
    SELECT * FROM {{ref('stg_users')}}
),

session_metrics AS (
    SELECT * FROM {{ref('int_session_metrics')}}
)

SELECT
    -- User Dimensions
    u.user_id,
    u.age,
    u.gender,
    u.region,
    u.department,
    u.is_active,
    -- Session & Activity Facts
    sm.session_id,
    sm.session_start_at,
    sm.device_type,
    sm.session_duration_minutes,
    sm.total_event_in_session,
    sm.upload_intent_clicks,
    sm.appointment_clicks
FROM session_metrics AS sm
INNER JOIN users AS u 
    ON sm.user_id = u.user_id
