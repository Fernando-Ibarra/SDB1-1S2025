import { Injectable } from '@nestjs/common';
import { CreateClientDto } from './dto/create-client.dto';
import { UpdateClientDto } from './dto/update-client.dto';
import { dbConnection } from 'src/common/helper/db-connection.helper';

@Injectable()
export class ClientsService {
  async create(createClientDto: CreateClientDto) {
    const { nationalId, name, lastname, email, phone, active, confirmed_email } = createClientDto;
    try {
      // Count the number of clients
      const counClietnSql = `SELECT COUNT(*) AS totalClients FROM CUSTOMER`;
      const newClientSql = `INSERT INTO CUSTOMER (ID, NATIONAL_ID, NAME, LASTNAME, EMAIL, PHONE, ACTIVE, CONFIRMED_EMAIL) VALUES (:id, :nationalId, :name, :lastname, :email, :phone, :active, :confirmed_email)`;

      // Get the number of clients
      let cnn = await dbConnection();
      let result = await cnn.execute(
        counClietnSql, 
      );
      const newClientId = result.rows[0].TOTALCLIENTS + 1;
      console.log({
        id: newClientId,
        nationalId: Number(nationalId),
        name,
        lastname,
        email,
        phone,
        active,
        confirmed_email: Number(confirmed_email)
      })

      // insert client
      cnn = await dbConnection();
      const newClient = await cnn.execute(
        newClientSql, 
        {
          id: newClientId,
          nationalId: Number(nationalId),
          name,
          lastname,
          email,
          phone,
          active,
          confirmed_email: Number(confirmed_email)
        }
      );

      await cnn.commit();

      await cnn.close();
      return newClient;
    } catch (error) {
      console.log('Error: ', error);
    }
  }

  async findAll() {
    try {
      const sql = `SELECT * FROM CUSTOMER`;
      const cnn = await dbConnection();
      const result = await cnn.execute(sql);
      cnn.close();
      return result.rows;
    } catch (error) {
      console.log('Error: ', error);
    }
  }

  async findOne(id: number) {
    try {
      const sql = `SELECT * FROM CUSTOMER WHERE ID = :id`;
      const cnn = await dbConnection();
      const result = await cnn.execute(sql, { id });
      cnn.close();
      return result.rows[0];
    } catch (error) {
      console.log('Error: ', error);
    }
  }

  async update(id: number, updateClientDto: UpdateClientDto) {
    const { nationalId, name, lastname, phone, active, confirmed_email } = updateClientDto;
    try {
      // verify each if the values are comming to add them to the query
      let sql = `UPDATE CUSTOMER SET `;
      if (nationalId) {
        sql += `NATIONAL_ID = ${nationalId}, `;
      }
      if (name) {
        sql += `NAME = '${name}', `;
      }
      if (lastname) {
        sql += `LASTNAME = '${lastname}', `;
      }
      if (phone) {
        sql += `PHONE = '${phone}', `;
      }
      if (active) {
        sql += `ACTIVE = '${active}', `;
      }
      if (confirmed_email) {
        sql += `CONFIRMED_EMAIL = ${confirmed_email}, `;
      }

      sql = sql.slice(0, -2);
      sql += ` WHERE ID = ${id}`;
  
      const cnn = await dbConnection();
      const result = await cnn.execute(sql);
      await cnn.commit();
      await cnn.close();
      return result;
    } catch (error) {
      console.log('Error: ', error);
    }
  }

  async remove(id: number) {
    try {
      // delete
      // const sql = `DELETE FROM CUSTOMER WHERE ID = :id`;
      
      // deactivate client
      const sql = `UPDATE CUSTOMER SET ACTIVE = 'N' WHERE ID = :id`;

      const cnn = await dbConnection();
      const result = await cnn.execute(sql, { id });
      await cnn.commit();
      cnn.close();
      return result.rows;
    } catch (error) {
      console.log('Error: ', error);
    };
  }
}
