const oracledb = require('oracledb');

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

export const sdbConnection = async () => {
    try {
        // logger.log('USER_DB: ', process.env.USER_DB);
        // logger.log('PASSWORD_DB: ', process.env.PASSWORD_DB);
        // logger.log('CONNECT_STRING: ', process.env.CONNECT_STRING);
        const connection = await oracledb.getConnection({
            user          : "C##fernando",
            password      : "password123",
            connectString : "oracle-db-clase7:1521/FREE"
        });
        return connection;
    } catch (error) {
        console.log('Error: ', error);
    }
}