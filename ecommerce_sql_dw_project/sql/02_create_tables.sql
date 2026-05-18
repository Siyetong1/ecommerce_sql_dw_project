USE ecommerce_dw;

DROP TABLE IF EXISTS ads_sku_top10_report;
DROP TABLE IF EXISTS ads_platform_daily_report;
DROP TABLE IF EXISTS dws_platform_daily;
DROP TABLE IF EXISTS dws_sales_daily;
DROP TABLE IF EXISTS dwd_order_detail;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_user;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_sku;
DROP TABLE IF EXISTS stg_order_raw;

CREATE TABLE stg_order_raw (
    order_id VARCHAR(50),
    sku_id VARCHAR(50),
    store_id VARCHAR(50),
    platform VARCHAR(20),
    order_date DATE,
    payment_amount DECIMAL(10,2),
    quantity INT,
    user_id VARCHAR(50),
    is_coupon_used BOOLEAN,
    raw_import_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT 'STG/ODS 原始订单表';

CREATE TABLE dim_sku (
    sku_id VARCHAR(50) PRIMARY KEY,
    sku_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    list_price DECIMAL(10,2),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT '商品维度表';

CREATE TABLE dim_store (
    store_id VARCHAR(50) PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50),
    region VARCHAR(50),
    open_date DATE
) COMMENT '门店维度表';

CREATE TABLE dim_user (
    user_id VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(10),
    age_group VARCHAR(20),
    city VARCHAR(50),
    register_date DATE
) COMMENT '用户维度表';

CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,
    year_num INT,
    quarter_num INT,
    month_num INT,
    day_num INT,
    week_of_year INT,
    is_weekend BOOLEAN
) COMMENT '日期维度表';

CREATE TABLE dwd_order_detail (
    order_id VARCHAR(50) PRIMARY KEY,
    sku_id VARCHAR(50),
    sku_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    store_id VARCHAR(50),
    store_name VARCHAR(100),
    store_city VARCHAR(50),
    store_region VARCHAR(50),
    platform VARCHAR(20),
    order_date DATE,
    payment_amount DECIMAL(10,2),
    quantity INT,
    user_id VARCHAR(50),
    gender VARCHAR(10),
    age_group VARCHAR(20),
    user_city VARCHAR(50),
    is_coupon_used BOOLEAN,
    raw_import_time TIMESTAMP,
    etl_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT 'DWD 清洗后订单明细宽表';

CREATE TABLE dws_sales_daily (
    stat_date DATE,
    platform VARCHAR(20),
    sku_id VARCHAR(50),
    category VARCHAR(50),
    total_gmv DECIMAL(14,2),
    order_cnt INT,
    pay_user_cnt INT,
    total_quantity INT,
    coupon_order_cnt INT,
    avg_order_amount DECIMAL(10,2),
    etl_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (stat_date, platform, sku_id)
) COMMENT 'DWS 日期-平台-SKU 销售汇总表';

CREATE TABLE dws_platform_daily (
    stat_date DATE,
    platform VARCHAR(20),
    total_gmv DECIMAL(14,2),
    order_cnt INT,
    pay_user_cnt INT,
    total_quantity INT,
    coupon_order_cnt INT,
    avg_order_amount DECIMAL(10,2),
    coupon_order_rate DECIMAL(10,4),
    etl_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (stat_date, platform)
) COMMENT 'DWS 日期-平台销售汇总表';

CREATE TABLE ads_platform_daily_report (
    stat_date DATE,
    platform VARCHAR(20),
    total_gmv DECIMAL(14,2),
    order_cnt INT,
    pay_user_cnt INT,
    avg_order_amount DECIMAL(10,2),
    coupon_order_rate DECIMAL(10,4),
    prev_day_gmv DECIMAL(14,2),
    gmv_dod_rate DECIMAL(10,4),
    gmv_7d_moving_avg DECIMAL(14,2),
    report_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (stat_date, platform)
) COMMENT 'ADS 平台每日销售报表';

CREATE TABLE ads_sku_top10_report (
    platform VARCHAR(20),
    sku_id VARCHAR(50),
    sku_name VARCHAR(100),
    category VARCHAR(50),
    total_gmv DECIMAL(14,2),
    order_cnt INT,
    total_quantity INT,
    gmv_rank INT,
    report_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (platform, sku_id)
) COMMENT 'ADS 各平台 SKU Top10 报表';
