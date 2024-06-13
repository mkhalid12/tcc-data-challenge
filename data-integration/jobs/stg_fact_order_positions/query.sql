DROP TABLE IF EXISTS stg.fact_order_positions;
CREATE TABLE stg.fact_order_positions AS
SELECT
    op.order_pos_id,
    op.order_id,
    op.product_id,
    op.price,
    op.quantity
FROM
    sta.order_positions op;