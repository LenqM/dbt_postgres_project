-- Test: Nazwiska aktorow nie powinny zawierac cyfr
-- Fail jesli `last_name` zawiera cyfry

SELECT *
FROM {{ ref('stg_actor') }}
WHERE last_name ~ '[0-9]'
