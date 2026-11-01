# RA2 · Conectores de datos ITC

Continuación del RA1 de Acceso a Datos: los CSV de clientes y proyectos se
evolucionan a una base relacional SQLite local. C++ crea el esquema y opera
con el conector nativo winsqlite3; Python consulta esa misma base mediante
sqlite3.

## Ejecutar

Desde 02-proyecto-unidad/itc-conectores:

    build.cmd
    bin\itc_conectores.exe
    python consultar.py

La base se crea como data/itc_conectores.sqlite y no se guarda en Git. Los
datos son ficticios. winsqlite3 es embebido; para una implantación real ITC se
usaría PostgreSQL como gestor independiente mediante un conector específico.
