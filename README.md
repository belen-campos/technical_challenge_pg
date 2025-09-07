# Technical Challenge - Data Engineering con dbt + Postgres

## 📌 Elección de Postgres
Se eligió **Postgres** en lugar de **SQLite** por las siguientes razones:
- SQLite es más simple, pero presenta limitaciones en entornos como **MacOS M1**, donde no es posible instalar librerías adicionales como `sqlean` (para funciones extendidas de SQL).
- Postgres permite trabajar con **schemas**, lo que brinda mayor organización de los datos.  
- Aun así, se mantienen prefijos en los nombres de tablas para asegurar unicidad y poder referenciarlas unívocamente desde `source`.

---

## 🐍 Entorno Virtual de Python
Se recomienda trabajar dentro de un entorno virtual para aislar dependencias.  

Crear y activar un entorno virtual:

```bash
python3 -m venv venv
source venv/bin/activate   # Mac/Linux
venv\Scripts\activate      # Windows
```

---

## 📂 Carga de datos
Los archivos en formato **`.parquet`** se cargan a través de un **notebook**, que inserta la información en el esquema `raw` de Postgres.

---

## 🐳 Uso de Docker
El proyecto utiliza **Docker** y **docker-compose** para levantar la base de datos de forma reproducible.  
El volumen definido en el `docker-compose.yml` asegura que los datos de Postgres persistan aunque se detenga o elimine el contenedor.

---

## ⚠️ Nota sobre terminales para ejecución de comandos bash:

***Terminal 1*** → Levantar Docker

***Terminal 2*** (opcional) → Validar datos en Postgres

***Terminal 3*** → Comandos dbt

---

## ⚙️ Configuración y ejecución

### 1. Archivo `.env`
Definir variables de entorno necesarias, como:
```env
DB_USER
DB_PASSWORD
DB_HOST
DB_PORT
DB_NAME
```

### 2. Instalar dependencias

En el **entorno virtual de Python**, instalar requerimientos:

```bash
pip install -r requirements.txt
```

### 3. Levantar la base de datos
```bash
##  Terminal 1
docker-compose up -d
```

### 4. Carga archivos .parquet

Correr el notebook para cargar los archivos .parquet: `notebooks/prework_parquet.ipynb`, utilizar el kernel del **entorno virtual**

### 5. Acceso a Postgres

Si se desea se puede ingresar al contenedor de Postgres para ir validando la creación de las tablas:
```bash
## Terminal 2
docker exec -it pg-dbt psql -U admin -d technical_challenge
```

### 6. Validar tablas cargadas

Comprobar que las tablas del esquema raw se generaron correctamente:
```bash 
## Terminal 2
\dt public_raw.*
```

### 7. Ejecutar dbt

Ejecutar los comandos de dbt solicitados:
```bash
## Terminal 3
dbt seed
dbt snapshot
dbt run
dbt test
dbt docs generate
dbt docs serve
```

También se puede ir validando la creación de modelos con:
```bash 
## Terminal 2
\dt public_schema.*
```

---

## 📄 Archivo profiles.yml

dbt utiliza profiles.yml (ubicado por defecto en ~/.dbt/profiles.yml) para conectarse a la base de datos.
En este proyecto, el perfil debe estar configurado para usar las variables definidas en .env.

Ejemplo de configuración mínima:

```yaml
technical_challenge_pg:
  target: dev
  outputs:
    dev:
      type: postgres
      host: DB_HOSRT
      user: DB_USER
      password: DB_PASSWORD
      port: DB_PORT
      dbname: technical_challenge
      schema: public
```
---