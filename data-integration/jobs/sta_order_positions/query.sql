with latest_order_position as (
	SELECT
       created_at, updated_at, order_id, order_pos_id, product_id, product_unit, product_name, price, quantity,
        ROW_NUMBER() OVER (PARTITION BY order_pos_id ORDER BY updated_at DESC) as rn
    FROM
        raw.order_positions op
    where order_pos_id is not null
)
MERGE INTO sta.order_positions as st
USING (SELECT * FROM latest_order_position where rn=1) as rw
ON st.order_pos_id = rw.order_pos_id
WHEN matched and date(rw.updated_at) >= '$checkpoint'  THEN
    UPDATE SET
    created_at=rw.created_at,
    updated_at=rw.updated_at,
    order_id=rw.order_id,
    product_id=rw.product_id,
    product_unit=rw.product_unit,
    product_name=rw.product_name,
    price=rw.price,
    quantity=rw.quantity
WHEN NOT matched THEN
    INSERT  ( created_at, updated_at, order_id, order_pos_id, product_id, product_unit, product_name, price, quantity)
    Values (rw.created_at, rw.updated_at,rw.order_id, rw.order_pos_id, rw.product_id, rw.product_unit, rw.product_name, rw.price, rw.quantity)



