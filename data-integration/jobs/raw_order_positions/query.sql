SELECT
    created_at,
    updated_at ,
    order_id ,
    order_pos_id,
    product_id ,
    product_unit ,
    product_name ,
    price,
    quantity
FROM
    tcc.order_positions
where updated_at >= '$checkpoint'
