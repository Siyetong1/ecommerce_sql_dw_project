# 基于 MySQL 的电商数据仓库小项目

## 项目定位

本项目是一个面向应届生校招面试和 SQL 知识巩固的电商数据仓库小项目。项目基于 MySQL 实现，不依赖 Hive、Spark 等大数据组件，重点展示数据库建模、SQL 编写、数仓分层、指标统计、窗口函数和索引优化等基础能力。

## 项目背景

假设某电商公司从多个平台获得订单数据，包括 JD、Taobao、Tmall、PDD、Douyin、WeChat 等平台。现在需要将原始订单数据导入 MySQL，并构建一套简化版数据仓库，用于统计每日销售额、订单数、支付用户数、客单价、优惠券订单占比、SKU 排名、平台销售趋势、日环比和 7 日移动平均等指标。

## 技术栈

- MySQL 8.0+
- Python 3.8+
- SQL

> 注意：窗口函数如 `LAG()`、`RANK()`、`AVG() OVER()` 需要 MySQL 8.0 及以上版本。

## 项目目录

```text
ecommerce_sql_dw_project/
├── data/
│   ├── stg_order_raw.csv
│   ├── dim_sku.csv
│   ├── dim_store.csv
│   ├── dim_user.csv
│   └── dim_date.csv
├── docs/
│   ├── table_design.md
│   └── interview_guide.md
├── scripts/
│   └── generate_mock_data.py
├── sql/
│   ├── 00_run_order.txt
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_load_data_template.sql
│   ├── 04_etl_dwd.sql
│   ├── 05_etl_dws.sql
│   ├── 06_ads_reports.sql
│   ├── 07_analysis_queries.sql
│   └── 08_index_explain.sql
├── .gitignore
├── requirements.txt
└── README.md
```

## 数仓分层设计

```text
CSV 模拟数据
    ↓
STG/ODS：stg_order_raw 原始订单层
    ↓
DIM：dim_sku / dim_store / dim_user / dim_date 维度层
    ↓
DWD：dwd_order_detail 明细清洗层
    ↓
DWS：dws_sales_daily / dws_platform_daily 汇总层
    ↓
ADS：ads_platform_daily_report / ads_sku_top10_report 应用层
```

## 核心指标

| 指标 | SQL 计算方式 | 含义 |
|---|---|---|
| GMV | `SUM(payment_amount)` | 成交总额 |
| 订单数 | `COUNT(DISTINCT order_id)` | 去重订单数 |
| 支付用户数 | `COUNT(DISTINCT user_id)` | 去重支付用户数 |
| 销售件数 | `SUM(quantity)` | 商品销售数量 |
| 客单价 | `SUM(payment_amount) / COUNT(DISTINCT order_id)` | 平均每单金额 |
| 优惠券订单数 | `SUM(CASE WHEN is_coupon_used = 1 THEN 1 ELSE 0 END)` | 使用优惠券的订单数量 |
| 优惠券订单占比 | `coupon_order_cnt / order_cnt` | 优惠券订单在全部订单中的比例 |

## 快速运行

### 1. 生成模拟数据

项目已附带 CSV 数据。如需重新生成：

```bash
python scripts/generate_mock_data.py
```

### 2. 创建数据库和表

```sql
source sql/01_create_database.sql;
source sql/02_create_tables.sql;
```

### 3. 导入 CSV

修改 `sql/03_load_data_template.sql` 中的本地绝对路径，然后执行该文件。

如果 `LOAD DATA LOCAL INFILE` 报错，可以使用 MySQL Workbench 的 `Table Data Import Wizard` 图形界面导入 CSV。

### 4. 执行 ETL

```sql
source sql/04_etl_dwd.sql;
source sql/05_etl_dws.sql;
source sql/06_ads_reports.sql;
```

### 5. 执行分析与优化 SQL

```sql
source sql/07_analysis_queries.sql;
source sql/08_index_explain.sql;
```

## 简历写法示例

```text
基于 MySQL 的电商数据仓库分析项目

- 设计 STG、DIM、DWD、DWS、ADS 五层简化数仓结构，完成订单原始数据导入、明细清洗、维度关联和销售指标汇总。
- 使用 SQL 实现 GMV、订单量、支付用户数、客单价、优惠券使用率、SKU 销售排行、平台销售趋势等核心电商指标。
- 使用窗口函数实现日环比、7 日移动平均和平台内 SKU 排名，提升对时间序列分析和分组排序查询的理解。
- 针对平台、日期、SKU 等高频查询字段设计联合索引，并使用 EXPLAIN 分析索引命中、全表扫描和排序开销。
```
