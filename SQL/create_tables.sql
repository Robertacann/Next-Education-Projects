CREATE TABLE dim_store (
    store_id VARCHAR(10) PRIMARY KEY,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE dim_product (
    product_id VARCHAR(10) PRIMARY KEY,
    category VARCHAR(50) NOT NULL
);

CREATE TABLE dim_date (
    date_id SERIAL PRIMARY KEY,
    date DATE UNIQUE NOT NULL,
    year INT,
    month INT,
    quarter INT
);

CREATE TABLE fact_sales_inventory (
    id_fact SERIAL PRIMARY KEY,
    date_id INT REFERENCES dim_date(date_id),
    store_id VARCHAR(10) REFERENCES dim_store(store_id),
    product_id VARCHAR(10) REFERENCES dim_product(product_id),
    inventory_level INT CHECK (inventory_level >= 0),
    units_sold INT CHECK (units_sold >= 0),
    price NUMERIC(10,2),
    discount NUMERIC(5,2)
);