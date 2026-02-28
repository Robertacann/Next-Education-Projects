/* CONSULTAS ANALÍTICAS — RETAIL INVENTORY*/

/* Ventas totales por producto */
SELECT 
    p.product_name,
    SUM(f.sales_quantity) AS total_sales_units,
    SUM(f.sales_quantity * f.price) AS total_sales_value
FROM fact_inventory f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales_value DESC;


/* Ventas por país */
SELECT 
    s.country,
    SUM(f.sales_quantity) AS total_units_sold,
    SUM(f.sales_quantity * f.price) AS total_revenue
FROM fact_inventory f
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY s.country
ORDER BY total_revenue DESC;


/* Ventas por fecha (serie temporal) */
SELECT 
    d.full_date,
    SUM(f.sales_quantity) AS daily_units_sold,
    SUM(f.sales_quantity * f.price) AS daily_revenue
FROM fact_inventory f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.full_date
ORDER BY d.full_date;


/* Inventario promedio por producto */
SELECT 
    p.product_name,
    AVG(f.inventory_level) AS avg_inventory
FROM fact_inventory f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY avg_inventory DESC;


/* Productos con mayor rotación de inventario */
SELECT 
    p.product_name,
    SUM(f.sales_quantity) AS total_units_sold,
    AVG(f.inventory_level) AS avg_inventory,
    CASE 
        WHEN AVG(f.inventory_level) = 0 THEN NULL
        ELSE SUM(f.sales_quantity) / AVG(f.inventory_level)
    END AS inventory_turnover
FROM fact_inventory f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY inventory_turnover DESC;


/* Ventas por categoría y país */
SELECT 
    p.category,
    s.country,
    SUM(f.sales_quantity) AS total_units,
    SUM(f.sales_quantity * f.price) AS total_revenue
FROM fact_inventory f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY p.category, s.country
ORDER BY total_revenue DESC;


/* Detección de outliers en precio (z-score aproximado) */
WITH price_stats AS (
    SELECT 
        AVG(price) AS avg_price,
        STDEV(price) AS std_price
    FROM fact_inventory
)
SELECT 
    f.product_id,
    f.price,
    (f.price - ps.avg_price) / NULLIF(ps.std_price, 0) AS z_score
FROM fact_inventory f
CROSS JOIN price_stats ps
WHERE ABS((f.price - ps.avg_price) / NULLIF(ps.std_price, 0)) > 3
ORDER BY z_score DESC;


/* Top 10 productos con mayor ingreso total */
SELECT TOP 10
    p.product_name,
    SUM(f.sales_quantity * f.price) AS total_revenue
FROM fact_inventory f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;