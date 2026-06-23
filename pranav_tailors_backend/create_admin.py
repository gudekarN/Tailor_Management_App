import os
import psycopg2
from dotenv import load_dotenv
from utils.password_utils import hash_pin

# Load environment variables from .env
load_dotenv()

# Get the database URL
database_url = os.getenv("DATABASE_URL")

# Remove +asyncpg if present to use psycopg2 synchronously
if database_url and "+asyncpg" in database_url:
    database_url = database_url.replace("+asyncpg", "")

def create_admin():
    if not database_url:
        print("Error: DATABASE_URL not found in .env")
        return

    print("Hashing PINs...")
    manager_pin_hash = hash_pin("112233")
    employee_pin_hash = hash_pin("445566")

    conn = None
    cursor = None
    try:
        # Connect to PostgreSQL synchronously
        conn = psycopg2.connect(database_url)
        cursor = conn.cursor()

        # Check if users already exist to prevent duplicate key errors
        cursor.execute("SELECT phone FROM users WHERE phone IN ('9999999999', '8888888888')")
        existing_users = [row[0] for row in cursor.fetchall()]

        # Insert Manager
        if "9999999999" not in existing_users:
            # We hardcode the role literal to avoid psycopg2 Enum casting errors
            cursor.execute(
                """
                INSERT INTO users (name, phone, role, pin_hash, is_active)
                VALUES (%s, %s, 'manager', %s, %s)
                """,
                ("Manager", "9999999999", manager_pin_hash, True)
            )

        # Insert Employee
        if "8888888888" not in existing_users:
            cursor.execute(
                """
                INSERT INTO users (name, phone, role, pin_hash, is_active)
                VALUES (%s, %s, 'employee', %s, %s)
                """,
                ("Sunita", "8888888888", employee_pin_hash, True)
            )

        # Commit the transaction
        conn.commit()
        print("Users created successfully")

    except Exception as e:
        print(f"Error creating users: {e}")
        if conn:
            conn.rollback()
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

if __name__ == "__main__":
    create_admin()
