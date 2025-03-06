# Pasos para crear un backend con NestJS

## Crear Backend

```bash
# instalar nest
npm i -g @nestjs/cli

# crear proyecto
nest new <nombre-proyecto>

# crear recursos
nest g resource <nombre-recurso> --no-spec

# delete prettier
yarn remove prettier eslint-plugin-prettier eslint-config-prettier

# instalar oracle-db
yarn add oracledb

# instalar validadores
yarn add class-validator class-transformer

# instalar variables de entorno
yarn add  @nestjs/config
```

## Ejmplos de creación de recursos

Ruta:

```
http://localhost:3000/orders
```

Recurso:

```bash
# crear recurso
nest g resource orders --no-spec
```

Uso:

```bash
# Se crean los archivos:
# src/orders/orders.controller.ts -> Donde se definen los endpoints
# src/orders/orders.module.ts -> Donde se define el módulo
# src/orders/orders.service.ts -> Implementación de la lógica de negocio (endpoint)
```
