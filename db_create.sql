DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO egor;
GRANT ALL ON SCHEMA public TO public;
COMMENT ON SCHEMA public IS 'standard public schema';

-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Country

Drop table if exists country;
CREATE TABLE country
(
    "id" serial      NOT NULL,
    name varchar(50) NOT NULL UNIQUE,
    CONSTRAINT PK_country_id PRIMARY KEY ("id"),
    CONSTRAINT Country_Name_Unique UNIQUE (name)
);

COMMENT ON COLUMN country.name IS 'Имя страны';
COMMENT ON CONSTRAINT Country_Name_Unique ON country IS 'Имя страны должно быть уникальным';

-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Manufacturer
Drop table if exists manufacturer;
CREATE TABLE manufacturer
(
    "id"    serial       NOT NULL,
    name    varchar(50)  NOT NULL,
    phone   varchar(20)  NOT NULL,
    address varchar(200) NOT NULL,
    CONSTRAINT PK_manufacturer_id PRIMARY KEY ("id")
);

-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Supplier
Drop table if exists supplier;
CREATE TABLE supplier
(
    "id"    serial       NOT NULL,
    name    varchar(50)  NOT NULL,
    phone   varchar(20)  NOT NULL,
    address varchar(200) NOT NULL,
    CONSTRAINT PK_supplier_id PRIMARY KEY ("id")
);

-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Product_category
Drop table if exists product_category;
CREATE TABLE product_category
(
    "id" serial      NOT NULL,
    name varchar(50) NOT NULL,
    CONSTRAINT PK_product_category_id PRIMARY KEY ("id")
);

-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Region
Drop table if exists region;
CREATE TABLE region
(
    "id"       serial      NOT NULL,
    name       varchar(50) NOT NULL,
    country_id serial      NOT NULL,
    CONSTRAINT PK_region_id PRIMARY KEY ("id"),
    CONSTRAINT FK_region_country_id FOREIGN KEY (country_id) REFERENCES country ("id")
);

CREATE INDEX FK_country_id ON region
    (
     country_id
        );

-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Store
Drop table if exists store;
CREATE TABLE store
(
    name      varchar(50) NOT NULL,
    "id"      serial      NOT NULL,
    region_id serial      NOT NULL,
    CONSTRAINT PK_store_id PRIMARY KEY ("id"),
    CONSTRAINT FK_store_region_id FOREIGN KEY (region_id) REFERENCES region ("id")
);

CREATE INDEX FK_50 ON store
    (
     region_id
        );

-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Product
Drop table if exists product;
CREATE TABLE product
(
    "id"                serial       NOT NULL,
    name                varchar(150) NOT NULL,
    supplier_id         serial       NOT NULL,
    manufacturer_id     serial       NOT NULL,
    product_category_id serial       NOT NULL,
    weight              numeric      NULL,
    width               numeric      NULL,
    height              numeric      NULL,
    "length"            numeric      NULL,
    CONSTRAINT PK_product_id PRIMARY KEY ("id"),
    CONSTRAINT FK_product_manufacturer_id FOREIGN KEY (manufacturer_id) REFERENCES manufacturer ("id"),
    CONSTRAINT FK_product_product_category_id FOREIGN KEY (product_category_id) REFERENCES Product_category ("id"),
    CONSTRAINT FK_product_supplier_id FOREIGN KEY (supplier_id) REFERENCES supplier ("id")
);

CREATE INDEX FK_product_manufacturer_id ON product
    (
     manufacturer_id
        );

CREATE INDEX FK_product_product_category_id ON product
    (
     product_category_id
        );

CREATE INDEX FK_product_supplier_id ON product
    (
     supplier_id
        );


-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Price
Drop table if exists price;
CREATE TABLE price
(
    product_id serial  NOT NULL,
    store_id   serial  NOT NULL,
    price      numeric NULL,
    "id"       serial  NOT NULL,
    CONSTRAINT PK_price_id PRIMARY KEY ("id"),
    CONSTRAINT FK_price_product_id FOREIGN KEY (product_id) REFERENCES product ("id"),
    CONSTRAINT FK_price_store_id FOREIGN KEY (store_id) REFERENCES store ("id")
);

CREATE INDEX FK_price_price ON price
    (
     product_id
        );

CREATE INDEX FK_price_store_id ON price
    (
     store_id
        );

-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Buyer
Drop table if exists buyer;
CREATE TABLE buyer
(
    "id"        serial       NOT NULL,
    first_name  varchar(30)  NOT NULL,
    second_name varchar(30)  NULL,
    surname     varchar(30)  NOT NULL,
    email       varchar(50)  NULL,
    phone       varchar(20)  NOT NULL,
    address     varchar(200) NULL,
    birthday    date         NULL,
    CONSTRAINT PK_buyer_id PRIMARY KEY ("id")
);

-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** "Order"
Drop table if exists purchase;
CREATE TABLE purchase
(
    "date"           date         NOT NULL,
    price_id         serial       NOT NULL,
    buyer_id         serial       NOT NULL,
    buyer_phone      varchar(20)  NOT NULL,
    delivery_address varchar(200) NOT NULL,
    "id"             serial       NOT NULL,
    CONSTRAINT PK_purchase_id PRIMARY KEY ("id"),
    CONSTRAINT FK_order_price_id FOREIGN KEY (price_id) REFERENCES price ("id"),
    CONSTRAINT FK_order_buyer_id FOREIGN KEY (buyer_id) REFERENCES buyer ("id")
);

CREATE INDEX FK_103 ON purchase
    (
     price_id
        );

CREATE INDEX FK_96 ON purchase
    (
     buyer_id
        );



COMMENT ON COLUMN purchase.delivery_address IS 'Адрес доставки (может отличаться от того, что у пользователя в профиле)';
COMMENT ON COLUMN purchase.buyer_phone IS 'Телефон покупателя (может отличаться от того, что у пользователя в профиле)';


-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** Delivery

CREATE TABLE delivery
(
    "id"            serial       NOT NULL,
    order_id        serial       NOT NULL,
    preferable_date date         NOT NULL,
    actual_date     date         NULL,
    address         varchar(200) NOT NULL,
    is_delivered    boolean      NOT NULL,
    CONSTRAINT PK_delivery PRIMARY KEY ("id"),
    CONSTRAINT FK_delivery_purchase FOREIGN KEY (order_id) REFERENCES purchase ("id")
);

CREATE INDEX FK_delivery_order_id ON Delivery
    (
     order_id
        );
