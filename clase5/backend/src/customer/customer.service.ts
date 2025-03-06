import { Injectable } from '@nestjs/common';
import { dbConnection } from './helper/db-connection.helper';
import { CreateCustomerDto } from './dto/create-customer.dto';

@Injectable()
export class CustomerService {
  async findAll() {
    // const cnn = await dbConnection();
    // await cnn.execute('SELECT * FROM C##fer.CUSTOMER', [], { outFormat: oracledb.OUT_FORMAT_OBJECT });
    // return await cnn.close();
    return await dbConnection();
  }

  async create(
    createCustomerDto: CreateCustomerDto
  ) {
    return createCustomerDto; 
  }
}
