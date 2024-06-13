CREATE TABLE IF NOT EXISTS raw.products (
    product_id VARCHAR(255),
    sku_id VARCHAR(255),
    updated_at TIMESTAMP,
    created_at TIMESTAMP,
    product_name VARCHAR(255),
    product_number VARCHAR(255),
    variant_name VARCHAR(255),
    is_variant CHAR(1),
    product_state_desc VARCHAR(255),
    first_published_at TIMESTAMP
);