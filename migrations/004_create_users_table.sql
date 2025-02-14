-- Primero creamos un enum para los roles
CREATE TYPE user_role AS ENUM ('admin', 'supervisor', 'usuario');

-- Tabla de usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,  -- Nunca almacenar contraseñas en texto plano
    role user_role NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE
);

-- Tabla de permisos
CREATE TABLE permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- Tabla de relación usuarios-permisos
CREATE TABLE user_permissions (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    permission_id INTEGER REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, permission_id)
);

-- Insertar permisos básicos
INSERT INTO permissions (name, description) VALUES
    ('read', 'Permiso de lectura'),
    ('write', 'Permiso de escritura'),
    ('delete', 'Permiso de eliminación'),
    ('admin', 'Permisos administrativos completos');

-- Función para crear hash de contraseña (usando pgcrypto)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insertar usuario administrador
INSERT INTO users (username, password_hash, role) VALUES
    ('Administrador', crypt('avhk2267', gen_salt('bf')), 'admin');

-- Dar todos los permisos al administrador
INSERT INTO user_permissions (user_id, permission_id)
SELECT 
    (SELECT id FROM users WHERE username = 'Administrador'),
    id
FROM permissions;

-- Crear usuario Secretaría con rol admin existente
INSERT INTO users (username, password_hash, role) VALUES
    ('Secretaría', crypt('ateao2025', gen_salt('bf')), 'admin');

-- Asignar todos los permisos existentes
INSERT INTO user_permissions (user_id, permission_id)
SELECT 
    (SELECT id FROM users WHERE username = 'Secretaría'),
    id
FROM permissions; 