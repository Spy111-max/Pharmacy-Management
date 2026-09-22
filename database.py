import mysql.connector


def get_connection():
    return mysql.connector.connect(
        host="localhost",
        port=3306,
        user="pharmacy_user",
        password="pharmacy123",
        database="pharmacy_management"
    )