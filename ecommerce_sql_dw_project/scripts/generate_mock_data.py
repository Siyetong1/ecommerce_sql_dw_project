import csv
import random
from datetime import date, datetime, timedelta
from pathlib import Path

random.seed(20260518)

BASE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = BASE_DIR / "data"
DATA_DIR.mkdir(exist_ok=True)

ORDER_ROWS = 1200
SKU_COUNT = 80
STORE_COUNT = 20
USER_COUNT = 300

platforms = ["JD", "Taobao", "Tmall", "PDD", "Douyin", "WeChat"]
categories = ["Electronics", "Beauty", "Food", "Apparel", "Home", "Books", "Sports", "MotherBaby"]
brands = ["BrandA", "BrandB", "BrandC", "BrandD", "BrandE", "BrandF", "BrandG", "BrandH"]
cities = ["Beijing", "Shanghai", "Guangzhou", "Shenzhen", "Hangzhou", "Chengdu", "Wuhan", "Nanjing", "Xi'an", "Tianjin"]
regions = {
    "Beijing": "North", "Tianjin": "North", "Shanghai": "East",
    "Hangzhou": "East", "Nanjing": "East", "Guangzhou": "South",
    "Shenzhen": "South", "Chengdu": "West", "Wuhan": "Central", "Xi'an": "West"
}
age_groups = ["18-24", "25-34", "35-44", "45-54", "55+"]

start_date = date(2025, 1, 1)
end_date = date(2025, 12, 31)

def write_csv(path, headers, rows):
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(headers)
        writer.writerows(rows)

def random_date(start, end):
    return start + timedelta(days=random.randint(0, (end - start).days))

def main():
    dim_sku = []
    for i in range(1, SKU_COUNT + 1):
        sku_id = f"SKU{str(i).zfill(4)}"
        category = random.choice(categories)
        brand = random.choice(brands)
        price = round(random.uniform(19.9, 999.0), 2)
        create_time = datetime(2024, random.randint(1, 12), random.randint(1, 28), 10, 0, 0)
        dim_sku.append([sku_id, f"{category}_{brand}_{i}", category, brand, f"{price:.2f}", create_time.strftime("%Y-%m-%d %H:%M:%S")])

    dim_store = []
    for i in range(1, STORE_COUNT + 1):
        store_id = f"STORE{str(i).zfill(3)}"
        city = random.choice(cities)
        dim_store.append([store_id, f"Store_{i}", city, regions[city], random_date(date(2020, 1, 1), date(2024, 12, 31)).isoformat()])

    dim_user = []
    for i in range(1, USER_COUNT + 1):
        user_id = f"USER{str(i).zfill(5)}"
        dim_user.append([user_id, random.choice(["M", "F"]), random.choice(age_groups), random.choice(cities), random_date(date(2021, 1, 1), date(2025, 12, 31)).isoformat()])

    dim_date = []
    cur = start_date
    while cur <= end_date:
        dim_date.append([cur.isoformat(), cur.year, (cur.month - 1) // 3 + 1, cur.month, cur.day, int(cur.strftime("%U")), 1 if cur.weekday() >= 5 else 0])
        cur += timedelta(days=1)

    sku_ids = [r[0] for r in dim_sku]
    store_ids = [r[0] for r in dim_store]
    user_ids = [r[0] for r in dim_user]
    sku_price = {r[0]: float(r[4]) for r in dim_sku}

    orders = []
    for i in range(1, ORDER_ROWS + 1):
        order_day = random_date(start_date, end_date)
        sku_id = random.choice(sku_ids)
        quantity = random.choices([1, 2, 3, 4, 5], weights=[55, 25, 12, 6, 2])[0]
        coupon = random.choices([0, 1], weights=[65, 35])[0]
        amount = round(sku_price[sku_id] * quantity * random.uniform(0.85, 1.05) * (random.uniform(0.75, 0.95) if coupon else 1.0), 2)
        orders.append([
            f"ORD{order_day.strftime('%Y%m%d')}{str(i).zfill(6)}",
            sku_id,
            random.choice(store_ids),
            random.choices(platforms, weights=[24, 22, 18, 16, 12, 8])[0],
            order_day.isoformat(),
            f"{amount:.2f}",
            quantity,
            random.choice(user_ids),
            coupon,
            datetime(2026, 1, random.randint(1, 10), random.randint(0, 23), random.randint(0, 59), random.randint(0, 59)).strftime("%Y-%m-%d %H:%M:%S")
        ])

    write_csv(DATA_DIR / "dim_sku.csv", ["sku_id", "sku_name", "category", "brand", "list_price", "create_time"], dim_sku)
    write_csv(DATA_DIR / "dim_store.csv", ["store_id", "store_name", "city", "region", "open_date"], dim_store)
    write_csv(DATA_DIR / "dim_user.csv", ["user_id", "gender", "age_group", "city", "register_date"], dim_user)
    write_csv(DATA_DIR / "dim_date.csv", ["date_key", "year_num", "quarter_num", "month_num", "day_num", "week_of_year", "is_weekend"], dim_date)
    write_csv(DATA_DIR / "stg_order_raw.csv", ["order_id", "sku_id", "store_id", "platform", "order_date", "payment_amount", "quantity", "user_id", "is_coupon_used", "raw_import_time"], orders)

    print("Mock data generated.")
    print(f"orders={len(orders)}, sku={len(dim_sku)}, store={len(dim_store)}, user={len(dim_user)}, dates={len(dim_date)}")

if __name__ == "__main__":
    main()
