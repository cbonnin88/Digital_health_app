WITH raw_users AS (
    SELECT * FROM {{source("digital_health_app_raw",'users')}}
),

cleaned_users AS (
    SELECT
        CAST(user_id AS INT64) AS user_id,
        CAST(first_name AS STRING) AS first_name,
        CAST(last_name AS STRING) AS last_name,
        CAST(gender AS STRING) AS gender,
        CAST(age AS INT64) AS age,
        CAST(region AS STRING) AS region,
        CAST(department AS STRING) AS department,
        CAST(is_active AS BOOL) AS is_active,
        CAST(account_created_at AS TIMESTAMP) AS account_created_at
    FROM raw_users
)

SELECT * FROM cleaned_users