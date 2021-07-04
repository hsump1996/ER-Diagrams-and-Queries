-- 1. This query tries to show the kinds of values that exist in each field

select * from staging_caers_events limit 10;

-- +--------------+---------+------------+-------------+------------+------------------------------------------------------------------------+------------+---------------------------------------+-----------+---------+----+--------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------+
-- |caers_event_id|report_id|created_date|date_of_event|product_type|product                                                                 |product_code|description                            |patient_age|age_units|sex |medra_preferred_terms                                                                                                                                         |outcomes                                              |
-- +--------------+---------+------------+-------------+------------+------------------------------------------------------------------------+------------+---------------------------------------+-----------+---------+----+--------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------+
-- |1             |172934   |2014-01-01  |2013-12-05   |SUSPECT     |VALUED NATIONAL PINE NUTS                                               |23          | Nuts/Edible Seed                      |NULL       |NULL     |NULL|DYSGEUSIA, HYPERSENSITIVITY                                                                                                                                   |Other Outcome                                         |
-- |2             |172937   |2014-01-01  |NULL         |SUSPECT     |DAVID'S SUNFLOWER SEEDS, RANCH FLAVORED                                 |23          | Nuts/Edible Seed                      |NULL       |NULL     |NULL|PAIN, MUCOSAL ULCERATION, TENDERNESS, BURNING SENSATION, CAUSTIC INJURY                                                                                       |Hospitalization, Patient Visited Healthcare Provider, |
-- |3             |172939   |2014-01-01  |NULL         |SUSPECT     |KASHI WHOLE WHEAT BISCUITS, ISLAND VANILLA                              |5           |Cereal Prep/Breakfast Food             |NULL       |NULL     |NULL|VOMITING, ABDOMINAL PAIN, FEELING OF BODY TEMPERATURE CHANGE, FLUSHING, DYSPEPSIA, BODY TEMPERATURE INCREASED, GASTROINTESTINAL DISORDER, FEELING HOT, MALAISE|Other Outcome                                         |
-- |4             |172940   |2014-01-01  |NULL         |SUSPECT     |DANNON DANNON LITE & FIT GREEK YOGURT CHERRY                            |9           |Milk/Butter/Dried Milk Prod            |NULL       |NULL     |NULL|NAUSEA                                                                                                                                                        |Other Outcome                                         |
-- |5             |172941   |2014-01-01  |2013-12-16   |SUSPECT     |COPPER RIVER KIPPERED ALASKA SILVER SALMON                              |16          |Fishery/Seafood Prod                   |NULL       |NULL     |NULL|LACERATION                                                                                                                                                    |Other Outcome                                         |
-- |6             |172944   |2014-01-01  |NULL         |SUSPECT     |WELCH'S 100% GRAPE JUICE, FROM CONCENTRATE WITH ADDED VITAMIN C         |20          |Fruit/Fruit Prod                       |NULL       |NULL     |NULL|SALIVARY GLAND DISORDER, ANXIETY, SLEEP DISORDER                                                                                                              |Other Outcome                                         |
-- |7             |172945   |2014-01-01  |NULL         |SUSPECT     |SAVORITZ ORIGINAL BUTTERY ROUND CRACKERS                                |3           | Bakery Prod/Dough/Mix/Icing           |NULL       |NULL     |NULL|VOMITING                                                                                                                                                      |Other Outcome                                         |
-- |8             |172947   |2014-01-02  |NULL         |CONCOMITANT |FISH OIL (FISH OIL)                                                     |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|64         |year(s)  |F   |FOREIGN BODY TRAUMA, CHOKING                                                                                                                                  |Medically Important,                                  |
-- |9             |172947   |2014-01-02  |NULL         |CONCOMITANT |VITAMIN C (ASCORBIC ACID)                                               |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|64         |year(s)  |F   |FOREIGN BODY TRAUMA, CHOKING                                                                                                                                  |Medically Important,                                  |
-- |10            |172947   |2014-01-02  |NULL         |SUSPECT     |CITRACAL MAXIMUM (CHOLECALCIFEROL + CALCLIUM CITRATE) FILM-COATED TABLET|54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|64         |year(s)  |F   |FOREIGN BODY TRAUMA, CHOKING                                                                                                                                  |Medically Important,                                  |
-- +--------------+---------+------------+-------------+------------+------------------------------------------------------------------------+------------+---------------------------------------+-----------+---------+----+--------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------+

-- This query shows the overall values for all the columns. We can clearly observe that the table is currently not normalized to 3NE. For example, columns product and medra_preferrred_terms have
-- multiple values separated by commas.

-- 2. This query tries to determine whether or not product code is unique		

select product_code, count(product_code) from staging_caers_events group by product_code;


-- +------------+-----+
-- |product_code|count|
-- +------------+-----+
-- |NULL        |0    |
-- |12          |121  |
-- |54          |28221|
-- |41G         |61   |
-- |7           |296  |
-- |13          |313  |
-- |15          |59   |
-- |28          |145  |
-- |52          |5    |
-- +------------+-----+

-- The result of this query tells us that the product code is not unique.

-- 3. This query tries to determine the relationship between report_id and medra_preferred_terms(symptoms)

select report_id, medra_preferred_terms from staging_caers_events;

-- +---------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- |report_id|medra_preferred_terms                                                                                                                                         |
-- +---------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- |172934   |DYSGEUSIA, HYPERSENSITIVITY                                                                                                                                   |
-- |172937   |PAIN, MUCOSAL ULCERATION, TENDERNESS, BURNING SENSATION, CAUSTIC INJURY                                                                                       |
-- |172939   |VOMITING, ABDOMINAL PAIN, FEELING OF BODY TEMPERATURE CHANGE, FLUSHING, DYSPEPSIA, BODY TEMPERATURE INCREASED, GASTROINTESTINAL DISORDER, FEELING HOT, MALAISE|
-- |172940   |NAUSEA                                                                                                                                                        |
-- |172941   |LACERATION                                                                                                                                                    |
-- |172944   |SALIVARY GLAND DISORDER, ANXIETY, SLEEP DISORDER                                                                                                              |
-- |172945   |VOMITING                                                                                                                                                      |
-- |172947   |FOREIGN BODY TRAUMA, CHOKING                                                                                                                                  |
-- |172947   |FOREIGN BODY TRAUMA, CHOKING                                                                                                                                  |
-- +---------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- One major observation we can make from the result is that terms are set for particular report_id. For example, even if there are multiple report_id's, the
-- terms are designated for particular report_id. So if were to create two tables(symptoms and report), the relationship between the two tables would be 
-- one-to-many.


-- 4. This query tries to determine the relationship between report_id and product

select report_id, product from staging_caers_events;

-- +---------+---------------------------------------------------------------+
-- |report_id|product                                                        |
-- +---------+---------------------------------------------------------------+
-- |172934   |VALUED NATIONAL PINE NUTS                                      |
-- |172937   |DAVID'S SUNFLOWER SEEDS, RANCH FLAVORED                        |
-- |172939   |KASHI WHOLE WHEAT BISCUITS, ISLAND VANILLA                     |
-- |172940   |DANNON DANNON LITE & FIT GREEK YOGURT CHERRY                   |
-- |172941   |COPPER RIVER KIPPERED ALASKA SILVER SALMON                     |
-- |172944   |WELCH'S 100% GRAPE JUICE, FROM CONCENTRATE WITH ADDED VITAMIN C|
-- |172945   |SAVORITZ ORIGINAL BUTTERY ROUND CRACKERS                       |
-- |172947   |FISH OIL (FISH OIL)                                            |
-- |172947   |VITAMIN C (ASCORBIC ACID)                                      |
-- +---------+---------------------------------------------------------------+

-- An interesting aspect about the result of this query is that there can be duplicate report_ids. And we can observe that
-- same report_id can have different products. If we were to create a table called report and product, the relationship
-- between two tables would be many-to-many.

-- 5. This query tries to determine if the column product_type contains unique values(in this case, two)

select distinct product_type from staging_caers_events;

-- +------------+
-- |product_type|
-- +------------+
-- |CONCOMITANT |
-- |SUSPECT     |
-- +------------+

-- From this query, we are able to see that there are only two types of results for this column.


-- 6. This query tries to examine the relationship between columns product_code and description

select product_code, description from staging_caers_events;


-- +------------+---------------------------------------+
-- |product_code|description                            |
-- +------------+---------------------------------------+
-- |23          | Nuts/Edible Seed                      |
-- |23          | Nuts/Edible Seed                      |
-- |5           |Cereal Prep/Breakfast Food             |
-- |9           |Milk/Butter/Dried Milk Prod            |
-- |16          |Fishery/Seafood Prod                   |
-- |20          |Fruit/Fruit Prod                       |
-- |3           | Bakery Prod/Dough/Mix/Icing           |
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- +------------+---------------------------------------+

-- From this query, we can see some partial dependency. Column description seems to have a functional
-- dependency on product_code

-- 7. This query tries to determine the relationship between product_code and description

select product_code, description from staging_caers_events where product_code = '54';


-- +------------+---------------------------------------+
-- |product_code|description                            |
-- +------------+---------------------------------------+
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- |54          | Vit/Min/Prot/Unconv Diet(Human/Animal)|
-- +------------+---------------------------------------+


-- From this query, we can see that each  product code has a specific description. For example, we can assume that product_code 60 would have a specific 
-- description. If we were to extract these into tables, we can form two tables, which could be product and product_description table. And the relationship
-- would be many-to-one relationship.