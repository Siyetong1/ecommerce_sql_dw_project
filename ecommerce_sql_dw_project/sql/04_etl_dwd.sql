USE ecommerce_dw;

TRUNCATE TABLE dwd_order_detail;

INSERT INTO dwd_order_detail (
    order_id, sku_id, sku_name, category, brand,
    store_id, store_name, store_city, store_region,
    platform, order_date, payment_amount, quantity,
    user_id, gender, age_group, user_city,
    is_coupon_used, raw_import_time
)
SELECT
    o.order_id,
    o.sku_id,
    COALESCE(s.sku_name, 'UNKNOWN') AS sku_name,
    COALESCE(s.category, 'UNKNOWN') AS category,
    COALESCE(s.brand, 'UNKNOWN') AS brand,
    o.store_id,
    COALESCE(st.store_name, 'UNKNOWN') AS store_name,
    COALESCE(st.city, 'UNKNOWN') AS store_city,
    COALESCE(st.region, 'UNKNOWN') AS store_region,
    o.platform,
    o.order_date,
    o.payment_amount,
    o.quantity,
    o.user_id,
    COALESCE(u.gender, 'UNKNOWN') AS gender,
    COALESCE(u.age_group, 'UNKNOWN') AS age_group,
    COALESCE(u.city, 'UNKNOWN') AS user_city,
    o.is_coupon_used,
    o.raw_import_time
FROM stg_order_raw o
LEFT JOIN dim_sku s ON o.sku_id = s.sku_id
LEFT JOIN dim_store st ON o.store_id = st.store_id
LEFT JOIN dim_user u ON o.user_id = u.user_id
WHERE o.order_id IS NOT NULL
  AND o.order_date IS NOT NULL
  AND o.payment_amount > 0
  AND o.quantity > 0;

-- 数据质量检查：重复订单
SELECT order_id, COUNT(*) AS duplicate_cnt
FROM stg_order_raw
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 数据质量检查：维度缺失
SELECT
    SUM(CASE WHEN category = 'UNKNOWN' THEN 1 ELSE 0 END) AS missing_sku_cnt,
    SUM(CASE WHEN store_city = 'UNKNOWN' THEN 1 ELSE 0 END) AS missing_store_cnt,
    SUM(CASE WHEN user_city = 'UNKNOWN' THEN 1 ELSE 0 END) AS missing_user_cnt
FROM dwd_order_detail;
