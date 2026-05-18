USE ecommerce_dw;

TRUNCATE TABLE ads_platform_daily_report;
TRUNCATE TABLE ads_sku_top10_report;

INSERT INTO ads_platform_daily_report (
    stat_date, platform, total_gmv, order_cnt, pay_user_cnt,
    avg_order_amount, coupon_order_rate, prev_day_gmv,
    gmv_dod_rate, gmv_7d_moving_avg
)
SELECT
    stat_date,
    platform,
    total_gmv,
    order_cnt,
    pay_user_cnt,
    avg_order_amount,
    coupon_order_rate,
    prev_day_gmv,
    CASE
        WHEN prev_day_gmv IS NULL OR prev_day_gmv = 0 THEN NULL
        ELSE ROUND((total_gmv - prev_day_gmv) / prev_day_gmv, 4)
    END AS gmv_dod_rate,
    gmv_7d_moving_avg
FROM (
    SELECT
        stat_date,
        platform,
        total_gmv,
        order_cnt,
        pay_user_cnt,
        avg_order_amount,
        coupon_order_rate,
        LAG(total_gmv, 1) OVER (
            PARTITION BY platform
            ORDER BY stat_date
        ) AS prev_day_gmv,
        ROUND(
            AVG(total_gmv) OVER (
                PARTITION BY platform
                ORDER BY stat_date
                ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            ),
            2
        ) AS gmv_7d_moving_avg
    FROM dws_platform_daily
) t;

INSERT INTO ads_sku_top10_report (
    platform, sku_id, sku_name, category,
    total_gmv, order_cnt, total_quantity, gmv_rank
)
SELECT
    platform, sku_id, sku_name, category,
    total_gmv, order_cnt, total_quantity, gmv_rank
FROM (
    SELECT
        x.platform,
        x.sku_id,
        COALESCE(s.sku_name, 'UNKNOWN') AS sku_name,
        x.category,
        x.total_gmv,
        x.order_cnt,
        x.total_quantity,
        RANK() OVER (
            PARTITION BY x.platform
            ORDER BY x.total_gmv DESC
        ) AS gmv_rank
    FROM (
        SELECT
            platform,
            sku_id,
            category,
            SUM(total_gmv) AS total_gmv,
            SUM(order_cnt) AS order_cnt,
            SUM(total_quantity) AS total_quantity
        FROM dws_sales_daily
        GROUP BY platform, sku_id, category
    ) x
    LEFT JOIN dim_sku s ON x.sku_id = s.sku_id
) r
WHERE gmv_rank <= 10;
