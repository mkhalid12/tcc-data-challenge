Drop table if exists stg.fact_orders;
CREATE TABLE stg.fact_orders AS
SELECT
    o.order_id,
    o.shop_id,
    o.customer_id,
    o.order_date,
    CASE
        WHEN o.delivery_date IS NOT NULL THEN SUM(op.price * op.quantity)
        ELSE 0
    END AS revenue,
    SUM(op.price * op.quantity) AS order_intake
FROM
    sta.orders o
JOIN
   sta.order_positions op
ON
    o.order_id = op.order_id
GROUP BY
    o.order_id, o.shop_id, o.customer_id, o.order_date, o.delivery_date;
