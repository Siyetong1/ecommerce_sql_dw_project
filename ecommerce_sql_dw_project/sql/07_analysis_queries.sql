USE ecommerce_dw;

-- 1. 各平台总体销售表现
SELECT
    platform,
    SUM(total_gmv) AS total_gmv,
    SUM(order_cnt) AS order_cnt,
    ROUND(SUM(total_gmv) / SUM(order_cnt), 2) AS avg_order_amount
FROM dws_platform_daily
GROUP BY platform
ORDER BY total_gmv DESC;

-- 2. JD 平台 GMV 最高的前 5 个 SKU
SELECT
    sku_id,
    SUM(total_gmv) AS sku_total_gmv,
    SUM(order_cnt) AS sku_order_cnt,
    SUM(total_quantity) AS sku_total_quantity
FROM dws_sales_daily
WHERE platform = 'JD'
GROUP BY sku_id
ORDER BY sku_total_gmv DESC
LIMIT 5;

-- 3. 各商品类别 GMV
SELECT
    category,
    SUM(total_gmv) AS category_gmv,
    SUM(order_cnt) AS order_cnt
FROM dws_sales_daily
GROUP BY category
ORDER BY category_gmv DESC;

-- 4. 各平台优惠券订单占比
SELECT
    platform,
    SUM(coupon_order_cnt) AS coupon_order_cnt,
    SUM(order_cnt) AS order_cnt,
    ROUND(SUM(coupon_order_cnt) / SUM(order_cnt), 4) AS coupon_order_rate
FROM dws_platform_daily
GROUP BY platform
ORDER BY coupon_order_rate DESC;

-- 5. JD 平台日环比
SELECT
    stat_date,
    platform,
    total_gmv,
    prev_day_gmv,
    gmv_dod_rate
FROM ads_platform_daily_report
WHERE platform = 'JD'
ORDER BY stat_date;

-- 6. 各平台 7 日移动平均 GMV
SELECT
    stat_date,
    platform,
    total_gmv,
    gmv_7d_moving_avg
FROM ads_platform_daily_report
ORDER BY platform, stat_date;

-- 7. 各平台 SKU GMV Top10
SELECT
    platform,
    sku_id,
    sku_name,
    category,
    total_gmv,
    gmv_rank
FROM ads_sku_top10_report
ORDER BY platform, gmv_rank;

-- 8. 窗口函数实时计算平台内 SKU 排名
SELECT
    platform,
    sku_id,
    category,
    sku_total_gmv,
    RANK() OVER (
        PARTITION BY platform
        ORDER BY sku_total_gmv DESC
    ) AS platform_sku_rank
FROM (
    SELECT
        platform,
        sku_id,
        category,
        SUM(total_gmv) AS sku_total_gmv
    FROM dws_sales_daily
    GROUP BY platform, sku_id, category
) t
ORDER BY platform, platform_sku_rank;
