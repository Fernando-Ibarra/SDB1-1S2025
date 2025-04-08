# Clase 10

Levantar bases de datos

```bash
# oracle
docker pull container-registry.oracle.com/database/free:latest-lite

docker run --name oracle-lite-db \
-p 1521:1521 \
-e ORACLE_PWD=pass_1234 \
-e ORACLE_CHARACTERSET=AL32UTF8 \
-e ENABLE_ARCHIVELOG=true \
-e ENABLE_FORCE_LOGGING=true \
container-registry.oracle.com/database/free:latest-lite


# postgres
docker pull postgres
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

docker run -d \
--name postgres-db \
-p 5432:5432 \
-e POSTGRES_USER=postgres \
-e POSTGRES_PASSWORD=pass_1234 \
-e POSTGRES_DB=postgres \
postgres

# sybase
docker pull datagrip/sybase
docker run -d -t -p 5000:5000 datagrip/sybase162

docker run -d \
--name sybase-db \
-p 5000:5000 \
datagrip/sybase162
```

## ORACLE

```sql
-- =========================
-- CREACIÓN DE TABLAS
-- =========================

-- Tabla de clientes
CREATE TABLE customers (
    customer_id NUMBER GENERATED ALWAYS AS IDENTITY,
    first_name  VARCHAR2(50) NOT NULL,
    last_name   VARCHAR2(50) NOT NULL,
    email       VARCHAR2(100),
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);

-- Tabla de pedidos
CREATE TABLE orders (
    order_id    NUMBER GENERATED ALWAYS AS IDENTITY,
    customer_id NUMBER NOT NULL,
    order_date  DATE NOT NULL,
    status      VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customers 
        FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);

-- Tabla de productos
CREATE TABLE products (
    product_id   NUMBER GENERATED ALWAYS AS IDENTITY,
    product_name VARCHAR2(100) NOT NULL,
    price        NUMBER(10,2)  NOT NULL,
    CONSTRAINT pk_products PRIMARY KEY (product_id)
);

-- Tabla de detalle de pedidos
CREATE TABLE order_items (
    order_id   NUMBER NOT NULL,
    product_id NUMBER NOT NULL,
    quantity   NUMBER NOT NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_orders 
        FOREIGN KEY (order_id) 
        REFERENCES orders (order_id),
    CONSTRAINT fk_order_items_products 
        FOREIGN KEY (product_id) 
        REFERENCES products (product_id)
);

-- =========================
-- INSERCIÓN DE DATOS
-- =========================
INSERT INTO customers (first_name, last_name, email)
VALUES ('Juan', 'Pérez', 'juan.perez@example.com');

INSERT INTO customers (first_name, last_name, email)
VALUES ('María', 'López', 'm.lopez@example.com');

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, SYSDATE, 'Procesando');

INSERT INTO orders (customer_id, order_date, status)
VALUES (2, SYSDATE, 'Enviado');

INSERT INTO products (product_name, price)
VALUES ('Laptop X', 1200.00);

INSERT INTO products (product_name, price)
VALUES ('Mouse Óptico', 15.50);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 1, 2);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 2, 1);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (2, 2, 3);

COMMIT;

-- =========================
-- CONSULTA
-- =========================

SELECT UPPER(c.first_name) AS nombre, 
    LOWER(c.last_name)  AS apellido, 
    o.order_date AS fecha_pedido, 
    p.product_name AS producto, 
    oi.quantity AS cantidad
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
FETCH FIRST 1 ROWS ONLY; -- WHERE ROWNUM = 1


SELECT 
    UPPER(a.first_name) AS nombre, 
    LOWER(a.last_name)  AS apellido, 
    b.order_date AS fecha_pedido, 
    d.product_name AS producto, 
    c.quantity AS cantidad
FROM customers a
JOIN orders b
    ON a.customer_id = b.customer_id
JOIN order_items c 
    ON b.order_id = c.order_id
JOIN products d 
    ON c.product_id = d.product_id
FETCH FIRST 1 ROWS ONLY;
```

## POSTGRES

```sql
-- =========================
-- CREACIÓN DE TABLAS
-- =========================

-- Tabla de clientes
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100)
);

-- Tabla de pedidos
CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date  DATE NOT NULL,
    status      VARCHAR(20) NOT NULL,
    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);

-- Tabla de productos
CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price        NUMERIC(10,2) NOT NULL
);

-- Tabla de detalle de pedidos
CREATE TABLE order_items (
    order_id   INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)
);

-- =========================
-- INSERCIÓN DE DATOS
-- =========================

INSERT INTO customers (first_name, last_name, email)
VALUES ('Juan', 'Pérez', 'juan.perez@example.com'),
       ('María', 'López', 'm.lopez@example.com');

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, CURRENT_DATE, 'Procesando'),
       (2, CURRENT_DATE, 'Enviado');

INSERT INTO products (product_name, price)
VALUES ('Laptop X', 1200.00),
       ('Mouse Óptico', 15.50);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 1, 2),
       (1, 2, 1),
       (2, 2, 3);

-- =========================
-- CONSULTA 
-- =========================

SELECT 
    UPPER(c.first_name) AS nombre, 
    LOWER(c.last_name)  AS apellido, 
    o.order_date AS fecha_pedido, 
    p.product_name AS producto, 
    oi.quantity AS cantidad
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
LIMIT 1;

SELECT 
    UPPER(a.first_name) AS nombre, 
    LOWER(a.last_name)  AS apellido, 
    b.order_date AS fecha_pedido, 
    d.product_name AS producto, 
    c.quantity AS cantidad
FROM customers a
JOIN orders b
    ON a.customer_id = b.customer_id
JOIN order_items c 
    ON b.order_id = c.order_id
JOIN products d 
    ON c.product_id = d.product_id
LIMIT 1;

```

## SYBASE

```sql
-- =========================
-- CREACIÓN DE TABLAS
-- =========================

CREATE TABLE customers (
    customer_id INT IDENTITY NOT NULL,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100),
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);

CREATE TABLE orders (
    order_id    INT IDENTITY NOT NULL,
    customer_id INT NOT NULL,
    order_date  DATETIME NOT NULL,
    status      VARCHAR(20) NOT NULL,
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customers 
        FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);

CREATE TABLE products (
    product_id   INT IDENTITY NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    price        DEC(10,2) NOT NULL,
    CONSTRAINT pk_products PRIMARY KEY (product_id)
);

CREATE TABLE order_items (
    order_id   INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_orders 
        FOREIGN KEY (order_id) 
        REFERENCES orders (order_id),
    CONSTRAINT fk_order_items_products 
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)
);

-- =========================
-- INSERCIÓN DE DATOS
-- =========================

INSERT INTO customers (first_name, last_name, email)
VALUES ('Juan', 'Pérez', 'juan.perez@example.com');

INSERT INTO customers (first_name, last_name, email)
VALUES ('María', 'López', 'm.lopez@example.com');

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, GETDATE(), 'Procesando');

INSERT INTO orders (customer_id, order_date, status)
VALUES (2, GETDATE(), 'Enviado');

INSERT INTO products (product_name, price)
VALUES ('Laptop X', 1200.00);

INSERT INTO products (product_name, price)
VALUES ('Mouse Óptico', 15.50);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 1, 2);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 2, 1);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (2, 2, 3);

-- =========================
-- CONSULTA
-- =========================

SELECT TOP 1
    UPPER(c.first_name) AS nombre_mayus,
    c.last_name         AS apellido,
    o.order_date        AS fecha_pedido,
    p.product_name      AS producto,
    oi.quantity         AS cantidad
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;

SELECT TOP 1
    UPPER(a.first_name) AS nombre_mayus,
    LOWER(a.last_name) AS apellido,
    b.order_date        AS fecha_pedido,
    d.product_name      AS producto,
    c.quantity         AS cantidad
FROM customers a
JOIN orders b
    ON a.customer_id = b.customer_id
JOIN order_items c
    ON b.order_id = c.order_id
JOIN products d
    ON c.product_id = d.product_id;
```
