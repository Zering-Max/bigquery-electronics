# PRESENTATION DU PROJET

La donnée brute retail a été importée de ce Dataset Kaggle : https://www.kaggle.com/datasets/mkechinov/ecommerce-purchase-history-from-electronics-store

Celle des données d'impacts carbone ont repris (avec une table entièrement construite) des données de l'ADEME : https://impactco2.fr/outils
**à noter que, dans le cas des impacts carbone, tous les produits retails du dataset n'ont pas pu être mesurés, seulement les principaux faisant partie de l'analyse principale (les trois catégories) ici.**

Le but ici est d'analyser les comportements d'achats sur ce site e-commerce d'électronique de l'année 2020 afin d'en déduire des recomandations pour la suite pour augmenter le chiffre d'affaires mais aussi limiter l'impact carbone des achats.

## STRUCTURE du "PIPELINE" DE DONNEES

l'importation de la donnée brute et ses transformations ont été réalisées sur BigQuery et on suit l'architecture classique DBT :

**staging => intermediate => mart**

Les différentes tables SQL utilisées sont présentées dans le dossier `models`.

Les tables mart sont ensuites connectés à l'outil de data-visualisation Looker.

Le dashboard final est présenté ici : https://lookerstudio.google.com/reporting/9845c554-bb72-401d-922d-74ebef0e740c

### Staging

Dans cet étape, on s'occupe essentiellement du nettoyage de la donnée brute (valeurs null, aberrantes, etc..) avec parfois du renommage de colonne afin d'avoir un tableau de données de départ propre et compréhensible.
Dans le cas ici il y avait notamment un pb de transactions sur des dates abberantes (1970) et de formatage de la colonne datetime.

### Intermediate

Dans cet étape on peut préparer différents tableaux de données (avec des ajouts de colonne, calculs, jointure, etc..) afin d'être utilisée idéalement plusieurs fois pour la dernière étape "métier" (mart).
Ici il s'agissait de créer deux tables :
- **int_categories_table** : Elle permettait d'aggréger correctement pour la suite les catégories, sous-catgéories, voire sous-sous-catégories car ces 'subtilités' dans la table brut étaient tout mélangés.
- **int_transactions_date_table** : Une autre pour l'aspect purement transactionnel et de la date à la suite de la table *int_categories_table*. Il fallait notamment créer une nouvelle clé primaire unique (id_transaction) pour faire la distinction entre plusieurs actes d'achats de catégories différentes le même jour et aggréger plus finement les catégories par date.
- **int_transactions_co2impact_table** : à partir de la table *int_transactions_date_table*, on y a joint les données d'impact carbone en fonction des catégories et sous-catégories sélectionnées. Les produits n'ayant pas de mesures d'impacts ont vu leur impact mis par défaut à 0.

### Mart

Il s'agit ici de transformer la donnée en un tableau de données métier prêt à l'emploi pour de la visualisation (ici Looker Studio).
On a 4 tables mart :
- *int_categories_table* => **final_top_revenus_by_category**
- *int_categories_table* => **final_top_revenus_electronics_by_brand**
- *int_transactions_date_table* => **final_top_revenus_proportion_kitchen-environment_by_subsubcategory**
- *int_transactions_date_table* => **final_top_revenus_proportion_electronics_by_subcategory**
- *int_transactions_co2impact_table* => **final_top_co2impact_by_electronics_sub_category**
- *int_transactions_co2impact_table* => **final_top_co2impact_by_appliances_sub_category**
- *int_transactions_co2impact_table* => **final_top_co2impact_by_computers_sub_category**