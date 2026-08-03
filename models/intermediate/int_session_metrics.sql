WITH sessions AS (
    SELECT * FROM {{ref('stg_sessions')}}
),

events AS (
    SELECT * FROM {{ref('stg_events')}}
),

-- Aggreaget event data at the session level
aggregated_events AS (
    SELECT
        session_id,
        COUNT(event_id) AS total_events_in_session,
        -- creating custom flags for specific high-value product actions
        COUNT(CASE WHEN event_type = 'click_upload' THEN 1 END) AS upload_intent_clicks,
        COUNT(CASE WHEn event_type = 'book_appointment' THEN 1 END) AS appointment_clicks
    FROM events
    GROUP BY
        session_id
)

-- Join the aggreations back to the base session details
SELECT
    s.session_id,
    s.user_id,
    s.session_start_at,
    s.session_end_at,
    s.device_type,
    TIMESTAMP_DIFF(s.session_end_at,s.session_start_at, MINUTE) AS session_duration_minutes,
    COALESCE(ae.total_events_in_session,0) AS total_event_in_session,
    COALESCE(ae.upload_intent_clicks,0) AS upload_intent_clicks,
    COALESCE(ae.appointment_clicks,0) AS appointment_clicks
FROM sessions AS s
LEFT JOIN aggregated_events AS ae
    ON s.session_id = ae.session_id