import { Body, Controller, Get, Post } from '@nestjs/common';
import { CustomerService } from './customer.service';
import { CreateCustomerDto } from './dto/create-customer.dto';

@Controller('customer')
export class CustomerController {
  constructor(private readonly customerService: CustomerService) {}

  @Get()
  findAll() {
    return this.customerService.findAll();
  }
  
  // localhost:3000/api/customer
  @Post()
  create( @Body() createCustomerDto: CreateCustomerDto ) {
    return this.customerService.create(createCustomerDto);
  }
}
