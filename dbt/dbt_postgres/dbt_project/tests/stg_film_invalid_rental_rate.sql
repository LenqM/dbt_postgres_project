-- Test: Sprawdza, czy stawka za wypozyczenie filmu jest dodatnia
-- Fail jesli rental_rate jest NULL, 0 lub ujemna

SELECT *
FROM {{ ref('stg_film') }}
WHERE rental_rate IS NULL OR rental_rate <= 0
