# Proyecto 1 - NestJS - Oracle

## Backend

### Crear Backend

```bash
npm i -g @nestjs/cli

# crear proyecto
nest new <nombre-proyecto>

# crear recursos - <nombre-recurso> = clients
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

### Configuración del backend

1. Eliminar los archivos

- `src/app.controller.spec.ts`
- `src/app.controller.ts`
- `src/app.service.ts`

2. Borrar la referencias a los archivos eliminados en `src/app.module.ts`

```typescript
// src/app.module.ts
import { AppController } from './app.controller';
import { AppService } from './app.service';
```

```typescript
// src/app.module.ts after changes
import { Module } from '@nestjs/common';
import { ClientsModule } from './clients/clients.module';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    ConfigModule.forRoot(),
    ClientsModule
  ],
})
export class AppModule {}

```

3. Borrar la carpeta `src/test`

4. Agregar la configuración de la base de datos en el archivo `.env`

```env
PORT=3000
USER_DB="C##fer"
PASSWORD_DB="password123"
CONNECT_STRING="db-lite:1521/FREE"
```

5. Crear una carpeta llamada "common" dentro de src, dentro de ella crear otra carpeta llamada "helpers" y dentro de ella crear un archivo llamado `db-connection.helper.ts`

6. Borrar la carpeta `src/clientes/entities`

7. Configurar el dto para el recurso `clients`

```typescript
// src/clients/dto/create-client.dto.ts
```