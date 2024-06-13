CREATE TABLE IF NOT EXISTS sta.customers (
    customer_id VARCHAR(255) NOT NULL,
    address_hash_id VARCHAR(255),
    country CHAR(2),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    currency_unit CHAR(3),
    tax_eucountry CHAR(2),
    PRIMARY KEY (customer_id)
);