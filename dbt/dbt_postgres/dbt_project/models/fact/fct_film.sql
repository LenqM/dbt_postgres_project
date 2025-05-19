-- models/fact/fct_book_transactions.sql
-- Model faktów łączący transakcje z klientami i książkami

{{
  config(
    materialized='table' 
  )
}}

with film as (
    select * from {{ ref('stg_film') }}
)

select
    count(sf.film_id) as total_number_of_films
from stg_film sf
