drop tablespace if exists storedb_tablespace;
create tablespace storedb_tablespace location '/usr/storedb/tablespaces';

create database storedb tablespace storedb_tablespace;

start transaction;

create role storedb_admin with password 'qwerty';
create role web_app with password 'qwerty';
create role manager with password 'qwerty';
create role analyst with password 'qwerty';

create schema if not exists sales;
create schema if not exists geo;
create schema if not exists product;


-- Buyer
CREATE TABLE sales.buyer
(
    id          serial,
    first_name  varchar(60) NOT NULL,
    second_name varchar(60),
    surname     varchar(60) NOT NULL,
    email       varchar(50) UNIQUE,
    phone       varchar(20) NOT NULL UNIQUE,
    address     varchar(200),
    birthday    date,
    legal_form  varchar(50) NOT NULL,
    CONSTRAINT PK_buyer_id PRIMARY KEY (id)
);
COMMENT ON COLUMN sales.buyer.legal_form IS 'Тип пользователя: физическое лицо, юридическое лицо, etc';

-- Country
CREATE TABLE geo.country
(
    id   serial,
    name varchar(255) NOT NULL UNIQUE,
    CONSTRAINT PK_country_id PRIMARY KEY (id)
);
COMMENT ON COLUMN geo.country.name IS 'Название страны';

-- Region
CREATE TABLE geo.region
(
    id         serial,
    name       varchar(50) NOT NULL,
    country_id integer NOT NULL,
    CONSTRAINT PK_region_id PRIMARY KEY (id),
    CONSTRAINT FK_country_id FOREIGN KEY (country_id) REFERENCES geo.country (id)

);

-- Category
CREATE TABLE product.category
(
    id   serial,
    name varchar(255) NOT NULL UNIQUE,
    CONSTRAINT PK_product_category_id PRIMARY KEY (id)
);
COMMENT ON TABLE product.category IS 'Категории продуктов - некая группа, объединяющая товары по логическим признакам (например: спортивные товары, миксеры, спортивное питание, протеиновые батончики, и т.д.)';

-- Manufacturer
CREATE TABLE product.manufacturer
(
    id      serial,
    name    varchar(255) NOT NULL UNIQUE,
    phone   varchar(20) ARRAY,
    address varchar(200) NOT NULL,
    url     varchar(255),
    CONSTRAINT PK_manufacturer_id PRIMARY KEY (id)
);
COMMENT ON COLUMN product.manufacturer.url IS 'ссылка на web страницу производителя';

-- Supplier
CREATE TABLE product.supplier
(
    id      serial,
    name    varchar(50)  NOT NULL,
    phone   varchar(20)  NOT NULL,
    address varchar(200) NOT NULL,
    url     varchar(255),
    CONSTRAINT PK_supplier_id PRIMARY KEY (id)
);
COMMENT ON COLUMN product.supplier.url IS 'ссылка на web страницу поставщика';

-- Price
CREATE TABLE product.price_list
(
    id         serial,
    product_id varchar(50) NOT NULL,
    store_id   varchar(50) NOT NULL,
    price      numeric     NOT NULL,
    CONSTRAINT PK_price_id PRIMARY KEY (id),
    CONSTRAINT price_gte_zero CHECK (price >= 0)
);
COMMENT ON CONSTRAINT price_gte_zero ON product.price_list IS 'Проверка, что цена больше или равна нулю';
COMMENT ON COLUMN product.price_list.price IS 'цена продукта в конкретном магазине';

-- Product
CREATE TABLE product.product
(
    id              serial,
    name            varchar(255) NOT NULL,
    supplier_id     bigint       NOT NULL,
    manufacturer_id bigint       NOT NULL,
    weight_net      integer CHECK (weight_net >= 0),
    weight_gross    integer CHECK (weight_gross >= 0),
    width           integer CHECK (width >= 0),
    height          integer CHECK (height >= 0),
    length          integer CHECK (length >= 0),
    description     text         NOT NULL,
    CONSTRAINT PK_product_id PRIMARY KEY (id),
    CONSTRAINT FK_supplier_id FOREIGN KEY (supplier_id) REFERENCES product.supplier (id),
    CONSTRAINT FK_manufacturer_id FOREIGN KEY (manufacturer_id) REFERENCES product.manufacturer (id)
);
COMMENT ON COLUMN product.product.weight_net IS 'Вес продукта в граммах без упаковки';
COMMENT ON COLUMN product.product.weight_gross IS 'Вес продукта в граммах c упаковкой';

-- Product_category
CREATE TABLE product.product_category
(
    category_id integer,
    product_id  bigint,
    PRIMARY KEY (category_id, product_id),
    CONSTRAINT FK_category_id FOREIGN KEY (category_id) REFERENCES product.category (id),
    CONSTRAINT FK_product_id FOREIGN KEY (product_id) REFERENCES product.product (id)
);

-- Purchase
CREATE TABLE sales.purchase
(
    id               serial,
    price_id         bigint,
    buyer_id         bigint,
    date             date        NOT NULL,
    buyer_phone      varchar(20) NOT NULL,
    delivery_address varchar(200),
    CONSTRAINT PK_purchase_id PRIMARY KEY (id),
    CONSTRAINT FK_price_id FOREIGN KEY (price_id) REFERENCES product.price_list (id),
    CONSTRAINT FK_buyer_id FOREIGN KEY (buyer_id) REFERENCES sales.buyer (id)
);
COMMENT ON COLUMN sales.purchase.buyer_phone IS 'Телефон покупателя (может отличаться от того, что у пользователя в профиле)';
COMMENT ON COLUMN sales.purchase.delivery_address IS 'Адрес доставки (может отличаться от того, что у пользователя в профиле). Может быть null, если товар забран самовывозом.';

-- Store
CREATE TABLE public.store
(
    id        serial,
    region_id integer,
    name      varchar(255) NOT NULL,
    CONSTRAINT PK_store_id PRIMARY KEY (id),
    CONSTRAINT FK_region_id FOREIGN KEY (region_id) REFERENCES geo.region (id)
);

COMMIT;