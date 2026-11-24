-- Il s'agissait ici d'utiliser une windows function pour aggréger sur plusieurs niveaux de granularité (brand, sub_category, sub_sub_category)
-- Comme un des "défauts" de cette opération était d'avoir beaucoup de lignes en doublon, il fallait filtrer en prenant juste une ligne par sous-sous-catégorie)

WITH electronics_brand_windows_agg AS (
  SELECT
  transaction_id,
  brand,
  SUM(GES_kg_co2) OVER(PARTITION BY brand) AS GES_kg_co2_by_brand,
  sub_category,
  SUM(GES_kg_co2) OVER(PARTITION BY brand, sub_category) AS GES_kg_co2_by_sub_cat,
  sub_sub_category,
  SUM(GES_kg_co2) OVER(PARTITION BY brand, sub_sub_category) AS GES_kg_co2_by_sub_sub_cat,
  ROW_NUMBER() OVER (PARTITION BY brand, sub_category ORDER BY transaction_id) AS row_num
  FROM `intermediate/int_transactions_co2impact_table`
  WHERE category = "electronics"
  ORDER BY GES_kg_co2_by_brand DESC, GES_kg_co2_by_sub_cat DESC, row_num
)

SELECT
brand,
GES_kg_co2_by_brand,
sub_category,
GES_kg_co2_by_sub_cat,
sub_sub_category,
GES_kg_co2_by_sub_sub_cat
FROM electronics_brand_windows_agg
WHERE row_num = 1
ORDER BY GES_kg_co2_by_brand DESC, GES_kg_co2_by_sub_cat DESC