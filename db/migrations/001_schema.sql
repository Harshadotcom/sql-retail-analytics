CREATE TABLE store (
  store_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  store_name VARCHAR(120) NOT NULL UNIQUE,
  city VARCHAR(120) NOT NULL,
  opened_on DATE NOT NULL
);

CREATE TABLE customer (
  customer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  full_name VARCHAR(150) NOT NULL,
  joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_customer_email_lower CHECK (email = LOWER(email))
);

CREATE TABLE product (
  product_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(50) NOT NULL UNIQUE,
  product_name VARCHAR(150) NOT NULL,
  category VARCHAR(100) NOT NULL,
  current_price DECIMAL(12,2) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT chk_product_price CHECK (current_price >= 0)
);

CREATE TABLE sales_order (
  order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  store_id BIGINT NOT NULL,
  order_date TIMESTAMP NOT NULL,
  status ENUM('placed', 'paid', 'cancelled', 'refunded') NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  CONSTRAINT fk_order_store FOREIGN KEY (store_id) REFERENCES store(store_id),
  INDEX idx_sales_order_reporting (order_date, status),
  INDEX idx_sales_order_customer (customer_id, order_date)
);

CREATE TABLE sales_order_item (
  order_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES sales_order(order_id) ON DELETE CASCADE,
  CONSTRAINT fk_order_item_product FOREIGN KEY (product_id) REFERENCES product(product_id),
  CONSTRAINT chk_order_item_quantity CHECK (quantity > 0),
  CONSTRAINT chk_order_item_price CHECK (unit_price >= 0),
  UNIQUE KEY uq_order_product (order_id, product_id),
  INDEX idx_order_item_product (product_id)
);
