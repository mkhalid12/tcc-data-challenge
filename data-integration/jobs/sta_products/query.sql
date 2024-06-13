with latest_products as (
	SELECT
       product_id, sku_id, updated_at, created_at, product_name, product_number, variant_name, is_variant, product_state_desc, first_published_at,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY updated_at DESC) as rn
    FROM
        raw.products op
    where product_id is not null
)
MERGE INTO sta.products as st
USING (SELECT * FROM latest_products where rn=1) as r
ON st.product_id = r.product_id
WHEN matched and date(r.updated_at) >= '$checkpoint'  THEN
    UPDATE SET
    product_id=r.product_id,
    sku_id=r.sku_id,
    updated_at=r.updated_at,
    created_at=r.created_at,
    product_name=r.product_name,
    product_number=r.product_number,
    variant_name=r.variant_name,
    is_variant=r.is_variant,
    product_state_desc=r.product_state_desc,
    first_published_at=r.first_published_at
WHEN NOT matched THEN
    INSERT  ( product_id, sku_id, updated_at, created_at, product_name, product_number, variant_name, is_variant, product_state_desc, first_published_at)
    Values  ( r.product_id, r.sku_id, r.updated_at, r.created_at, r.product_name, r.product_number, r.variant_name, r.is_variant, r.product_state_desc, r.first_published_at)



