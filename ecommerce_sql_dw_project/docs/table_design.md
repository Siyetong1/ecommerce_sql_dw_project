# 表结构设计说明

## 1. STG/ODS 原始层

`stg_order_raw` 用于保存原始订单数据，字段尽量贴近业务系统或 CSV 导出结果。

核心字段包括：

- `order_id`：订单编号
- `sku_id`：商品编号
- `store_id`：门店编号
- `platform`：销售平台
- `order_date`：下单日期
- `payment_amount`：支付金额
- `quantity`：购买数量
- `user_id`：用户编号
- `is_coupon_used`：是否使用优惠券

## 2. DIM 维度层

维度表用于补充事实数据的分析角度。

- `dim_sku`：商品维度，包含商品名称、类别、品牌、标价等。
- `dim_store`：门店维度，包含门店城市、区域、开店时间等。
- `dim_user`：用户维度，包含性别、年龄段、城市、注册时间等。
- `dim_date`：日期维度，包含年、季度、月、周、是否周末等。

## 3. DWD 明细层

`dwd_order_detail` 是清洗后的订单明细宽表。它从 `stg_order_raw` 出发，关联商品、门店、用户维度表，并过滤掉金额或数量异常的数据。

DWD 层的作用是：

- 保留明细粒度
- 统一字段口径
- 补充维度属性
- 为 DWS 汇总层提供稳定数据来源

## 4. DWS 汇总层

- `dws_sales_daily`：日期 + 平台 + SKU 粒度销售汇总。
- `dws_platform_daily`：日期 + 平台粒度销售汇总。

DWS 层的作用是提前聚合常用指标，降低报表查询成本。

## 5. ADS 应用层

- `ads_platform_daily_report`：平台每日销售报表，包含日环比和 7 日移动平均。
- `ads_sku_top10_report`：各平台 SKU 销售 Top10。

ADS 层直接面向业务报表和面试展示。
