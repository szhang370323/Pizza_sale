CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `pizza_db`.`stockedit` AS
    SELECT 
        `s1`.`item_name` AS `item_name`,
        `s1`.`ing_id` AS `ing_id`,
        `s1`.`ing_name` AS `ing_name`,
        `s1`.`order_quantity` AS `order_quantity`,
        `s1`.`recipe_quantity` AS `recipe_quantity`,
        (`s1`.`order_quantity` * `s1`.`recipe_quantity`) AS `ordered_weight`,
        (`s1`.`ing_price` / `s1`.`ing_weight`) AS `unit_cost`,
        ((`s1`.`order_quantity` * `s1`.`recipe_quantity`) * (`s1`.`ing_price` / `s1`.`ing_weight`)) AS `ingredient_cost`
    FROM
        (SELECT 
            `o`.`item_id` AS `item_id`,
                `i`.`sku` AS `sku`,
                `i`.`item_name` AS `item_name`,
                `r`.`ing_id` AS `ing_id`,
                `ing`.`ing_name` AS `ing_name`,
                `r`.`quantity` AS `recipe_quantity`,
                SUM(`o`.`quantity`) AS `order_quantity`,
                `ing`.`ing_weight` AS `ing_weight`,
                `ing`.`ing_price` AS `ing_price`
        FROM
            (((`pizza_db`.`orders` `o`
        LEFT JOIN `pizza_db`.`item` `i` ON ((`o`.`item_id` = `i`.`item_id`)))
        LEFT JOIN `pizza_db`.`recipe` `r` ON ((`i`.`sku` = `r`.`recipe_id`)))
        LEFT JOIN `pizza_db`.`ingredient` `ing` ON ((`ing`.`ing_id` = `r`.`ing_id`)))
        GROUP BY `i`.`item_name` , `i`.`sku` , `r`.`ing_id` , `r`.`quantity` , `ing`.`ing_name` , `ing`.`ing_weight` , `ing`.`ing_price`) `s1`