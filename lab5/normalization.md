# Лабораторна робота №5. Нормалізація бази даних

Робив на базі інтернет-магазину (`shop_db`) у PostgreSQL / pgAdmin 4. Проаналізував поточні таблиці, перевірив їх на 1НФ, 2НФ та 3НФ і прибрав надлишкове поле.

## 1. Функціональні залежності початкової схеми
- `customers`: `customer_id -> full_name, email, phone, shipping_address, created_at`; також `email -> customer_id`
- `categories`: `category_id -> name, description`; також `name -> category_id`
- `products`: `product_id -> category_id, name, price, stock_quantity`
- `orders`: `order_id -> customer_id, order_date, status, total_amount`
- `order_items`: `order_item_id -> order_id, product_id, quantity, unit_price`; також `(order_id, product_id) -> quantity, unit_price`
- `payments`: `payment_id -> order_id, payment_date, payment_method, amount, payment_status`

## 2. Поточна нормальна форма та порушення
Найвища нормальна форма початкової схеми — **2НФ**:
- **1НФ виконується:** усі поля атомарні, списків або кількох значень в одній клітинці немає.
- **2НФ виконується:** кожна таблиця має свій первинний ключ (`*_id`), дані товарів винесені в `products`, а позиції замовлень — в `order_items`.
- **3НФ порушується:** у таблиці `orders` було поле `total_amount`, яке фактично є похідним від позицій замовлення (`SUM(quantity * unit_price)` у `order_items`). Якщо змінити склад або кількість товару в замовленні і не оновити `total_amount`, в базі з'являться розбіжності (аномалія оновлення).

## 3. Покрокова нормалізація (1НФ -> 2НФ -> 3НФ)
- **Крок 1 (1НФ):** Перевірив усі таблиці (`customers`, `categories`, `products`, `orders`, `order_items`, `payments`) — кожен стовпець містить одне атомарне значення, тому таблиці залишаються в 1НФ.
- **Крок 2 (2НФ):** Перевірив ключі та залежності:
  - `customers(PK: customer_id, UQ: email)`
  - `categories(PK: category_id, UQ: name)`
  - `products(PK: product_id, FK: category_id -> categories.category_id)`
  - `orders(PK: order_id, FK: customer_id -> customers.customer_id)`
  - `order_items(PK: order_item_id, FK: order_id -> orders.order_id, FK: product_id -> products.product_id, UQ: (order_id, product_id))`
  - `payments(PK: payment_id, FK: order_id -> orders.order_id)`
  Часткових залежностей немає, тож схема залишається у 2НФ.
- **Крок 3 (3НФ):** Прибрав із `orders` дублююче/похідне поле `total_amount`, щоб сума рахувалася по позиціях у `order_items`:

```sql
ALTER TABLE orders
DROP COLUMN total_amount;
