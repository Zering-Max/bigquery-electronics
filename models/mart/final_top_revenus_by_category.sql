-- les meilleurs revenus selon la catégorie

SELECT
category,
COUNT(*) as nb_transactions,
ROUND(SUM(price),2) as revenus,
FROM `intermediate/int_categories_table`
GROUP BY category
ORDER BY revenus DESC