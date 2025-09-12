-- Creación y uso de la Base de Datos

CREATE DATABASE sistema_soporte;
use sistema_soporte;

-- Tabla de Clientes:

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    document_id BIGINT UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Usuarios Internos:

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    document_id BIGINT UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('admin', 'agente') NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Solicitudes:

CREATE TABLE requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    state ENUM('abierta', 'en_proceso', 'cerrada') NOT NULL DEFAULT 'abierta',
    priority ENUM('baja', 'media', 'alta', 'critica') NOT NULL DEFAULT 'media',
    agent_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    closed_at TIMESTAMP NULL,
    CONSTRAINT fk_client 
        FOREIGN KEY (client_id) REFERENCES clients(client_id),
    CONSTRAINT fk_agent 
        FOREIGN KEY (agent_id) REFERENCES users(user_id)
);

-- Tabla de Historial de Cambios:

CREATE TABLE change_history (
    change_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT,
    user_id INT,
    modified_field VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_request 
        FOREIGN KEY (request_id) REFERENCES requests(request_id),
    CONSTRAINT fk_user 
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);