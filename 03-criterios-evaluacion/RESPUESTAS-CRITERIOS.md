# Criterios RA2

| Criterio | Evidencia |
|---|---|
| a) | README compara CSV previo, SQLite embebido y PostgreSQL independiente. |
| b) | SQLite es el gestor embebido; PostgreSQL queda documentado como destino independiente de ITC. |
| c-d) | C++ usa winsqlite3 y sqlite3_open_v2; Python usa sqlite3.connect. |
| e-f) | main.cpp crea clientes, proyectos y auditoría e inserta datos dentro de una transacción. |
| g-h) | El callback C++ y sqlite3.Row almacenan y muestran resultados de consultas. |
| i) | sqlite3_close libera la conexión en éxito y error. |
| j) | BEGIN y COMMIT protegen las inserciones relacionadas. |
| k) | SQLite no implementa procedimientos almacenados clásicos: el trigger registrar_cliente ejecuta la operación almacenada equivalente y escribe en auditoría al insertar. |
