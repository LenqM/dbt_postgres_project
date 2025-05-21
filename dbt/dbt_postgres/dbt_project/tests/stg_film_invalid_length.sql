-- Test: Sprawdza, czy dlugosc filmu (length) ma sensowna wartosc
-- Fail jesli dlugosc jest ujemna, zero lub przekracza 500 minut

SELECT *
FROM {{ ref('stg_film') }}
WHERE length IS NULL 
OR length <= 0 
OR length > 500
