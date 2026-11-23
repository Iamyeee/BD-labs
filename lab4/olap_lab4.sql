SELECT
    COUNT(*) AS total_products,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price
FROM products;

SELECT
    status,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_sum
FROM orders
GROUP BY status;

SELECT
    status,
    SUM(total_amount) AS total_sum
FROM orders
GROUP BY status
HAVING SUM(total_amount) > 25000;

SELECT
    customer_id,
    COUNT(*) AS orders_count
FROM orders
GROUP BY customer_id;

SELECT
    o.order_id,
    c.full_name,
    o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

SELECT
    c.full_name,
    o.order_id,
    o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

SELECT
    cat.name AS category_name,
    p.name AS product_name,
    p.price
FROM categories cat
LEFT JOIN products p ON cat.category_id = p.category_id;

SELECT
    name,
    price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

SELECT
    full_name,
    (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) AS orders_count
FROM customers c;

SELECT
    category_id,
    ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category_id
HAVING AVG(price) > (SELECT AVG(price) FROM products);