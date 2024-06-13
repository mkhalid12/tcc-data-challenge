create database tcc;
\c tcc;

create schema if not exists tcc;

CREATE TABLE IF NOT EXISTS tcc.customers (
    customer_id VARCHAR(255) NOT NULL,
    address_hash_id VARCHAR(255),
    country CHAR(2),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    currency_unit CHAR(3),
    tax_eucountry CHAR(2),
    PRIMARY KEY (customer_id)
);
COPY tcc.customers(customer_id, address_hash_id, country, created_at, updated_at, currency_unit, tax_eucountry)
FROM '/data/customers.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE  IF NOT EXISTS tcc.order_positions (
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
COPY tcc.order_positions(created_at, updated_at, order_id, order_pos_id, product_id, product_unit, product_name, price, quantity)
FROM '/data/order_positions.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE  IF NOT EXISTS tcc.orders (
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    order_id VARCHAR(255),
    order_number VARCHAR(255),
    webshop_order_number VARCHAR(255),
    sales_event VARCHAR(255),
    order_type VARCHAR(255),
    customer_id VARCHAR(255),
    shop_id VARCHAR(255),
    payment_method VARCHAR(255),
    order_date TIMESTAMP,
    delivery_date TIMESTAMP,
    booking_date TIMESTAMP
);
COPY tcc.orders(created_at, updated_at, order_id, order_number, webshop_order_number, sales_event, order_type, customer_id, shop_id, payment_method, order_date, delivery_date, booking_date)
FROM '/data/orders.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS tcc.products (
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

COPY tcc.products(product_id, sku_id, updated_at, created_at, product_name, product_number, variant_name, is_variant, product_state_desc, first_published_at)
FROM '/data/products.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS tcc.shops (
    shop_id VARCHAR(255),
    shop VARCHAR(255),
    platform VARCHAR(255),
    locale VARCHAR(255),
    shop_locale VARCHAR(255),
    platform_type VARCHAR(255)
);

COPY tcc.shops(shop_id, shop, platform, locale, shop_locale, platform_type)
FROM '/data/shops.csv'
DELIMITER ','
CSV HEADER;




