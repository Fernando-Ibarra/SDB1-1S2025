--- CREATE USER
--- CREATE TABLESPACE
CREATE TABLESPACE USERS
DATAFILE '/opt/oracle/oradata/FREE/FREEPDB1/users01.dbf'
SIZE 100M AUTOEXTEND ON;

-- CREATE NEW USER IN USERS TABLESPACE
CREATE USER
    C##fer
IDENTIFIED BY
    password123
DEFAULT TABLESPACE
    USERS
QUOTA UNLIMITED ON
    USERS;

-- GRANT PRIVILEGES
GRANT CONNECT, RESOURCE TO C##fer;

--- CREATE TABLES WITH CONSTRAINTS AND RELATIONSHIPS
CREATE TABLE CUSTOMER (
    id  INTEGER CONSTRAINT customer_id_pk PRIMARY KEY,
    national_id INTEGER CONSTRAINT customer_national_id_nn NOT NULL,
    name VARCHAR2(250) CONSTRAINT customer_name_nn NOT NULL,
    lastname VARCHAR2(250) CONSTRAINT customer_lastname_nn NOT NULL,
    email VARCHAR2(100) CONSTRAINT customer_email_uk UNIQUE,
    phone VARCHAR2(25) CONSTRAINT customer_phone_nn NOT NULL,
    active CHAR(1)
    -- CONSTRAINT customer_id_pk PRIMARY KEY (id)
    -- CONSTRAINT customer_email_uk UNIQUE (email)
);

CREATE TABLE ADDRESS (
    id INTEGER CONSTRAINT address_id_pk PRIMARY KEY,
    postal_code VARCHAR2(25) CONSTRAINT address_postal_code_nn NOT NULL,
    address VARCHAR2(150) CONSTRAINT address_address_nn NOT NULL,
    city VARCHAR2(100) CONSTRAINT address_city_nn NOT NULL,
    address_2 VARCHAR2(100),
    customer_id INTEGER CONSTRAINT address_customer_id_fk REFERENCES CUSTOMER(id) ON DELETE SET NULL
);

CREATE TABLE CATEGORY (
    id INTEGER CONSTRAINT category_id_pk PRIMARY KEY,
    name VARCHAR2(250) CONSTRAINT category_name_uk UNIQUE
);


CREATE TABLE PRODUCT (
    id INTEGER CONSTRAINT product_id_pk PRIMARY KEY,
    name VARCHAR2(250) CONSTRAINT product_name_nn NOT NULL,
    description VARCHAR2(500) CONSTRAINT product_description_ck CHECK (LENGTH(description) < 500),
    price NUMBER(10, 2) CONSTRAINT product_price_nn NOT NULL,
    stock INTEGER CONSTRAINT product_stock_nn NOT NULL,
    category_id INTEGER CONSTRAINT product_category_id_fk REFERENCES CATEGORY(id) ON DELETE SET NULL
);

CREATE TABLE IMAGE (
    id INTEGER CONSTRAINT image_id_pk PRIMARY KEY,
    url_path VARCHAR2(500) CONSTRAINT image_url_path_uk UNIQUE,
    product_id INTEGER CONSTRAINT image_product_id_fk REFERENCES PRODUCT(id) ON DELETE SET NULL,
    product_sku VARCHAR2(100) CONSTRAINT image_product_sku_uk UNIQUE
);

CREATE TABLE ORDER_CUSTOMER (
    id INTEGER CONSTRAINT order_customer_id_pk PRIMARY KEY,
    customer_id INTEGER CONSTRAINT order_customer_customer_id_fk REFERENCES CUSTOMER(id) ON DELETE SET NULL
);

CREATE TABLE ORDER_PRODUCT (
    id INTEGER CONSTRAINT order_product_id_pk PRIMARY KEY,
    order_id INTEGER CONSTRAINT order_product_order_id_fk REFERENCES ORDER_CUSTOMER(id) ON DELETE SET NULL,
    product_id INTEGER CONSTRAINT order_product_product_id_fk REFERENCES PRODUCT(id) ON DELETE SET NULL,
    quantity INTEGER CONSTRAINT order_product_quantity_ck CHECK (quantity > 0),
    price NUMBER(10, 2) CONSTRAINT order_product_price_ck CHECK (price > 0)
);

--- ALTER CONSTRAINTS

--- SHOW CONSTRAINTS
---- RESTRICCIONES BY TABLE
SELECT constraint_name, constraint_type, table_name, status
FROM user_constraints
WHERE table_name = 'ORDER_PRODUCT';
---- ALL CONSTRAINTS
SELECT owner, table_name, constraint_name, constraint_type
FROM all_constraints
ORDER BY owner, table_name;