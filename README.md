# 📂 Carpeta: `scripts_mysql`

Aquí se encuentran los siguientes archivos de soporte para la base de datos:

- **Diagrama entidad-relación** → `DER.jpg`
- **Creación de la base de datos** → `script_db.sql`
- **Consultas SQL de ejemplo (5)** → `consultas.sql`
- **Creación de roles y usuarios** → `role-users.sql`

---

# 📂 Carpeta: `dashboards`

Aquí se encuentran las siguientes imagenes:

- **Tiempo promedio de resolución por agente.** → `resolucionxagente.jpg`
- **Ranking de clientes con más solicitudes.** → `solicitudesxcliente.jpg`

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

# 📦 Backups y Recuperación de Datos 

---

## 🔹 Cómo hacer los backups
1. **Respaldos completos**
   - Se guarda toda la base de datos una vez a la semana.9    
   - Ejemplo en MySQL:
     ```bash
     mysqldump -u usuario -p sistema_soporte > backup_completo.sql
     ```

2. **Respaldos diarios**
   - Se guardan solo los cambios recientes.
   - Así no ocupamos tanto espacio.

3. **Guardar en varios lugares**
   - Un respaldo en el mismo servidor.
   - Otro respaldo en la nube (Google Drive, Dropbox, AWS S3, etc.).
   - Esto ayuda si el computador principal se daña.

---

## 🔹 Recuperación (cuando algo falla)
1. Buscar el archivo de backup más reciente (ejemplo: `backup_completo.sql`).
2. Restaurar con MySQL:
   ```bash
   mysql -u usuario -p sistema_soporte < backup_completo.sql
