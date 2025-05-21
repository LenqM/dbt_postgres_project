-- Test: Adresy email klientow powinny miec poprawny format
-- Fail jesli `email` nie pasuje do prostego regexu emailowego

SELECT *
FROM {{ ref('stg_customer') }}
WHERE NOT regexp_matches(email, '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$', 'i')
