-- On nettoie les valeurs null ainsi que les lignes de transaction dont la date ne correspond pas du tout à toutes les autres données (qui doivent dater de 2020).
-- On commence aussi à modifier la valeur de l'event_time pour qu'elle soit compatible pour d'autres conversions plus tard.

SELECT
order_id,
SUBSTR(event_time,0,19) as event_time,
product_id,
category_id,
category_code, 
brand,
price
FROM `data/raw_table`
WHERE category_code IS NOT NULL AND price IS NOT NULL AND brand IS NOT NULL AND event_time != '1970-01-01 00:33:40 UTC'
ORDER BY event_time
