CREATE TABLE product_category (
  category_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  parent_category_id BIGINT NULL,
  CONSTRAINT fk_category_parent FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id)
);

ALTER TABLE product ADD COLUMN category_id BIGINT NULL;
ALTER TABLE product ADD CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES product_category(category_id);
ALTER TABLE product ADD INDEX idx_product_category (category_id);

INSERT INTO product_category (name, parent_category_id) VALUES
  ('Electronics', NULL),
  ('Laptops', 1),
  ('Audio', 1),
  ('Gaming Laptops', 2),
  ('Ultrabooks', 2),
  ('Headphones', 3),
  ('Beverages', NULL),
  ('Bakery', NULL);

UPDATE product
SET category_id = CASE category
  WHEN 'Beverages' THEN 7
  WHEN 'Bakery' THEN 8
END;
