create database if not exists bigdata_trino;

use bigdata_trino;

create table if not exists mock_data (
    id Int32,
    customer_first_name String,
    customer_last_name String,
    customer_age Int32,
    customer_email String,
    customer_country String,
    customer_postal_code Nullable(String),
    customer_pet_type String,
    customer_pet_name String,
    customer_pet_breed String,
    seller_first_name String,
    seller_last_name String,
    seller_email String,
    seller_country String,
    seller_postal_code Nullable(String),
    product_name String,
    product_category String,
    product_price Decimal(10,2),
    product_quantity Int32,
    sale_date String,
    sale_customer_id Int32,
    sale_seller_id Int32,
    sale_product_id Int32,
    sale_quantity Int32,
    sale_total_price Decimal(10,2),
    store_name String,
    store_location String,
    store_city String,
    store_state Nullable(String),
    store_country String,
    store_phone String,
    store_email String,
    pet_category String,
    product_weight Decimal(10,2),
    product_color String,
    product_size String,
    product_brand String,
    product_material String,
    product_description String,
    product_rating Decimal(3,1),
    product_reviews Int32,
    product_release_date String,
    product_expiry_date String,
    supplier_name String,
    supplier_contact String,
    supplier_email String,
    supplier_phone String,
    supplier_address String,
    supplier_city String,
    supplier_country String
)
engine = MergeTree()
order by tuple();

create table if not exists dim_customer (
    id UInt64,
    first_name String,
    last_name String,
    age Int32,
    email String,
    country String,
    postal_code Nullable(String),
    pet_type String,
    pet_name String,
    pet_breed String
)
engine = MergeTree()
order by id;

create table if not exists dim_seller (
    id UInt64,
    first_name String,
    last_name String,
    email String,
    country String,
    postal_code Nullable(String)
)
engine = MergeTree()
order by id;

create table if not exists dim_store (
    id UInt64,
    name String,
    location String,
    city String,
    state Nullable(String),
    country String,
    phone String,
    email String
)
engine = MergeTree()
order by id;

create table if not exists dim_supplier (
    id UInt64,
    name String,
    contact String,
    email String,
    phone String,
    address String,
    city String,
    country String
)
engine = MergeTree()
order by id;

create table if not exists dim_product (
    id UInt64,
    product_name String,
    product_category String,
    product_price Decimal(10,2),
    product_quantity Int32,
    pet_category String,
    product_weight Decimal(10,2),
    product_color String,
    product_size String,
    product_brand String,
    product_material String,
    product_description String,
    product_rating Decimal(3,1),
    product_reviews Int32,
    product_release_date String,
    product_expiry_date String,
    store_id UInt64,
    supplier_id UInt64
)
engine = MergeTree()
order by id;

create table if not exists fact_sales (
    id UInt64,
    sale_date String,
    customer_id UInt64,
    seller_id UInt64,
    product_id UInt64,
    sale_quantity Int32,
    sale_total_price Decimal(10,2)
)
engine = MergeTree()
order by id;

insert into mock_data
select *
from file('MOCK_DATA.csv', 'CSVWithNames');

insert into mock_data
select *
from file('MOCK_DATA (1).csv', 'CSVWithNames');

insert into mock_data
select *
from file('MOCK_DATA (2).csv', 'CSVWithNames');

insert into mock_data
select *
from file('MOCK_DATA (3).csv', 'CSVWithNames');

insert into mock_data
select *
from file('MOCK_DATA (4).csv', 'CSVWithNames');