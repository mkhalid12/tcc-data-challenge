SELECT
    customer_id ,
    address_hash_id,
    country,
    created_at,
    updated_at,
    currency_unit,
    tax_eucountry
FROM
    tcc.customers
where updated_at>= '$checkpoint'
