with latest_customer as (
	SELECT
       customer_id, address_hash_id, country,created_at,updated_at,currency_unit,tax_eucountry,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY updated_at DESC) as rn
    FROM
        raw.customers c
    where customer_id is not null
)
MERGE INTO sta.customers as st
USING (SELECT * FROM latest_customer where rn=1) as rw
ON st.customer_id = rw.customer_id
WHEN matched and date(rw.updated_at) >= '$checkpoint'    THEN
    UPDATE SET
    address_hash_id = rw.address_hash_id,
    country = rw.country,
    created_at = rw.created_at,
    updated_at = rw.updated_at,
    currency_unit = rw.currency_unit,
    tax_eucountry = rw.tax_eucountry
WHEN NOT matched THEN
    INSERT  ( customer_id, address_hash_id, country,created_at,updated_at,currency_unit,tax_eucountry)
    Values (rw.customer_id, rw.address_hash_id, rw.country,rw.created_at,rw.updated_at,rw.currency_unit,rw.tax_eucountry)


