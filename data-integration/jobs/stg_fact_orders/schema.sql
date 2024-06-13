CREATE TABLE IF NOT EXISTS stg.fact_orders (
    order_id varchar(255) NULL,
	shop_id varchar(255) NULL,
	customer_id varchar(255) NULL,
	order_date timestamp NULL,
	revenue numeric NULL,
	order_intake numeric NULL
);