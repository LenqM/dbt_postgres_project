select * from postgres_scan(
  'host=localhost user=sakila password=p_ssW0rd dbname=sakila port=5432',
  'public',
  'actor'
)
