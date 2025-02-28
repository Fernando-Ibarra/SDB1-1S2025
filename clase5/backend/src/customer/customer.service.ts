import { Injectable } from '@nestjs/common';
import { dbConnection } from './helper/db-connection.helper';

@Injectable()
export class CustomerService {
  async findAll() {
    return await dbConnection();
  }
}
