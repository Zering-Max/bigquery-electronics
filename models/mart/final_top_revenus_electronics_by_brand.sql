-- les meilleurs revenus dans la catégorie 'electronics' selon les marques

WITH electronics_table as (
  SELECT 
  *
  FROM `intermediate/int_categories_table`
  WHERE category = 'electronics'
)

SELECT
brand,
COUNT(*) as nb_transactions,
ROUND(SUM(price),2) as revenus,
FROM electronics_table
GROUP BY brand
ORDER BY revenus DESC