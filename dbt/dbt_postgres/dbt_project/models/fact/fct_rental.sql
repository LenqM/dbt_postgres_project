-- models/fact/fct_rental.sql
-- Model faktów łączący wypoyczenia z klientami, filmami etc.

{{ 
  config(
    materialized='table' 
  )
}}

with base_rental as (
    select
        *
    from {{ ref('stg_rental') }}
),
final as (
    select
        r.rental_id,
        r.rental_date,
        r.inventory_id,
        i.film_id,
        f.title as 'film_title',
        r.customer_id,
        c.first_name as 'customer_first_name',
        c.last_name as 'customer_last_name',
        r.return_date,
        r.staff_id,
        s.first_name as 'staff_first_name',
        s.last_name as 'staff_last_name'
    from base_rental r
    left join {{ ref('stg_inventory') }} i
        on r.inventory_id = i.inventory_id
    left join {{ ref('stg_customer') }} c
        on r.customer_id = c.customer_id
    left join {{ ref('stg_film') }} f
        on i.film_id = f.film_id
    left join {{ ref('stg_staff') }} s
        on r.staff_id = s.staff_id
)

select *
from final
