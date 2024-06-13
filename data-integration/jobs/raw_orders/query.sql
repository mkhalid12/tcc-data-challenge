SELECT
    created_at,
    updated_at,
    order_id ,
    order_number ,
    webshop_order_number,
    sales_event ,
    order_type ,
    customer_id,
    shop_id ,
    payment_method,
    order_date,
    delivery_date ,
    booking_date
FROM
    tcc.orders
where updated_at >= '$checkpoint'
