SELECT
    product_id
    sku_id ,
    updated_at,
    created_at,
    product_name ,
    product_number,
    variant_name,
    is_variant,
    product_state_desc ,
    first_published_at
FROM
    tcc.products
where updated_at >= '$checkpoint'
