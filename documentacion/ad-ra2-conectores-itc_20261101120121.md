# Reporte de proyecto

## Información de generación

- **Fecha:** 2026-11-01 12:01:21 +0100
- **Usuario:** freak
- **Equipo:** JARVIS
- **Sistema operativo:** Windows
- **Arquitectura:** x86_64
- **Directorio de ejecución:** `C:/Users/freak/DAM2`
- **Proyecto documentado:** `C:/Users/freak/Documents/DAM2-entregas/ad-ra2-conectores-itc`
- **HMAC-SHA-256 de autenticidad:** `c96d15eb62c9c7f095c39daf5e198bb3af1dfc368a1718cd5aca2e3ec8fe5285`

> El HMAC-SHA-256 se calcula sobre el documento completo usando un secreto incluido en el programa y 64 ceros en el propio campo del HMAC. El secreto no se escribe en el informe. Este mecanismo permite comprobar integridad y que el documento fue generado con el mismo secreto.

## Estructura del proyecto

```
C:/Users/freak/Documents/DAM2-entregas/ad-ra2-conectores-itc
├── .gitignore
├── 01-ejercicios
│   ├── 01-conexion-cpp.md
│   └── 02-consulta-python.md
├── 02-proyecto-unidad
│   └── itc-conectores
│       ├── OPERACIONES.md
│       ├── bin
│       │   └── itc_conectores.exe
│       ├── build.cmd
│       ├── consultar.py
│       ├── main.cpp
│       └── main.obj
├── 03-criterios-evaluacion
│   └── RESPUESTAS-CRITERIOS.md
└── README.md
```

## Bases de datos SQLite

Esta sección documenta únicamente el esquema de las bases SQLite detectadas. No se vuelcan registros ni datos de usuario.

No se han encontrado bases SQLite con extensiones .db, .sqlite o .sqlite3.

## Código (intercalado)

# ad-ra2-conectores-itc
**README.md**
```markdown
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
```
## 01-ejercicios
**01-conexion-cpp.md**
```markdown
# Conexión C++

sqlite3_open_v2 abre una base embebida. Se comprueba el código de retorno y
sqlite3_close libera el objeto de conexión al terminar.
```
**02-consulta-python.md**
```markdown
# Conector Python

Python usa sqlite3.connect sobre el mismo fichero y almacena los resultados
en objetos sqlite3.Row.
```
## 02-proyecto-unidad
### itc-conectores
**OPERACIONES.md**
```markdown
# Operaciones

El ejecutable C++ crea el esquema relacional y ejecuta una transacción de
datos ficticios. Un trigger registra cada alta de cliente en auditoría. La
consulta Python abre la misma SQLite para demostrar el segundo conector.

Si se migra a PostgreSQL, el trigger se sustituirá por una función almacenada
equivalente y el conector será pqxx o psycopg en un entorno aislado.
```
**consultar.py**
```python
import sqlite3
from pathlib import Path
RUTA=Path(__file__).parent/"data"/"itc_conectores.sqlite"
with sqlite3.connect(RUTA) as conexion:
    conexion.row_factory=sqlite3.Row
    for fila in conexion.execute("SELECT c.nombre, c.email, count(p.id) proyectos FROM clientes c LEFT JOIN proyectos p ON p.cliente_id=c.id GROUP BY c.id ORDER BY c.nombre"):
        print(f"{fila['nombre']} | {fila['email']} | proyectos: {fila['proyectos']}")
```
**main.cpp**
```cpp
#include <winsqlite3.h>
#include <iostream>
#include <stdexcept>
#include <string>

void ejecutar(sqlite3* db,const char* sql){char* error=nullptr;if(sqlite3_exec(db,sql,nullptr,nullptr,&error)!=SQLITE_OK){std::string m=error?error:"SQLite";sqlite3_free(error);throw std::runtime_error(m);}}
int imprimir(void*,int n,char** valores,char**){for(int i=0;i<n;i++)std::cout<<(valores[i]?valores[i]:"")<<(i+1<n?" | ":"\n");return 0;}
int main(){sqlite3* db=nullptr;try{sqlite3_open_v2("data/itc_conectores.sqlite",&db,SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE,nullptr);ejecutar(db,"PRAGMA foreign_keys=ON; CREATE TABLE IF NOT EXISTS clientes(id INTEGER PRIMARY KEY,nombre TEXT NOT NULL,email TEXT UNIQUE NOT NULL,estado TEXT NOT NULL); CREATE TABLE IF NOT EXISTS proyectos(id INTEGER PRIMARY KEY,cliente_id INTEGER NOT NULL,nombre TEXT NOT NULL,estado TEXT NOT NULL,FOREIGN KEY(cliente_id) REFERENCES clientes(id)); CREATE TABLE IF NOT EXISTS auditoria(id INTEGER PRIMARY KEY,momento TEXT NOT NULL,accion TEXT NOT NULL); CREATE TRIGGER IF NOT EXISTS registrar_cliente AFTER INSERT ON clientes BEGIN INSERT INTO auditoria(momento,accion) VALUES(datetime('now'),'alta cliente'); END;");ejecutar(db,"BEGIN; INSERT OR IGNORE INTO clientes(nombre,email,estado) VALUES('Nexo Formacion S.L.','contacto@nexoformacion.example','activo'); INSERT OR IGNORE INTO clientes(nombre,email,estado) VALUES('Talleres Levante','it@tallereslevante.example','prospecto'); INSERT OR IGNORE INTO proyectos(cliente_id,nombre,estado) VALUES(1,'Portal de formacion','en curso'); COMMIT;");std::cout<<"Clientes activos (consulta C++):\n";char* error=nullptr;sqlite3_exec(db,"SELECT nombre,email,estado FROM clientes WHERE estado='activo' ORDER BY nombre;",imprimir,nullptr,&error);if(error){std::cerr<<error<<"\n";sqlite3_free(error);}sqlite3_close(db);return 0;}catch(const std::exception& e){if(db)sqlite3_close(db);std::cerr<<"Error: "<<e.what()<<"\n";return 1;}}
```
#### bin
## 03-criterios-evaluacion
**RESPUESTAS-CRITERIOS.md**
```markdown
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
```
