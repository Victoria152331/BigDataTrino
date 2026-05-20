drop table if exists clickhouse.bigdata_trino.mart_product_sales;
drop table if exists clickhouse.bigdata_trino.mart_customer_sales;
drop table if exists clickhouse.bigdata_trino.mart_time_sales;
drop table if exists clickhouse.bigdata_trino.mart_store_sales;
drop table if exists clickhouse.bigdata_trino.mart_supplier_sales;
drop table if exists clickhouse.bigdata_trino.mart_product_quality;

create table clickhouse.bigdata_trino.mart_product_sales as
select
    p.id as product_id,
    p.product_name,
    p.product_category,
    sum(f.sale_quantity) as total_sales_qty,
    sum(f.sale_total_price) as total_revenue,
    avg(p.product_rating) as avg_rating,
    avg(p.product_reviews) as avg_reviews,
    count(f.id) as sales_count
from clickhouse.bigdata_trino.fact_sales f
join clickhouse.bigdata_trino.dim_product p
    on f.product_id = p.id
group by p.id, p.product_name, p.product_category;


create table clickhouse.bigdata_trino.mart_customer_sales as
select
    c.id as customer_id,
    c.first_name,
    c.last_name,
    c.country,
    sum(f.sale_total_price) as total_spent,
    avg(f.sale_total_price) as avg_check,
    count(f.id) as orders_count
from clickhouse.bigdata_trino.fact_sales f
join clickhouse.bigdata_trino.dim_customer c
    on f.customer_id = c.id
group by c.id, c.first_name, c.last_name, c.country;


create table clickhouse.bigdata_trino.mart_time_sales as
select
    year(cast(date_parse(f.sale_date, '%c/%e/%Y') as date)) as year,
    month(cast(date_parse(f.sale_date, '%c/%e/%Y') as date)) as month,
    sum(f.sale_total_price) as total_revenue,
    sum(f.sale_quantity) as total_sales_qty,
    avg(f.sale_total_price) as avg_check,
    count(f.id) as orders_count
from clickhouse.bigdata_trino.fact_sales f
group by
    year(cast(date_parse(f.sale_date, '%c/%e/%Y') as date)),
    month(cast(date_parse(f.sale_date, '%c/%e/%Y') as date));


create table clickhouse.bigdata_trino.mart_store_sales as
select
    st.id as store_id,
    st.name,
    st.city,
    st.country,
    sum(f.sale_total_price) as total_revenue,
    avg(f.sale_total_price) as avg_check,
    count(f.id) as orders_count
from clickhouse.bigdata_trino.fact_sales f
join clickhouse.bigdata_trino.dim_product p
    on f.product_id = p.id
join clickhouse.bigdata_trino.dim_store st
    on p.store_id = st.id
group by st.id, st.name, st.city, st.country;


create table clickhouse.bigdata_trino.mart_supplier_sales as
select
    sp.id as supplier_id,
    sp.name,
    sp.country,
    sum(f.sale_total_price) as total_revenue,
    avg(p.product_price) as avg_product_price,
    count(f.id) as orders_count
from clickhouse.bigdata_trino.fact_sales f
join clickhouse.bigdata_trino.dim_product p
    on f.product_id = p.id
join clickhouse.bigdata_trino.dim_supplier sp
    on p.supplier_id = sp.id
group by sp.id, sp.name, sp.country;


create table clickhouse.bigdata_trino.mart_product_quality as
select
    p.id as product_id,
    p.product_name,
    avg(p.product_rating) as avg_rating,
    avg(p.product_reviews) as avg_reviews,
    sum(f.sale_quantity) as total_sales_qty,
    sum(f.sale_total_price) as total_revenue,
    count(f.id) as sales_count
from clickhouse.bigdata_trino.fact_sales f
join clickhouse.bigdata_trino.dim_product p
    on f.product_id = p.id
group by p.id, p.product_name;