START TRANSACTION;

CREATE TABLE buyer (
  id          varchar(50) NOT NULL,
  first_name  varchar(30) NOT NULL,
  second_name varchar(30),
  surname     varchar(60) NOT NULL,
  email       varchar(50) UNIQUE,
  phone       varchar(20) NOT NULL UNIQUE,
  address     varchar(200),
  birthday    date,
  user_type   varchar(50) NOT NULL,
  CONSTRAINT PK_buyer_id
    PRIMARY KEY (id));

COMMENT ON COLUMN buyer.user_type IS 'Тип пользователя: физическое лицо, юридическое лицо, etc';

CREATE TABLE category (
  id   varchar(50) NOT NULL,
  name varchar(255) NOT NULL,
  CONSTRAINT PK_product_category_id
    PRIMARY KEY (id));

COMMENT ON TABLE category IS 'Категории продуктов - некая группа, объединяющая товары по логическим признакам (например: спортивные товары, миксеры, спортивное питание, протеиновые батончики, и т.д.)';

CREATE TABLE country (
  id   varchar(50) NOT NULL,
  name varchar(255) NOT NULL UNIQUE,
  CONSTRAINT PK_country_id
    PRIMARY KEY (id));

COMMENT ON COLUMN country.name IS 'Имя страны';

CREATE TABLE manufacturer (
  id      varchar(50) NOT NULL,
  name    varchar(255) NOT NULL UNIQUE,
  phone   varchar(20) NOT NULL,
  address varchar(200) NOT NULL,
  url     varchar(255),
  CONSTRAINT PK_manufacturer_id
    PRIMARY KEY (id));

CREATE TABLE price (
  id         varchar(50) NOT NULL,
  product_id varchar(50) NOT NULL,
  store_id   varchar(50) NOT NULL,
  price      money NOT NULL,
  CONSTRAINT PK_price_id
    PRIMARY KEY (id),
  CONSTRAINT price_gte_zero
    CHECK (price >= 0::money));

COMMENT ON CONSTRAINT price_gte_zero ON price IS 'Проверка, что цена больше или равна нулю';

COMMENT ON COLUMN price.price IS 'цена продукта в конкретном магазине';

CREATE TABLE product (
  id                  varchar(50) NOT NULL,
  name                varchar(255) NOT NULL,
  supplier_id         varchar(50) NOT NULL,
  manufacturer_id     varchar(50) NOT NULL,
  product_category_id varchar(50) NOT NULL,
  weight_netto        int4 CHECK(weight_netto >= 0),
  weight_brutto       int4 CHECK(weight_brutto >= 0),
  width               numeric(19, 0),
  height              numeric(19, 0),
  length              numeric(19, 0),
  description         text NOT NULL,
  CONSTRAINT PK_product_id
    PRIMARY KEY (id));

COMMENT ON COLUMN product.weight_netto IS 'Вес продукта в граммах без упаковки';

COMMENT ON COLUMN product.weight_brutto IS 'Вес продукта в граммах c упаковкой';

CREATE TABLE product_category (
  category_id varchar(50) NOT NULL,
  product_id  varchar(50) NOT NULL,
  PRIMARY KEY (category_id,
  product_id));

CREATE TABLE purchase (
  id               varchar(50) NOT NULL,
  price_id         varchar(50) NOT NULL,
  buyer_id         varchar(50) NOT NULL,
  "date"           date NOT NULL,
  buyer_phone      varchar(20) NOT NULL,
  delivery_address varchar(200),
  CONSTRAINT PK_purchase_id
    PRIMARY KEY (id));

COMMENT ON COLUMN purchase.buyer_phone IS 'Телефон покупателя (может отличаться от того, что у пользователя в профиле)';

COMMENT ON COLUMN purchase.delivery_address IS 'Адрес доставки (может отличаться от того, что у пользователя в профиле)';

CREATE TABLE region (
  id         varchar(50) NOT NULL,
  name       varchar(50) NOT NULL,
  country_id varchar(50) NOT NULL,
  CONSTRAINT PK_region_id
    PRIMARY KEY (id));

CREATE TABLE store (
  id        varchar(50) NOT NULL,
  region_id varchar(50) NOT NULL,
  name      varchar(255) NOT NULL,
  CONSTRAINT PK_store_id
    PRIMARY KEY (id));

CREATE TABLE supplier (
  id      varchar(50) NOT NULL,
  name    varchar(50) NOT NULL,
  phone   varchar(20) NOT NULL,
  address varchar(200) NOT NULL,
  url     varchar(255),
  CONSTRAINT PK_supplier_id
    PRIMARY KEY (id));

COMMENT ON COLUMN supplier.url IS 'ссылка на web страницу поставщика';

CREATE INDEX category_name
  ON category (name);

COMMENT ON INDEX category_name IS 'Индекс для поиска товаров в определенной категории, задаваемой именем (например, все товары в категории "спортивное питание"';

CREATE UNIQUE INDEX country_name
  ON country (name);

CREATE UNIQUE INDEX manufacturer_name
  ON manufacturer (name);

CREATE INDEX price_product_id
  ON price (product_id);

CREATE INDEX price_store_id
  ON price (store_id);

CREATE INDEX product_name_product_category_id
  ON product (name, product_category_id);

COMMENT ON INDEX product_name_product_category_id IS 'Поиск продукта по имени и категории (например, "Аленка, молочный шоколад")';

CREATE INDEX product_manufacturer_id_product_category_id
  ON product (manufacturer_id, product_category_id);

COMMENT ON INDEX product_manufacturer_id_product_category_id IS 'Поиск по производителю и категории (например, "Toyota, Воздушный фильтр")';

CREATE INDEX product_supplier_id
  ON product (supplier_id);

CREATE INDEX purchase_price_id
  ON purchase (price_id);

CREATE INDEX purchase_buyer_id
  ON purchase (buyer_id);

CREATE INDEX region_country_id
  ON region (country_id);

CREATE UNIQUE INDEX region_name_country_id
  ON region (name, country_id);

COMMENT ON INDEX region_name_country_id IS 'Название региона должно быть уникальным в рамках страны';

CREATE INDEX store_region_id
  ON store (region_id);

ALTER TABLE product_category ADD CONSTRAINT FKproduct_ca155888 FOREIGN KEY (category_id) REFERENCES category (id);

ALTER TABLE product_category ADD CONSTRAINT FKproduct_ca913184 FOREIGN KEY (product_id) REFERENCES product (id);

ALTER TABLE purchase ADD CONSTRAINT FK_order_buyer_id FOREIGN KEY (buyer_id) REFERENCES buyer (id);

ALTER TABLE purchase ADD CONSTRAINT FK_order_price_id FOREIGN KEY (price_id) REFERENCES price (id);

ALTER TABLE price ADD CONSTRAINT FK_price_product_id FOREIGN KEY (product_id) REFERENCES product (id);

ALTER TABLE price ADD CONSTRAINT FK_price_store_id FOREIGN KEY (store_id) REFERENCES store (id);

ALTER TABLE product ADD CONSTRAINT FK_product_manufacturer_id FOREIGN KEY (manufacturer_id) REFERENCES manufacturer (id);

ALTER TABLE product ADD CONSTRAINT FK_product_product_category_id FOREIGN KEY (product_category_id) REFERENCES category (id);

ALTER TABLE product ADD CONSTRAINT FK_product_supplier_id FOREIGN KEY (supplier_id) REFERENCES supplier (id);

ALTER TABLE region ADD CONSTRAINT FK_region_country_id FOREIGN KEY (country_id) REFERENCES country (id);

ALTER TABLE store ADD CONSTRAINT FK_store_region_id FOREIGN KEY (region_id) REFERENCES region (id);

COMMIT;
