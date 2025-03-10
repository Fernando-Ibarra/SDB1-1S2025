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
