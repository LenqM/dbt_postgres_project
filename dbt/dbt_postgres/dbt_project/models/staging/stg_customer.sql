select * from postgres_scan(
  'host=172.17.0.2 user=sakila password=p_ssW0rd dbname=sakila port=5432',
  'public',
  'customer'
)
