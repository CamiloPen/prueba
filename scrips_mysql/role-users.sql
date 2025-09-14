-- Creacion de roles:

CREATE ROLE admin_role;
CREATE ROLE soporte_role;
CREATE ROLE cliente_role;

-- Asignacion de permisos:

GRANT ALL PRIVILEGES ON sistema_soporte.* TO admin_role;
GRANT SELECT, UPDATE, INSERT ON sistema_soporte.requests TO soporte_role;
GRANT SELECT ON sistema_soporte.clients TO soporte_role;
GRANT SELECT ON sistema_soporte.users TO soporte_role;
GRANT SELECT ON sistema_soporte.requests TO cliente_role;

-- Usuarios + rol:

CREATE USER 'admin_pepe'@'localhost' IDENTIFIED BY 'pepe123';
GRANT admin_role TO 'admin_pepe'@'localhost';

CREATE USER 'agente_david'@'localhost' IDENTIFIED BY 'david456';
GRANT soporte_role TO 'agente_david'@'localhost';

CREATE USER 'cliente_sara'@'localhost' IDENTIFIED BY 'sara789';
GRANT cliente_role TO 'cliente_sara'@'localhost';
