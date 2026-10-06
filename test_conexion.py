import conexion

def probar():
    conn = conexion.get_connection()
    if conn:
        print("¡Conexión exitosa a la base de datos Oracle (SID: xe)!")
        cursor = conn.cursor()
        cursor.execute("SELECT instance_name, status FROM v$instance")
        row = cursor.fetchone()
        if row:
            print(f"Instancia: {row[0]} | Estado: {row[1]}")
        conn.close()
    else:
        print("No se pudo establecer la conexión. Revisa que el servicio OracleServiceXE esté ejecutándose.")

if __name__ == "__main__":
    probar()