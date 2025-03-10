-- 
ALTER DATABASE DATAFILE '/opt/oracle/oradata/FREE/users01.dbf' AUTOEXTEND ON MAXSIZE UNLIMITED;

-- CREATE NEW USER IN USERS TABLESPACE
CREATE USER
    C##fernando
IDENTIFIED BY
    password123
DEFAULT TABLESPACE
    USERS
QUOTA UNLIMITED ON
    USERS;

-- GRANT PRIVILEGES
GRANT CONNECT, RESOURCE TO C##fernando;

--- CREATE TABLES WITH CONSTRAINTS AND RELATIONSHIPS
CREATE TABLE CUSTOMER (
    id  INTEGER CONSTRAINT customer_id_pk PRIMARY KEY,
    national_id INTEGER CONSTRAINT customer_national_id_nn NOT NULL,
    name VARCHAR2(250) CONSTRAINT customer_name_nn NOT NULL,
    lastname VARCHAR2(250) CONSTRAINT customer_lastname_nn NOT NULL,
    email VARCHAR2(100) CONSTRAINT customer_email_uk UNIQUE,
    phone VARCHAR2(25) CONSTRAINT customer_phone_nn NOT NULL,
    active CHAR(1) CONSTRAINT customer_active_ck CHECK (active IN ('Y', 'N')),
    confirmed_email BOOLEAN CONSTRAINT customer_active_email_ck CHECK (confirmed_email IN (0, 1))
);

-- INSERT DATA INTO CUSTOMER TABLE
INSERT INTO CUSTOMER (id, national_id, name, lastname, email, phone, active, confirmed_email) 
VALUES (1, 123456789, 'Juan', 'Pérez', 'juan.perez@example.com', '50212345678', 'Y', 1);

INSERT INTO CUSTOMER (id, national_id, name, lastname, email, phone, active, confirmed_email) 
VALUES (2, 987654321, 'María', 'López', 'maria.lopez@example.com', '50287654321', 'N', 0);

INSERT INTO CUSTOMER (id, national_id, name, lastname, email, phone, active, confirmed_email) 
VALUES (3, 456789123, 'Carlos', 'González', 'carlos.gonzalez@example.com', '50245678912', 'Y', 1);

INSERT INTO CUSTOMER (id, national_id, name, lastname, email, phone, active, confirmed_email) 
VALUES (4, 741852963, 'Ana', 'Ramírez', 'ana.ramirez@example.com', '50274185296', 'Y', 0);

INSERT INTO CUSTOMER (id, national_id, name, lastname, email, phone, active, confirmed_email) 
VALUES (5, 369258147, 'Luis', 'Martínez', 'luis.martinez@example.com', '50236925814', 'N', 1);


-- UPDATE DATA IN CUSTOMER TABLE
UPDATE CUSTOMER 
SET active = 'Y', confirmed_email = 1 
WHERE id = 2;

UPDATE CUSTOMER 
SET phone = '50299998888' 
WHERE id = 3;

-- DELETE DATA FROM CUSTOMER TABLE
DELETE FROM CUSTOMER 
WHERE id = 5;

--  SELECT DATA FROM CUSTOMER TABLE
SELECT
    *
FROM
    CUSTOMER;

-- DROP TABLE CUSTOMER
DROP TABLE CUSTOMER;
