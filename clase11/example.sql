DROP TABLE CLIENTES;
DROP TABLE CUENTAS;


CREATE TABLE CLIENTES (
    id          NUMBER(6)      NOT NULL,
    name        VARCHAR2(50)   NOT NULL,
    lastname    VARCHAR2(50)   NOT NULL,
    email    VARCHAR2(50)   NOT NULL,
    username    VARCHAR2(50)   NOT NULL,
    password    VARCHAR2(50)   NOT NULL,
    CONSTRAINT PK_CLIENTES PRIMARY KEY (id)
);


CREATE TABLE CUENTAS (
    id     NUMBER(10)     NOT NULL,
    client_id    NUMBER(6)      NOT NULL,
    amount       NUMBER(12,2),
    CONSTRAINT PK_CUENTAS PRIMARY KEY (id),
    CONSTRAINT FK_CLI_CUENTA FOREIGN KEY (client_id)
        REFERENCES CLIENTES (id)
);

CREATE OR REPLACE FUNCTION fn_current_money_by_client(
    p_client IN NUMBER,
    p_acc_no IN NUMBER
)
    RETURN NUMBER
IS
    v_balance NUMBER;
BEGIN
    -- 1) Validar si existe el cliente
    BEGIN
        SELECT id INTO v_balance
        FROM CLIENTES
        WHERE id = p_client;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Client not found');
    END;

    -- 2) Validar si existe la cuenta
    BEGIN
        SELECT id INTO v_balance
        FROM CUENTAS
        WHERE id = p_acc_no;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Account not found');
    END;

    -- 3) Validar que la cuenta pertenezca al cliente
    BEGIN
        SELECT client_id INTO v_balance
        FROM CUENTAS
        WHERE id = p_acc_no;

        IF v_balance != p_client THEN
            RAISE_APPLICATION_ERROR(-20005, 'Account does not belong to the client');
        END IF;
    END;

    -- 4) Retornar el saldo (amount) de la cuenta
    BEGIN
        SELECT amount INTO v_balance
        FROM CUENTAS
        WHERE id = p_acc_no;

        RETURN v_balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20006, 'Account not found');
    END;
END fn_current_money_by_client;
/

-- ======================================
-- TABLA CLIENTES
-- ======================================
INSERT INTO CLIENTES (id, name, lastname, email, username, password)
VALUES (1, 'Juan',   'Pérez',     'juan.perez@example.com',    'juanp',  'pass123');

INSERT INTO CLIENTES (id, name, lastname, email, username, password)
VALUES (2, 'María',  'López',     'maria.lopez@example.com',    'marial', 'mar2023');

INSERT INTO CLIENTES (id, name, lastname, email, username, password)
VALUES (3, 'Carlos', 'Gómez',     'carlos.gomez@example.com',   'cgomez', 'carl456');

INSERT INTO CLIENTES (id, name, lastname, email, username, password)
VALUES (4, 'Ana',    'Martínez',  'ana.mtz@example.com',        'amarti', 'ana789');

INSERT INTO CLIENTES (id, name, lastname, email, username, password)
VALUES (5, 'Luis',   'Rodríguez', 'luis.rod@example.com',       'lrodr',  'luisxyz');

INSERT INTO CUENTAS (id, client_id, amount)
VALUES (10001, 1, 1500.50);

INSERT INTO CUENTAS (id, client_id, amount)
VALUES (10002, 1,  450.00);

INSERT INTO CUENTAS (id, client_id, amount)
VALUES (10003, 2,  760.00);

INSERT INTO CUENTAS (id, client_id, amount)
VALUES (10004, 3, 1200.25);

INSERT INTO CUENTAS (id, client_id, amount)
VALUES (10005, 3,  200.75);

INSERT INTO CUENTAS (id, client_id, amount)
VALUES (10006, 4,  980.00);

INSERT INTO CUENTAS (id, client_id, amount)
VALUES (10007, 5, 2350.99);

INSERT INTO CUENTAS (id, client_id, amount)
VALUES (10008, 5, 100.00);

SELECT fn_current_money_by_client(1,10001) FROM DUAL;