# 📂 Carpeta: `scripts_mysql`

Aquí se encuentran los siguientes archivos de soporte para la base de datos:

- **Diagrama entidad-relación** → `DER.jpg`
- **Creación de la base de datos** → `script_db.sql`
- **Consultas SQL de ejemplo (5)** → `consultas.sql`
- **Creación de roles y usuarios** → `role-users.sql`

---

# ETL de Sistema de Soporte

Este proyecto implementa un flujo **ETL (Extract, Transform, Load)** en **Node.js** para poblar la base de datos **MySQL** del sistema de soporte a partir de archivos CSV.

---

## 📌 Flujo ETL

### 1. **Extracción**
- Se leen los archivos CSV desde la carpeta `data_csv/` usando `fs.createReadStream` y `csv-parser`.  
- Archivos procesados:
  - `clients.csv`
  - `users.csv`
  - `requests.csv`
  - `change_history.csv`
- Cada archivo se convierte en un arreglo de objetos JavaScript (`resultados`).

---

### 2. **Transformación**
Se aplican reglas de negocio y normalización para adaptar los datos al modelo relacional en MySQL:

#### a. **Tabla `requests`**
- Se reemplazan claves externas:
  - `client_id` → se busca en la tabla `clients` mediante `document_id`.
  - `agent_id` → se busca en la tabla `users` mediante `document_id`.
- Manejo de fechas:
  - Si `closed_at` viene vacío → se asigna `NULL`.

#### b. **Tabla `change_history`**
- `user_id` se obtiene desde la tabla `users` con `document_id`.

#### c. **Tabla `users`**
- El campo `active` se transforma:
  - `"True"` → `1`
  - `"False"` → `0`

#### d. **Tabla `clients`**
- Los registros se insertan sin cambios adicionales.

---

### 3. **Carga**
- Se construyen sentencias `INSERT INTO` con placeholders (`?`) para prevenir inyección SQL.
- Se insertan los registros transformados en las tablas:
  - `clients`
  - `users`
  - `requests`
  - `change_history`

---

### **Gestión de Conexión**
- Se establece la conexión a MySQL con `mysql2/promise`.
- **Es necesario editar en el código los datos de conexión:**
  ```js
  const connection = await mysql.createConnection({
      host: 'localhost',
      user: 'nombre de usuario',
      password: 'contraseña',
      database: 'sistema_soporte'
  });

---