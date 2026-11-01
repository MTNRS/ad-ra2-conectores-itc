# Operaciones

El ejecutable C++ crea el esquema relacional y ejecuta una transacción de
datos ficticios. Un trigger registra cada alta de cliente en auditoría. La
consulta Python abre la misma SQLite para demostrar el segundo conector.

Si se migra a PostgreSQL, el trigger se sustituirá por una función almacenada
equivalente y el conector será pqxx o psycopg en un entorno aislado.
