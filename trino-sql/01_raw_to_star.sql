insert into clickhouse.bigdata_trino.dim_customer
with src as (
    select * from clickhouse.bigdata_trino.mock_data
    union all
    select * from postgresql.public.mock_data
),
d as (
    select distinct
        customer_first_name,
        customer_last_name,
        customer_age,
        customer_email,
        customer_country,
        customer_postal_code,
        customer_pet_type,
        customer_pet_name,
        customer_pet_breed
    from src
)
select
    row_number() over (order by customer_email, customer_first_name, customer_last_name) as id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
from d;


insert into clickhouse.bigdata_trino.dim_seller
with src as (
    select * from clickhouse.bigdata_trino.mock_data
    union all
    select * from postgresql.public.mock_data
),
d as (
    select distinct
        seller_first_name,
        seller_last_name,
        seller_email,
        seller_country,
        seller_postal_code
    from src
)
select
    row_number() over (order by seller_email, seller_first_name, seller_last_name) as id,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
from d;


insert into clickhouse.bigdata_trino.dim_store
with src as (
    select * from clickhouse.bigdata_trino.mock_data
    union all
    select * from postgresql.public.mock_data
),
d as (
    select distinct
        store_name,
        store_location,
        store_city,
        store_state,
        store_country,
        store_phone,
        store_email
    from src
)
select
    row_number() over (order by store_email, store_name) as id,
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
from d;


insert into clickhouse.bigdata_trino.dim_supplier
with src as (
    select * from clickhouse.bigdata_trino.mock_data
    union all
    select * from postgresql.public.mock_data
),
d as (
    select distinct
        supplier_name,
        supplier_contact,
        supplier_email,
        supplier_phone,
        supplier_address,
        supplier_city,
        supplier_country
    from src
)
select
    row_number() over (order by supplier_email, supplier_name) as id,
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
from d;


insert into clickhouse.bigdata_trino.dim_product
with src as (
    select * from clickhouse.bigdata_trino.mock_data
    union all
    select * from postgresql.public.mock_data
),
d as (
    select distinct
        product_name,
        product_category,
        product_price,
        product_quantity,
        pet_category,
        product_weight,
        product_color,
        product_size,
        product_brand,
        product_material,
        product_description,
        product_rating,
        product_reviews,
        product_release_date,
        product_expiry_date,
        store_name,
        store_location,
        store_city,
        store_state,
        store_country,
        store_phone,
        store_email,
        supplier_name,
        supplier_contact,
        supplier_email,
        supplier_phone,
        supplier_address,
        supplier_city,
        supplier_country
    from src
)
select
    row_number() over (order by d.product_name, d.product_category, d.product_brand, d.store_name, d.supplier_name) as id,
    d.product_name,
    d.product_category,
    d.product_price,
    d.product_quantity,
    d.pet_category,
    d.product_weight,
    d.product_color,
    d.product_size,
    d.product_brand,
    d.product_material,
    d.product_description,
    d.product_rating,
    d.product_reviews,
    d.product_release_date,
    d.product_expiry_date,
    st.id as store_id,
    sp.id as supplier_id
from d
join clickhouse.bigdata_trino.dim_store st
    on d.store_name = st.name
   and d.store_location = st.location
   and d.store_city = st.city
   and d.store_state is not distinct from st.state
   and d.store_country = st.country
   and d.store_phone = st.phone
   and d.store_email = st.email
join clickhouse.bigdata_trino.dim_supplier sp
    on d.supplier_name = sp.name
   and d.supplier_contact = sp.contact
   and d.supplier_email = sp.email
   and d.supplier_phone = sp.phone
   and d.supplier_address = sp.address
   and d.supplier_city = sp.city
   and d.supplier_country = sp.country;


insert into clickhouse.bigdata_trino.fact_sales
with src as (
    select * from clickhouse.bigdata_trino.mock_data
    union all
    select * from postgresql.public.mock_data
)
select
    row_number() over (order by s.sale_date, s.customer_email, s.seller_email, s.product_name) as id,
    s.sale_date,
    c.id as customer_id,
    se.id as seller_id,
    p.id as product_id,
    s.sale_quantity,
    s.sale_total_price
from src s
join clickhouse.bigdata_trino.dim_customer c
    on s.customer_first_name = c.first_name
   and s.customer_last_name = c.last_name
   and s.customer_age = c.age
   and s.customer_email = c.email
   and s.customer_country = c.country
   and s.customer_postal_code is not distinct from c.postal_code
   and s.customer_pet_type = c.pet_type
   and s.customer_pet_name = c.pet_name
   and s.customer_pet_breed = c.pet_breed
join clickhouse.bigdata_trino.dim_seller se
    on s.seller_first_name = se.first_name
   and s.seller_last_name = se.last_name
   and s.seller_email = se.email
   and s.seller_country = se.country
   and s.seller_postal_code is not distinct from se.postal_code
join clickhouse.bigdata_trino.dim_store st
    on s.store_name = st.name
   and s.store_location = st.location
   and s.store_city = st.city
   and s.store_state is not distinct from st.state
   and s.store_country = st.country
   and s.store_phone = st.phone
   and s.store_email = st.email
join clickhouse.bigdata_trino.dim_supplier sp
    on s.supplier_name = sp.name
   and s.supplier_contact = sp.contact
   and s.supplier_email = sp.email
   and s.supplier_phone = sp.phone
   and s.supplier_address = sp.address
   and s.supplier_city = sp.city
   and s.supplier_country = sp.country
join clickhouse.bigdata_trino.dim_product p
    on s.product_name = p.product_name
   and s.product_category = p.product_category
   and s.product_price = p.product_price
   and s.product_quantity = p.product_quantity
   and s.pet_category = p.pet_category
   and s.product_weight = p.product_weight
   and s.product_color = p.product_color
   and s.product_size = p.product_size
   and s.product_brand = p.product_brand
   and s.product_material = p.product_material
   and s.product_description = p.product_description
   and s.product_rating = p.product_rating
   and s.product_reviews = p.product_reviews
   and s.product_release_date = p.product_release_date
   and s.product_expiry_date = p.product_expiry_date
   and p.store_id = st.id
   and p.supplier_id = sp.id;