import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger, ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const logger = new Logger('Bootstrap');

  // set the global prefix for all routes
  app.setGlobalPrefix('api');

  // enable CORS
  app.enableCors();

  // enable validation pipe for all routes -> this will validate the incoming data
  app.useGlobalPipes(
    new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    })
  );

  await app.listen(process.env.PORT);
  logger.log(`App running on PORT: ${ process.env.PORT }`);
}
bootstrap();
