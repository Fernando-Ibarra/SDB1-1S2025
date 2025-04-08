CREATE TABLE Clientes (
    id_cliente NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    correo VARCHAR2(100)
);

CREATE TABLE Pedidos (
    id_pedido NUMBER PRIMARY KEY,
    id_cliente NUMBER,
    fecha_pedido DATE,
    total NUMBER(10,2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE SEQUENCE id_cliente_seq
START WITH 1
INCREMENT BY 1
NOCACHE NOCYCLE;

CREATE SEQUENCE id_pedido_seq
START WITH 101
INCREMENT BY 1
NOCACHE NOCYCLE;

INSERT INTO Clientes (id_cliente, nombre, correo) 
VALUES (id_cliente_seq.NEXTVAL, 'Juan Pérez', 'juan@email.com');

INSERT INTO Clientes (id_cliente, nombre, correo) 
VALUES (id_cliente_seq.NEXTVAL, 'María López', 'maria@email.com');

INSERT INTO Clientes (id_cliente, nombre, correo) 
VALUES (id_cliente_seq.NEXTVAL, 'Carlos Gómez', 'carlos@email.com');


INSERT INTO Pedidos (id_pedido, id_cliente, fecha_pedido, total) 
VALUES (id_pedido_seq.NEXTVAL, 1, TO_DATE('2024-03-10', 'YYYY-MM-DD'), 250.00);

INSERT INTO Pedidos (id_pedido, id_cliente, fecha_pedido, total) 
VALUES (id_pedido_seq.NEXTVAL, 2, TO_DATE('2024-03-11', 'YYYY-MM-DD'), 500.00);

INSERT INTO Pedidos (id_pedido, id_cliente, fecha_pedido, total) 
VALUES (id_pedido_seq.NEXTVAL, NULL, TO_DATE('2024-03-12', 'YYYY-MM-DD'), 750.00);

SELECT * 
FROM Clientes 
NATURAL JOIN Pedidos;

SELECT COUNT(*)
FROM Clientes 
NATURAL JOIN Pedidos;

SELECT * 
FROM Clientes 
CROSS JOIN Pedidos;

SELECT COUNT(*) 
FROM Clientes 
CROSS JOIN Pedidos;

SELECT * 
FROM Clientes 
JOIN Pedidos USING (id_cliente);

SELECT * 
FROM Clientes 
JOIN Pedidos ON Clientes.id_cliente = Pedidos.id_cliente;

SELECT * 
FROM Clientes 
LEFT OUTER JOIN Pedidos 
ON Clientes.id_cliente = Pedidos.id_cliente;

SELECT * 
FROM Clientes 
RIGHT OUTER JOIN Pedidos 
ON Clientes.id_cliente = Pedidos.id_cliente;

SELECT * 
FROM Clientes 
FULL OUTER JOIN Pedidos 
ON Clientes.id_cliente = Pedidos.id_cliente;

SELECT COUNT(*)
FROM Clientes 
FULL OUTER JOIN Pedidos 
ON Clientes.id_cliente = Pedidos.id_cliente;