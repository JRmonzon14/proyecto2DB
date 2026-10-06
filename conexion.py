#modulo
import oracledb

#credenciales
DB_USER = "SYSTEM"
DB_PASSWORD = "jrmg2005"
DB_HOST = "localhost"
DB_PORT = 1521
DB_SID = "xe"

def get_connection():
    """
    Establece y retorna una conexión activa a Oracle DB utilizando el SID 'xe'.
    """
    try:
        dsn = oracledb.makedsn(DB_HOST, DB_PORT, sid=DB_SID)

        connection = oracledb.connect(
            user=DB_USER,
            password=DB_PASSWORD,
            dsn=dsn
        )
        return connection
    except Exception as e:
        # propacacion de errores
        raise Exception(f"Detalle técnico de Oracle: {str(e)}")