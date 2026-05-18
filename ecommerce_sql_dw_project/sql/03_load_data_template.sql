USE ecommerce_dw;

-- 使用前请把 /absolute/path/to/ecommerce_sql_dw_project 替换为本机项目目录绝对路径。
-- 如果 LOAD DATA LOCAL INFILE 不可用，可以使用 MySQL Workbench 的 Table Data Import Wizard。

TRUNCATE TABLE stg_order_raw;
TRUNCATE TABLE dim_sku;
TRUNCATE TABLE dim_store;
TRUNCATE TABLE dim_user;
TRUNCATE TABLE dim_date;

LOAD DATA LOCAL INFILE '/absolute/path/to/ecommerce_sql_dw_project/data/stg_order_raw.csv'
INTO TABLE stg_order_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, sku_id, store_id, platform, order_date, payment_amount, quantity, user_id, is_coupon_used, raw_import_time);

LOAD DATA LOCAL INFILE '/absolute/path/to/ecommerce_sql_dw_project/data/dim_sku.csv'
INTO TABLE dim_sku
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(sku_id, sku_name, category, brand, list_price, create_time);

LOAD DATA LOCAL INFILE '/absolute/path/to/ecommerce_sql_dw_project/data/dim_store.csv'
INTO TABLE dim_store
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(store_id, store_name, city, region, open_date);

LOAD DATA LOCAL INFILE '/absolute/path/to/ecommerce_sql_dw_project/data/dim_user.csv'
INTO TABLE dim_user
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, gender, age_group, city, register_date);

LOAD DATA LOCAL INFILE '/absolute/path/to/ecommerce_sql_dw_project/data/dim_date.csv'
INTO TABLE dim_date
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date_key, year_num, quarter_num, month_num, day_num, week_of_year, is_weekend);
