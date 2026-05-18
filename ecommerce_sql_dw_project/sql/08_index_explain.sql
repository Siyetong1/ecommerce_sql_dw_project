USE ecommerce_dw;

CREATE INDEX idx_stg_platform_date
ON stg_order_raw(platform, order_date);

CREATE INDEX idx_stg_sku_date
ON stg_order_raw(sku_id, order_date);

CREATE INDEX idx_dwd_platform_date
ON dwd_order_detail(platform, order_date);

CREATE INDEX idx_dws_sales_platform_date
ON dws_sales_daily(platform, stat_date);

CREATE INDEX idx_dws_sales_sku_date
ON dws_sales_daily(sku_id, stat_date);

CREATE INDEX idx_dws_platform_date
ON dws_platform_daily(platform, stat_date);

EXPLAIN
SELECT
    stat_date,
    platform,
    total_gmv,
    order_cnt
FROM dws_platform_daily
WHERE platform = 'JD'
  AND stat_date BETWEEN '2025-06-01' AND '2025-06-30'
ORDER BY stat_date;

EXPLAIN
SELECT
    stat_date,
    sku_id,
    total_gmv
FROM dws_sales_daily
WHERE sku_id = 'SKU0058'
ORDER BY stat_date;

-- 面试解释要点：
-- type=ALL 通常表示全表扫描；
-- key 表示实际使用的索引；
-- rows 表示 MySQL 预估扫描行数；
-- Extra 中出现 Using filesort 表示可能发生额外排序。
