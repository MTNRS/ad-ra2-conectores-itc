import sqlite3
from pathlib import Path
RUTA=Path(__file__).parent/"data"/"itc_conectores.sqlite"
with sqlite3.connect(RUTA) as conexion:
    conexion.row_factory=sqlite3.Row
    for fila in conexion.execute("SELECT c.nombre, c.email, count(p.id) proyectos FROM clientes c LEFT JOIN proyectos p ON p.cliente_id=c.id GROUP BY c.id ORDER BY c.nombre"):
        print(f"{fila['nombre']} | {fila['email']} | proyectos: {fila['proyectos']}")
