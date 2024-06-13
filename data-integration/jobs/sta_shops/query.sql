with latest_shops as (
	SELECT
       shop_id, shop, platform, locale, shop_locale, platform_type,
        ROW_NUMBER() OVER (PARTITION BY shop_id) as rn
    FROM
        raw.shops op
    where shop_id is not null
)
MERGE INTO sta.shops as st
USING (SELECT * FROM latest_shops where rn=1) as r
ON st.shop_id = r.shop_id
WHEN matched  THEN
   UPDATE SET
   shop=r.shop,
   platform=r.platform,
   locale=r.locale,
   shop_locale=r.shop_locale,
   platform_type=r.platform_type
WHEN NOT matched THEN
    INSERT  ( shop_id, shop, platform, locale, shop_locale, platform_type)
    Values  (r.shop_id, r.shop, r.platform, r.locale, r.shop_locale, r.platform_type)



