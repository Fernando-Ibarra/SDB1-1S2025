from typing import Union
import oracledb
from pydantic import BaseModel
from typing import Optional
from fastapi import FastAPI

# Define the model
class Customer(BaseModel):
    nationalId: int
    name: str
    lastname: str
    email: str
    phone: str
    active: str
    confirmed_email: int

class CustomerPatch(BaseModel):
    nationalId: Optional[int] = None
    name: Optional[str] = None
    lastname: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    active: Optional[str] = None
    confirmed_email: Optional[int] = None

app = FastAPI(root_path="/api")

dsn = f'C##fernando/password123@localhost:1522/FREE'

@app.post("/clients")
def create_client(customer: Customer):
    # Connect to the database
    connection = oracledb.connect(dsn)
    cursor = connection.cursor()
    
    # Count the number of clients
    cursor.execute("SELECT COUNT(*) AS totalClients FROM CUSTOMER")
    totalClients = cursor.fetchone()[0]

    # Execute the query
    cursor.execute(
        f"INSERT INTO CUSTOMER (ID, NATIONAL_ID, NAME, LASTNAME, EMAIL, PHONE, ACTIVE, CONFIRMED_EMAIL) VALUES (:id, :nationalId, :name, :lastName, :email, :phone, :active, :confirmed_email)",
        [totalClients + 1, customer.nationalId, customer.name, customer.lastname, customer.email, customer.phone, customer.active, customer.confirmed_email]
    )
    
    # Commit the transaction
    connection.commit()

    # Close the cursor and the connection
    cursor.close()
    connection.close()

    return {"message": "Client created successfully"}


@app.get("/")
def read_root():
    # Connect to the database
    connection = oracledb.connect(dsn)
    cursor = connection.cursor()

    # Execute the query
    cursor.execute("select * from CUSTOMER")
    
    # format the data
    columns = [col.name for col in cursor.description]
    cursor.rowfactory = lambda *args: dict(zip(columns, args))
    data = cursor.fetchall()
    
    # Close the cursor and the connection
    cursor.close()
    connection.close()

    return data
    

@app.get("/clients/{client_id}")
def read_item(client_id: int):
    # Connect to the database
    connection = oracledb.connect(dsn)
    cursor = connection.cursor()

    # Execute the query
    cursor.execute(f"select * from CUSTOMER where id = {client_id}")

    # format the data
    columns = [col.name for col in cursor.description]
    cursor.rowfactory = lambda *args: dict(zip(columns, args))
    data = cursor.fetchone()

    # Close the cursor and the connection
    cursor.close()
    connection.close()

    return data

@app.patch("/clients/{client_id}")
def update_client(client_id: int, customer: CustomerPatch):
    # Connect to the database
    connection = oracledb.connect(dsn)
    cursor = connection.cursor()

    query = "UPDATE CUSTOMER SET "
    values = []

    # verify each if the values are comming to add them to the query
    if customer.nationalId:
        query += "NATIONAL_ID = :nationalId, "
        values.append(customer.nationalId)
    if customer.name:
        query += "NAME = :name, "
        values.append(customer.name)
    if customer.lastname:
        query += "LASTNAME = :lastname, "
        values.append(customer.lastname)
    if customer.email:
        query += "EMAIL = :email, "
        values.append(customer.email)
    if customer.phone:
        query += "PHONE = :phone, "
        values.append(customer.phone)
    if customer.active:
        query += "ACTIVE = :active, "
        values.append(customer.active)
    if customer.confirmed_email:
        query += "CONFIRMED_EMAIL = :confirmed_email, "
        values.append(customer.confirmed_email)
    # remove the last comma
    query = query[:-2]

    print(query)
    print(values)

    # Execute the query
    cursor.execute(
        f"{query} WHERE ID = {client_id}",
        values
    )

    # Commit the transaction
    connection.commit()

    # Close the cursor and the connection
    cursor.close()
    connection.close()

    return {"message": "Client updated successfully"}

@app.delete("/clients/{client_id}")
def delete_client(client_id: int):
    # Connect to the database
    connection = oracledb.connect(dsn)
    cursor = connection.cursor()

    # Execute the query
    cursor.execute(f"UPDATE CUSTOMER SET ACTIVE = 'N' WHERE ID = {client_id}")

    # Commit the transaction
    connection.commit()

    # Close the cursor and the connection
    cursor.close()
    connection.close()

    return {"message": "Client deleted successfully"}