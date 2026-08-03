WITH raw_documents AS (
    SELECT * FROM {{source('digital_health_app_raw','documents')}}
)

SELECT
    CAST(document_id AS INT64) AS document_id,
    CAST(user_id AS INT64) AS user_id,
    CAST(document_type AS STRING) as document_type,
    CAST(uploaded_at AS TIMESTAMP) AS uploaded_at,
    CAST(file_size_kb AS INT64) AS file_size_kb
FROM raw_documents