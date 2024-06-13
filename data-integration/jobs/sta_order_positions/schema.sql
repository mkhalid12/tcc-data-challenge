CREATE TABLE IF NOT EXISTS sta.order_positions (
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    order_id VARCHAR(255),
    order_pos_id VARCHAR(255),
    product_id VARCHAR(255),
    product_unit VARCHAR(255),
    product_name VARCHAR(255),
    price NUMERIC,
    quantity NUMERIC
);