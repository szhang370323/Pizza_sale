-- Looking for order activity 
USE pizza_db;
SELECT 
  o.order_id,
  i.item_price,
  o.quantity,
  i.item_cat,
  i.item_name,  
  o.created_at,
  a.delivery_address1,
  a.delivery_address2,
  a.delivery_city,
  a.delivery_zipcode,
  o.delivery
FROM orders AS o
LEFT JOIN item AS i ON o.item_id = i.item_id 
LEFT JOIN address AS a ON o.add_id = a.add_id;

-- Dashboard 2 Invertory Management : 
SELECT 
s1.item_name,
s1.ing_id,
s1.ing_name,
s1.order_quantity,
s1.recipe_quantity,
s1.order_quantity * s1.recipe_quantity AS ordered_weight,
s1.ing_price / s1.ing_weight AS unit_cost,
(s1.order_quantity * s1.recipe_quantity) * (s1.ing_price / s1.ing_weight) AS ingredient_cost
FROM (SELECT 
o.item_id,
i.sku,
i.item_name,
r.ing_id,
ing.ing_name,
r.quantity AS recipe_quantity,
sum(o.quantity) AS order_quantity,
ing.ing_weight,
ing.ing_price
FROM orders o
LEFT JOIN item i ON o.item_id = i.item_id 
LEFT JOIN recipe r ON i.sku = r.recipe_id
LEFT JOIN ingredient ing ON ing.ing_id = r.ing_id
GROUP BY 
i.item_name, 
i.sku,
r.ing_id,
r.quantity,
ing.ing_name,
ing.ing_weight,
ing.ing_price) AS s1;

-- Finding
-- 1. total weight ordered 
-- 2. inventory amount
-- 3. inventory remaining per ingredient 
SELECT 
s2.ing_name,
s2.ordered_weight,
ing.ing_weight * inv.quantity AS total_inv_weight,
(ing.ing_weight * inv.quantity) - s2.ordered_weight AS remaining_weight
FROM
(SELECT 
ing_id,
ing_name,
sum(ordered_weight) as ordered_weight
FROM
stockedit
 GROUP BY
ing_name, ing_id) s2
LEFT JOIN inventory AS inv ON inv.item_id = s2.ing_id
LEFT JOIN ingredient AS ing ON ing.ing_id = s2.ing_id;

-- cost of labor 
SELECT
r.date,
s.first_name,
s.last_name,
s.hourly_rate,
sh.start_time,
sh.end_time,
TIMESTAMPDIFF(MINUTE, sh.start_time, sh.end_time)/ 60.0 AS hour_shifts,
TIMESTAMPDIFF(MINUTE, sh.start_time, sh.end_time)/ 60.0* s.hourly_rate as staff_cost
FROM rota AS r
LEFT JOIN staff AS s ON r.staff_id = s.staff_id
LEFT JOIN shift AS sh ON r.shift_id = sh.shift_id
