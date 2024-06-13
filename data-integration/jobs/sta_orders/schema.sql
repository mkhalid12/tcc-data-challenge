CREATE TABLE IF NOT EXISTS sta.orders (
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