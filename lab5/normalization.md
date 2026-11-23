# Лабораторна робота №5: Нормалізація бази даних

**База даних:** `shop_db` (PostgreSQL, pgAdmin 4)  
**Цільова нормальна форма:** 3НФ

## 1. Функціональні залежності (ФЗ) початкової схеми
- `customers`: `customer_id -> full_name, email, phone, shipping_address, created_at`; `email -> customer_id`
- `categories`: `category_id -> name, description`; `name -> category_id`
- `products`: `product_id -> category_id, name, price, stock_quantity`
- `orders`: `order_id -> customer_id, order_date, status, total_amount`
- `order_items`: `order_item_id -> order_id, product_id, quantity, unit_price`; `(order_id, product_id) -> quantity, unit_price`
- `payments`: `payment_id -> order_id, payment_date, payment_method, amount, payment_status`

## 2. Перевірка нормальних форм (1НФ, 2НФ, 3НФ)
- **1НФ (Перша нормальна форма):** Початкова схема відповідає 1НФ — усі атрибути атомарні, повторюваних груп стовпців або списків у клітинках немає.
- **2НФ (Друга нормальна форма):** Схема відповідає 2НФ — кожна таблиця має первинний ключ, а атрибути товару (`name`, `price`, `stock_quantity`) знаходяться у `products`, тоді як `order_items` зберігає лише дані позиції замовлення (`quantity`, `unit_price`).
- **3НФ (Третя нормальна форма):** У початковій схемі таблиця `orders` містила поле `total_amount`, яке є похідним від позицій замовлення (`SUM(quantity * unit_price)` у `order_items`). Зберігання похідної суми в окремому полі створює ризик неузгодженості (аномалії оновлення) при зміні складу замовлення.

## 3. Крок нормалізації та зміни структури
Видаляємо зайве похідне поле `total_amount` із таблиці `orders`, щоб сума замовлення визначалася за позиціями в `order_items`:

```sql
ALTER TABLE orders
DROP COLUMN total_amount;
