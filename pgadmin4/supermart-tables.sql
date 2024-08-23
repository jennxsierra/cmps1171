CREATE TABLE public.customer
(
    "customer_id" character varying PRIMARY KEY NOT NULL,
    "customer_name" character varying COLLATE pg_catalog."default",
    "segment" character varying COLLATE pg_catalog."default",
    "age" integer,
    "country" character varying COLLATE pg_catalog."default",
    "city" character varying COLLATE pg_catalog."default",
    "state" character varying COLLATE pg_catalog."default",
    "postal_code" integer,
    "region" character varying COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.customer
    OWNER to postgres;

copy customer from '/home/jsierra/Downloads/data files/Data/Customer.csv' delimiter ',' csv header;

CREATE TABLE public.product
(
    "product_id" character varying PRIMARY KEY,
    "category" character varying COLLATE pg_catalog."default",
    "sub_category" character varying COLLATE pg_catalog."default",
    "product Name" character varying COLLATE pg_catalog."default"
	)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.product
    OWNER to postgres;

copy product from '/home/jsierra/Downloads/data files/Data/Product.csv' delimiter ',' csv header;

CREATE TABLE public.sales
(
    "order_line" integer PRIMARY KEY ,
    "order_id" character varying COLLATE pg_catalog."default",
    "order_date" date,
    "ship_date" character varying COLLATE pg_catalog."default",
    "ship_mode" character varying COLLATE pg_catalog."default",
    "customer_id" character varying COLLATE pg_catalog."default" references customer("customer_id"),
    "product_id" character varying COLLATE pg_catalog."default" references product("product_id"),
    "sales" double precision,
    "quantity" integer,
    "discount" double precision,
    "profit" double precision
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.sales
    OWNER to postgres;

TRUNCATE sales;
SET datestyle TO "ISO, DMY";
copy sales from '/home/jsierra/Downloads/data files/Data/Sales.csv' delimiter ',' csv header;