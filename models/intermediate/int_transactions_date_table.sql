-- Il s'agit ici de rendre compatible la colonne event_time pour des graphes en times series (donc besoin d'un format DATE)
-- Egalement j'ai constaté que les lignes de transaction ne sont pas tous uniques en se basant sur le order_id
-- DU coup j'ai dû créer une nouvelle clé primaire (order_id + product_id = transaction_id) afin de pouvoir bien "séparer" chacun des achats car parfois une personne pouvait acheter plusieurs articles en même temps mais pas de même catégorie sous un même order_id
-- Cela risquait alors de "fausser" un peu l'analyse sur les catégories de produit achetés une certaine date si on devait ensuite aggréger par order_id.


WITH sub_query AS 
(
  SELECT
  CONCAT(order_id,'-',product_id) as transaction_id,
  CAST(SUBSTR(event_time, 0, 10) AS DATE) as event_time,
  brand,
  price,
  category,
  sub_category,
  sub_sub_category
  FROM `intermediate/int_categories_table`
)

SELECT
transaction_id,
MAX(event_time) as event_time,
MAX(brand) as brand,
SUM(price) as price,
MAX(category) as category,
MAX(sub_category) as sub_category,
MAX(sub_sub_category) as sub_sub_category,
FROM sub_query
GROUP BY transaction_id
ORDER BY event_time
