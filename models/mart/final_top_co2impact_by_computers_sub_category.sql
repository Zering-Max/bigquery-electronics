WITH computers_brand_windows_agg as (
  SELECT
  transaction_id,
  brand,
  sub_category,
  sub_sub_category,
  SUM(GES_kg_co2) OVER(PARTITION BY brand) as GES_kg_co2_by_brand,
  SUM(GES_kg_co2) OVER(PARTITION BY brand, sub_category) as GES_kg_co2_by_sub_cat,
  SUM(GES_kg_co2) OVER(PARTITION BY brand, sub_sub_category) as GES_kg_co2_by_sub_sub_cat,
  ROW_NUMBER() OVER (PARTITION BY brand, sub_category ORDER BY transaction_id) AS row_num
  FROM `intermediate/int_transactions_co2impact_table`
  WHERE category = "computers"
  ORDER BY GES_kg_co2_by_brand desc, GES_kg_co2_by_sub_cat desc, row_num
)

SELECT
brand,
GES_kg_co2_by_brand,
sub_category,
GES_kg_co2_by_sub_cat,
sub_sub_category,
GES_kg_co2_by_sub_sub_cat
FROM computers_brand_windows_agg
WHERE row_num = 1
ORDER BY GES_kg_co2_by_brand desc, GES_kg_co2_by_sub_cat desc