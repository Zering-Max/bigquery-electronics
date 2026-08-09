-- Il s'agit ici de créer un tableau intermédiaire notamment en cassant le "category_code" qui est une valeur string regroupant plusieurs catégories/sous-catégories (exemple : 'computers.gaming')
-- On veut rendre vraiment "granulaire" la manipulation des catégories/sous-catégories/etc.. de produit

SELECT
order_id,
event_time,
product_id,
category_id,
brand,
price,
SPLIT(category_code, '.')[0] as category,
SPLIT(category_code, '.')[1] as sub_category,
CASE
  WHEN SPLIT(category_code, '.')[0] IN ('accessories','apparel', 'country_yard', 'kids', 'sport', 'stationery') THEN 'no_category'
  WHEN SPLIT(category_code, '.')[0] IN ('appliances', 'computers', 'electronics') AND SPLIT(category_code, '.')[1] IN ('iron', 'ironing_board', 'sewing_machine', 'steam_cleaner','desktop', 'ebooks', 'gaming','notebook', 'calculator', 'clocks', 'smartphone', 'tablet', 'telephone' ) THEN 'no_category'
  ELSE SPLIT(category_code, '.')[2]
END AS sub_sub_category,
FROM `staging/staging_clean_table`
order by event_time