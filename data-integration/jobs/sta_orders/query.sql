with latest_orders as (
	SELECT
       created_at, updated_at, order_id, order_number, webshop_order_number, sales_event, order_type, customer_id, shop_id, payment_method, order_date, delivery_date, booking_date,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY updated_at DESC) as rn
    FROM
        raw.orders op
    where order_id is not null
)
MERGE INTO sta.orders as st
USING (SELECT * FROM latest_orders where rn=1) as rw
ON st.order_id = rw.order_id
WHEN matched and date(rw.updated_at) >= '$checkpoint'  THEN
    UPDATE SET
    created_at=rw.created_at,
    updated_at=rw.updated_at,
    order_number=rw.order_number,
    webshop_order_number=rw.webshop_order_number,
    sales_event=rw.sales_event,
    order_type=rw.order_type,
    customer_id=rw.customer_id,
    shop_id=rw.shop_id,
    payment_method=rw.payment_method,
    order_date=rw.order_date,
    delivery_date=rw.delivery_date,
    booking_date=rw.booking_date
WHEN NOT matched THEN
    INSERT  ( created_at, updated_at, order_id, order_number, webshop_order_number, sales_event, order_type, customer_id, shop_id, payment_method, order_date, delivery_date, booking_date)
    Values (rw.created_at, rw.updated_at, rw.order_id, rw.order_number, rw.webshop_order_number, rw.sales_event, rw.order_type, rw.customer_id, rw.shop_id, rw.payment_method, rw.order_date, rw.delivery_date, rw.booking_date)



