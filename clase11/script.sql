-- ======================================
--          CREACIÓN DE TABLAS
-- ======================================

CREATE TABLE CLIENTES (
    CLIENTE_ID         NUMBER(6)      NOT NULL,
    NOMBRE             VARCHAR2(50)   NOT NULL,
    APELLIDO           VARCHAR2(50)   NOT NULL,
    FECHA_REGISTRO     DATE           NOT NULL,
    DIRECCION          VARCHAR2(100),
    SALARIO            NUMBER(8,2),
    COMISION_PCT       NUMBER(4,2),
    EXTENSION_INTERNET VARCHAR2(5),
    CONSTRAINT PK_CLIENTES PRIMARY KEY (CLIENTE_ID)
);

-- 3) Crear la tabla CUENTAS
CREATE TABLE CUENTAS (
    CUENTA_ID     NUMBER(10)     NOT NULL,
    CLIENTE_ID    NUMBER(6)      NOT NULL,
    BALANCE       NUMBER(12,2),
    FECHA_APERTURA DATE          NOT NULL,
    TIPO_CUENTA   VARCHAR2(20),
    CONSTRAINT PK_CUENTAS PRIMARY KEY (CUENTA_ID),
    CONSTRAINT FK_CLI_CUENTA FOREIGN KEY (CLIENTE_ID)
        REFERENCES CLIENTES (CLIENTE_ID)
);

-- ======================================
--       INSERTAR DATOS DE EJEMPLO
-- ======================================

INSERT INTO CLIENTES 
    (CLIENTE_ID, NOMBRE, APELLIDO, FECHA_REGISTRO, DIRECCION, SALARIO, COMISION_PCT, EXTENSION_INTERNET)
VALUES
    (1, 'JUAN', 'LOPEZ', TO_DATE('15/02/2022','DD/MM/YYYY'), 'CALLE PRINCIPAL 123', 1200, NULL, NULL);

INSERT INTO CLIENTES
    (CLIENTE_ID, NOMBRE, APELLIDO, FECHA_REGISTRO, DIRECCION, SALARIO, COMISION_PCT, EXTENSION_INTERNET)
VALUES
    (2, 'MARIA', 'RODRIGUEZ', TO_DATE('10/03/2021','DD/MM/YYYY'), 'AVENIDA CENTRAL 456', 2500, 0.10, 'mx');

INSERT INTO CLIENTES
    (CLIENTE_ID, NOMBRE, APELLIDO, FECHA_REGISTRO, DIRECCION, SALARIO, COMISION_PCT, EXTENSION_INTERNET)
VALUES
    (3, 'CARLOS', 'GOMEZ', TO_DATE('25/12/2020','DD/MM/YYYY'), 'CARRERA 7 # 88-90', 1800, NULL, 'co');

INSERT INTO CUENTAS
    (CUENTA_ID, CLIENTE_ID, BALANCE, FECHA_APERTURA, TIPO_CUENTA)
VALUES
    (1001, 1, 500.00, TO_DATE('16/02/2022','DD/MM/YYYY'), 'AHORROS');

INSERT INTO CUENTAS
    (CUENTA_ID, CLIENTE_ID, BALANCE, FECHA_APERTURA, TIPO_CUENTA)
VALUES
    (1002, 2, 1500.00, TO_DATE('11/03/2021','DD/MM/YYYY'), 'CORRIENTE');

INSERT INTO CUENTAS
    (CUENTA_ID, CLIENTE_ID, BALANCE, FECHA_APERTURA, TIPO_CUENTA)
VALUES
    (1003, 3, 0.00, TO_DATE('26/12/2020','DD/MM/YYYY'), 'AHORROS');

-- ======================================
--       Funciones de Caracteres
-- ======================================
SELECT 
    NOMBRE, 
    UPPER(NOMBRE)           AS NOMBRE_MAYUS,
    LOWER(APELLIDO)         AS APELLIDO_MINUS,
    INITCAP(NOMBRE||' '||APELLIDO) AS FULLNAME_INIC_MAYUS
FROM CLIENTES;

SELECT
    NOMBRE,
    APELLIDO,
    CONCAT(NOMBRE, APELLIDO)       AS NOMBRE_COMPLETO_1,
    NOMBRE || ' ' || APELLIDO      AS NOMBRE_COMPLETO_2,
    SUBSTR(APELLIDO,1,3)          AS APELLIDO_ACORTADO,
    LENGTH(NOMBRE)                AS LONGITUD_NOMBRE,
    INSTR(APELLIDO, 'O')          AS POSICION_O_EN_APELLIDO
FROM CLIENTES;

SELECT
    NOMBRE,
    LPAD(NOMBRE, 10, '*')         AS NOMBRE_LPAD,
    RPAD(APELLIDO, 10, '-')       AS APELLIDO_RPAD,
    TRIM('Z' FROM 'ZZZCARLOSZZ')  AS TRIMMED,
    REPLACE(APELLIDO, 'E', 'X')   AS REEMPLAZAR_E_CON_X
FROM CLIENTES

-- ======================================
--       Funciones Numéricas
-- ======================================
SELECT
    NOMBRE,
    SALARIO,
    ROUND(SALARIO, -1)                AS REDONDEO_DECENAS,
    TRUNC(SALARIO, 1)                 AS TRUNCADO_1_DECIMAL
FROM CLIENTES;

-- ======================================
--       Funciones de Fecha
-- ======================================
SELECT
    NOMBRE,
    FECHA_REGISTRO,
    SYSDATE                         AS FECHA_HOY,
    FECHA_REGISTRO + 30            AS MAS_30_DIAS,
    ADD_MONTHS(FECHA_REGISTRO, 6)  AS MAS_6_MESES,
    MONTHS_BETWEEN(SYSDATE, FECHA_REGISTRO) AS MESES_ENTRE_HOY_Y_REGISTRO,
    NEXT_DAY(SYSDATE, 'MONDAY')    AS PROXIMO_LUNES,
    LAST_DAY(SYSDATE)              AS ULTIMO_DIA_MES,
    ROUND(FECHA_REGISTRO, 'YEAR')  AS REDONDEA_ANO,
    TRUNC(FECHA_REGISTRO, 'MONTH') AS TRUNCA_MES
FROM CLIENTES;

-- ======================================
--       Funciones de Conversión
-- ======================================
SELECT 
    NOMBRE,
    SALARIO,
    TO_CHAR(SALARIO, '$99,999.99') AS SALARIO_FORMATO
FROM CLIENTES;

SELECT
    NOMBRE,
    FECHA_REGISTRO,
    TO_CHAR(FECHA_REGISTRO, 'fmDay, DD "de" Month YYYY') AS FECHA_CON_FORMATO
FROM CLIENTES;

SELECT
    NOMBRE,
    EXTENSION_INTERNET,
    TO_NUMBER('1,200','9,999')   AS EJEMPLO_TO_NUMBER
FROM CLIENTES
WHERE CLIENTE_ID = 1;

SELECT 
    TO_DATE('31-12-2025','DD-MM-YYYY') AS FECHA_EJEMPLO
FROM DUAL;

-- ======================================
--       Funciones para Valores Nulos (NVL, NVL2, NULLIF)
-- ======================================
SELECT
    NOMBRE,
    COMISION_PCT,
    NVL(COMISION_PCT, 0)               AS COMISION_NO_NULA,
    NVL(COMISION_PCT, 0) * SALARIO     AS TOTAL_CON_COMISION
FROM CLIENTES;

SELECT
    NOMBRE,
    SALARIO,
    COMISION_PCT,
    NVL2(COMISION_PCT,
         SALARIO + (SALARIO * COMISION_PCT), 
         SALARIO                             
        ) AS SALARIO_CON_O_SIN_COMISION
FROM CLIENTES;

SELECT
    NOMBRE,
    SALARIO,
    NULLIF(SALARIO, 1800) AS SALARIO_NULLIF_1800
FROM CLIENTES;

-- ======================================
--       Funciones para Valores Nulos (NVL, NVL2, NULLIF)
-- ======================================
SELECT
    NOMBRE,
    SALARIO,
    CASE
       WHEN SALARIO < 1500 THEN 'BAJO'
       WHEN SALARIO BETWEEN 1500 AND 2000 THEN 'MEDIO'
       ELSE 'ALTO'
    END AS RANGO_SALARIAL
FROM CLIENTES;

SELECT
    C.CUENTA_ID,
    CL.NOMBRE,
    C.TIPO_CUENTA,
    DECODE(C.TIPO_CUENTA,
           'AHORROS', 'CUENTA DE AHORROS',
           'CORRIENTE', 'CUENTA CORRIENTE',
           'TIPO DESCONOCIDO'
    ) AS DESCRIPCION
FROM CUENTAS C
JOIN CLIENTES CL ON C.CLIENTE_ID = CL.CLIENTE_ID;
