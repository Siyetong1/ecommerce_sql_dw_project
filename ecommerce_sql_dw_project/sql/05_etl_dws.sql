USE ecommerce_dw;

TRUNCATE TABLE dws_sales_daily;
TRUNCATE TABLE dws_platform_daily;

INSERT INTO dws_sales_daily (
    stat_date, platform, sku_id, category,
    total_gmv, order_cnt, pay_user_cnt, total_quantity,
    coupon_order_cnt, avg_order_amount
)
SELECT
    order_date AS stat_date,
    platform,
    sku_id,
    category,
    SUM(payment_amount) AS total_gmv,
    COUNT(DISTINCT order_id) AS order_cnt,
    COUNT(DISTINCT user_id) AS pay_user_cnt,
    SUM(quantity) AS total_quantity,
    SUM(CASE WHEN is_coupon_used = 1 THEN 1 ELSE 0 END) AS coupon_order_cnt,
    ROUND(SUM(payment_amount) / COUNT(DISTINCT order_id), 2) AS avg_order_amount
FROM dwd_order_detail
GROUP BY order_date, platform, sku_id, category;

INSERT INTO dws_platform_daily (
    stat_date, platform, total_gmv, order_cnt, pay_user_cnt,
    total_quantity, coupon_order_cnt, avg_order_amount, coupon_order_rate
)
SELECT
    order_date AS stat_date,
    platform,
    SUM(payment_amount) AS total_gmv,
    COUNT(DISTINCT order_id) AS order_cnt,
    COUNT(DISTINCT user_id) AS pay_user_cnt,
    SUM(quantity) AS total_quantity,
    SUM(CASE WHEN is_coupon_used = 1 THEN 1 ELSE 0 END) AS coupon_order_cnt,
    ROUND(SUM(payment_amount) / COUNT(DISTINCT order_id), 2) AS avg_order_amount,
    ROUND(SUM(CASE WHEN is_coupon_used = 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT order_id), 4) AS coupon_order_rate
FROM dwd_order_detail
GROUP BY order_date, platform;
