from conexion import get_connection

def probar_conexion():
    """Comprueba si hay comunicación con la base de datos de Oracle."""
    try:
        conn = get_connection()
        if not conn:
            return False, "No se pudo conectar a Oracle. Verifica IP, Puerto, Servidor o credenciales en conexion.py."
        cursor = conn.cursor()
        cursor.execute("SELECT 1 FROM DUAL")
        cursor.close()
        conn.close()
        return True, "Conexión exitosa"
    except Exception as e:
        return False, f"Error de Oracle: {str(e)}"

def obtener_empleados_combo():
    try:
        conn = get_connection()
        if not conn: return []
        cursor = conn.cursor()
        cursor.execute("select id_empleado, nombre || ' ' || apellido from empleado order by id_empleado")
        datos = cursor.fetchall()
        cursor.close()
        conn.close()
        return datos
    except Exception as e:
        print(f"Error al cargar empleados: {e}")
        return []

def obtener_equipos_disponibles_combo():
    try:
        conn = get_connection()
        if not conn: return []
        cursor = conn.cursor()
        # Se busca sin importar si en Oracle dice 'DISPONIBLE', 'Disponible' o 'disponible '
        cursor.execute("select id_equipo, nombre || ' (' || marca || ')' from equipo where lower(trim(estado)) = 'disponible' order by id_equipo")
        datos = cursor.fetchall()
        cursor.close()
        conn.close()
        return datos
    except Exception as e:
        print(f"Error al cargar equipos: {e}")
        return []

def registrar_prestamo_completo(id_sol, id_emp, id_eq, f_uso, f_dev, motivo, obs):
    conn = get_connection()
    if not conn: return False, "Sin conexión a Oracle."
    try:
        cursor = conn.cursor()
        
        #cabecera
        cursor.execute("""
            insert into solicitud_prestamo (id_solicitud, fecha_solicitud, fecha_uso, fecha_devolucion, motivo, estado, id_empleado)
            values (:1, sysdate, to_date(:2, 'yyyy-mm-dd'), to_date(:3, 'yyyy-mm-dd'), :4, 'entregado', :5)
        """, [id_sol, f_uso, f_dev, motivo, id_emp])

        #detalle
        cursor.execute("""
            insert into detalle_solicitud (id_solicitud, id_equipo, observacion)
            values (:1, :2, :3)
        """, [id_sol, id_eq, obs])

        #persistencia
        conn.commit()
        cursor.close()
        conn.close()
        return True, "¡Préstamo procesado con éxito!"
    except Exception as e:
        return False, f"Error en Oracle: {str(e)}"

def obtener_prestamos_realizados():
    try:
        conn = get_connection()
        if not conn: return []
        cursor = conn.cursor()
        cursor.execute("""
            select 
                s.id_solicitud,
                e.nombre || ' ' || e.apellido as empleado,
                nvl(eq.nombre, 'Sin equipo') as equipo,
                to_char(s.fecha_uso, 'YYYY-MM-DD'),
                to_char(s.fecha_devolucion, 'YYYY-MM-DD'),
                nvl(d.observacion, 'Sin observación') as observacion,
                s.estado
            from solicitud_prestamo s
            join empleado e on s.id_empleado = e.id_empleado
            left join detalle_solicitud d on s.id_solicitud = d.id_solicitud
            left join equipo eq on d.id_equipo = eq.id_equipo
            order by s.id_solicitud desc
        """)
        datos = cursor.fetchall()
        cursor.close()
        conn.close()
        return datos
    except Exception as e:
        print(f"Error al cargar préstamos: {e}")
        return []

def obtener_estado_equipos():
    try:
        conn = get_connection()
        if not conn: return []
        cursor = conn.cursor()
        cursor.execute("select id_equipo, nombre, marca, estado from equipo order by id_equipo")
        datos = cursor.fetchall()
        cursor.close()
        conn.close()
        return datos
    except Exception as e:
        print(f"Error al cargar estado de equipos: {e}")
        return []