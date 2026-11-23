# Лабораторна робота №5. Нормалізація бази даних

Робив на базі інтернет-магазину (`shop_db`) у pgAdmin 4. Подивився на свої таблиці зі 2-ї лаби і перевірив їх на 1НФ, 2НФ та 3НФ.

## Функціональні залежності
- `customers`: `customer_id -> full_name, email, phone, shipping_address, created_at`
- `categories`: `category_id -> name, description`
- `products`: `product_id -> category_id, name, price, stock_quantity`
- `orders`: `order_id -> customer_id, order_date, status, total_amount`
- `order_items`: `order_item_id -> order_id, product_id, quantity, unit_price` (і ще `order_id, product_id` унікальні разом)
- `payments`: `payment_id -> order_id, payment_date, payment_method, amount, payment_status`

## Що по нормальних формах
- **1НФ:** Усі поля нормальні, без списків чи кількох значень в одній клітинці.
- **2НФ:** У кожної таблиці є свій ключ (`*_id`), дані про товари окремо в `products`, а позиції замовлення — в `order_items`.
- **3НФ:** У `orders` було поле `total_amount` — по суті це сума позицій із `order_items`. Якщо змінити товар чи кількість у замовленні, а суму в `orders` не оновити, будуть різні цифри.

## Що змінив
Прибрав зайве поле `total_amount` з `orders` і перестворив таблиці з даними в pgAdmin:

```sql
ALTER TABLE orders
DROP COLUMN total_amount;
