const oracledb = require('oracledb');

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

const insert  = `INSERT INTO C##fer.CUSTOMER (id, national_id, name, lastname, email, phone, active) VALUES (1,123456789, 'John', 'Doe', 'johndoe@gmail.com', '123456789', 'Y')`;
const select  = `SELECT * FROM C##fer.CUSTOMER WHERE id = 1`;
const select2 = `SELECT * FROM ALL_TABLES WHERE TABLE_NAME = 'CUSTOMER'`;
const count = `SELECT COUNT(*) FROM C##fer.CUSTOMER`;

export const dbConnection = async () => {
    try {
        const connection = await oracledb.getConnection({
            user          : "C##fer",
            password      : 'password123',
            connectString : "db-lite:1521/FREE",
        });
        const result = await connection.execute(
            select
        );
        await connection.close();
        return result;
    } catch (error) {
        console.log('Error: ', error);
    }
}