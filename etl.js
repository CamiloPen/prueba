const mysql = require('mysql2/promise');
const fs = require('fs');
const csv = require('csv-parser');

async function cargarDatos() {
    // --- Conexión a MySQL
    const connection = await mysql.createConnection({
        host: 'localhost',
        user: 'ejemplo',             // cambiar el usuario
        password: 'ejemplo12345',    // cambiar la contraseña
        database: 'sistema_soporte'
    });

    async function readFile(file, connection) {
        const resultados = [];
        const stream = fs.createReadStream(`data_csv/${file}.csv`).pipe(csv());

        for await (const registro of stream) {
            resultados.push(registro);
        }

        console.log(`Procesando ${resultados.length} registros de ${file}`);

        await Promise.all(resultados.map(async registro => {
            switch(file) {
                case 'requests':
                    const request = { 
                        ...registro,
                        client_id: await getId(connection, 'clients', registro.client_id),
                        agent_id: await getId(connection, 'users', registro.agent_id),
                        closed_at: registro.closed_at || null
                    };
                    await insertData(connection, file, request);
                    break;

                case 'change_history':
                    const change = {
                        ...registro,
                        user_id: await getId(connection, 'users', registro.user_id)
                    };
                    await insertData(connection, file, change);
                    break;

                case 'users':
                    const user = {
                        ...registro,
                        active: registro.active === 'True' ? 1 : 0
                    };
                    await insertData(connection, file, user);
                    break;

                default:
                    await insertData(connection, file, registro);
            }
        }));

        console.log(`Carga de ${file} completada`);
    }

    // --- Carga de archivos
    await readFile('clients', connection);
    await readFile('users', connection);
    await readFile('requests', connection);
    await readFile('change_history', connection);

    await connection.end();
}

async function getId(connection, table, document_id) {
    const field = table === 'users' ? 'user_id' : 'client_id';
    const [rows] = await connection.execute(
        `SELECT ${field} FROM ${table} WHERE document_id = ?`,
        [document_id]
    );
    return rows[0]?.[field];
}

async function insertData(connection, table, data) {
    const fields = Object.keys(data).join(", ");
    const placeholders = Object.keys(data).map(() => "?").join(", ");
    const values = Object.values(data);

    await connection.execute(
        `INSERT INTO ${table} (${fields}) VALUES (${placeholders})`,
        values
    );
}

// Ejecutar
cargarDatos().catch(err => console.error("Error en ETL:", err));