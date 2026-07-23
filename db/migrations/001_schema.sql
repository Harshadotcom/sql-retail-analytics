CREATE TABLE store (
  store_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  store_name text NOT NULL UNIQUE,
  city text NOT NULL,
  opened_on date NOT NULL
);

CREATE TABLE customer (
  customer_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email text NOT NULL UNIQUE CHECK (email = lower(email)),
  full_name text NOT NULL,
  joined_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE product (
  product_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  sku text NOT NULL UNIQUE,
  product_name text NOT NULL,
  category text NOT NULL,
  current_price numeric(12,2) NOT NULL CHECK (current_price >= 0),
  active boolean NOT NULL DEFAULT true
);

CREATE TABLE sales_order (
  order_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id bigint NOT NULL REFERENCES customer(customer_id),
  store_id bigint NOT NULL REFERENCES store(store_id),
  order_date timestamptz NOT NULL,
  status text NOT NULL CHECK (status IN ('placed', 'paid', 'cancelled', 'refunded')),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE sales_order_item (
  order_item_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id bigint NOT NULL REFERENCES sales_order(order_id) ON DELETE CASCADE,
  product_id bigint NOT NULL REFERENCES product(product_id),
  quantity integer NOT NULL CHECK (quantity > 0),
  unit_price numeric(12,2) NOT NULL CHECK (unit_price >= 0),
  UNIQUE (order_id, product_id)
);

CREATE INDEX idx_sales_order_reporting ON sales_order (order_date, status);
CREATE INDEX idx_sales_order_customer ON sales_order (customer_id, order_date);
CREATE INDEX idx_order_item_product ON sales_order_item (product_id);
