-- 003_category_hierarchy.sql

CREATE TABLE product_category (
    category_id          SERIAL PRIMARY KEY,
    name                 TEXT NOT NULL,
    parent_category_id   INTEGER REFERENCES product_category(category_id)
);

ALTER TABLE product
    ADD COLUMN category_id INTEGER REFERENCES product_category(category_id);

INSERT INTO product_category (name, parent_category_id) VALUES
    ('Electronics', NULL);                                  

INSERT INTO product_category (name, parent_category_id) VALUES
    ('Laptops', 1),                                          
    ('Audio', 1);                                          

INSERT INTO product_category (name, parent_category_id) VALUES
    ('Gaming Laptops', 2),                                
    ('Ultrabooks', 2),                                        
    ('Headphones', 3);                                        
