INSERT INTO store (store_name, city, opened_on) VALUES
  ('Koramangala', 'Bengaluru', '2023-01-15'), ('Banjara Hills', 'Hyderabad', '2023-05-01');
INSERT INTO customer (email, full_name, joined_at) VALUES
  ('ananya@example.com', 'Ananya Rao', '2024-01-05'), ('rahul@example.com', 'Rahul Shah', '2024-02-11'),
  ('meera@example.com', 'Meera Iyer', '2024-03-09'), ('arjun@example.com', 'Arjun Nair', '2024-04-02');
INSERT INTO product (sku, product_name, category, current_price) VALUES
  ('COF-001', 'Cold Brew', 'Beverages', 180), ('TEA-001', 'Masala Chai', 'Beverages', 80),
  ('SNK-001', 'Banana Bread', 'Bakery', 120), ('SNK-002', 'Veg Puff', 'Bakery', 60);
INSERT INTO sales_order (customer_id, store_id, order_date, status) VALUES
  (1,1,'2024-05-01 09:00+05:30','paid'), (2,1,'2024-05-01 10:00+05:30','paid'),
  (1,2,'2024-05-15 14:00+05:30','paid'), (3,2,'2024-06-02 11:00+05:30','paid'),
  (2,1,'2024-06-05 16:00+05:30','cancelled'), (4,1,'2024-06-12 08:30+05:30','paid');
INSERT INTO sales_order_item (order_id, product_id, quantity, unit_price) VALUES
  (1,1,2,180),(1,3,1,120),(2,2,2,80),(2,4,1,60),(3,1,1,180),(3,4,2,60),
  (4,3,2,120),(5,1,1,180),(6,2,1,80),(6,3,1,120);
