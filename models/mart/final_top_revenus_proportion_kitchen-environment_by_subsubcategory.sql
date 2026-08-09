-- dans la catégorie 'appliances', la subquery ici permet de calculer les revenus selon les sous-catégories/sous-sous-catégories de 'appliances'
-- Etant donné que la subquery affiche les mêmes résultats sur toutes les lignes de transaction, on a besoin que d'une fois ces résultats par sous-catégorie etc.. (d'où row_num = 1)

WITH appliances_brand_windows_agg as (
  SELECT
  transaction_id, 
  brand,
  sub_category,
  sub_sub_category,
  SUM(price) OVER(PARTITION BY brand) as revenus,
  SUM(price) OVER(PARTITION BY brand, sub_category) as sub_cat_revenus,
  SUM(price) OVER(PARTITION BY brand, sub_category, sub_sub_category) as sub_sub_cat_revenus,
  ROW_NUMBER() OVER (PARTITION BY brand, sub_category, sub_sub_category ORDER BY transaction_id) as row_num
  FROM `intermediate/int_transactions_date_table`
  WHERE category = "appliances"
  ORDER BY revenus DESC, sub_cat_revenus DESC, row_num
)

SELECT
brand,
ROUND(revenus,2) as revenus,
sub_category,
ROUND(sub_cat_revenus,2) as sub_cat_revenus,
sub_sub_category,
ROUND(sub_sub_cat_revenus,2) as sub_sub_cat_revenus,
FROM appliances_brand_windows_agg
WHERE row_num = 1 AND sub_category IN ('kitchen', 'environment')
ORDER BY revenus DESC, sub_cat_revenus DESC, sub_sub_cat_revenus DESC