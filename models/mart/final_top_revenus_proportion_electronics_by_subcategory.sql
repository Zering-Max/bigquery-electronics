-- dans la catégorie 'electronics', la subquery ici permet de calculer les revenus selon les sous-catégories de 'electronics'
-- Etant donné que la subquery affiche les mêmes résultats sur toutes les lignes de transaction, on a besoin que d'une fois ces résultats par sous-catégorie et catégorie (d'où row_num = 1)

WITH electronics_brand_windows_agg as (
  SELECT
  transaction_id, 
  brand,
  sub_category,
  SUM(price) OVER(PARTITION BY brand) as revenus,
  SUM(price) OVER(PARTITION BY brand, sub_category) as sub_cat_revenus,
  ROW_NUMBER() OVER (PARTITION BY brand, sub_category ORDER BY transaction_id) as row_num
  FROM `intermediate/int_transactions_date_table`
  WHERE category = "electronics"
  ORDER BY revenus DESC, sub_cat_revenus DESC, row_num
)
SELECT 
brand,
sub_category,
revenus,
sub_cat_revenus
FROM electronics_brand_windows_agg
WHERE row_num = 1
ORDER BY revenus DESC, sub_cat_revenus DESC
