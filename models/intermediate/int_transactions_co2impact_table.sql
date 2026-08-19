-- La première CTE consiste à joindre la table des GES appliqués sur des produits type 'electronics'
-- et un type de produit en dehors de ce scope ('notebook')
WITH sub_cat_join_co2_query AS (
  SELECT
  itdt.*,
  COALESCE(tpco2.GES_kg_co2,0) AS GES_kg_co2
  FROM `int_transactions_date_table` AS itdt
  LEFT JOIN `data/product_co2` AS tpco2
  ON itdt.sub_category = tpco2.product_name
  WHERE
    category = 'electronics' AND sub_category IN ('smartphone', 'tablet', 'audio', 'clocks', 'telephone', 'camera', 'calculator')
    OR sub_category = 'notebook'
),
-- La deuxième CTE consiste à joindre la table des GES appliqués sur les produits type 'appliances', certains de la sous-catégorie 'video' et 'computers'
sub_sub_cat_join_co2_query AS (
  SELECT
  itdt.*,
  COALESCE(tpco2.GES_kg_co2,0) AS GES_kg_co2
  FROM `int_transactions_date_table` AS itdt
  LEFT JOIN `data/product_co2` AS tpco2
  ON itdt.sub_sub_category = tpco2.product_name
  WHERE
    (category = 'electronics' AND sub_category = 'video')
    OR (category = 'appliances')
    OR (category = 'computers' AND sub_category != 'notebook')
),

SELECT
*
FROM sub_cat_join_co2_query
UNION ALL
SELECT
*
FROM sub_sub_cat_join_co2_query
