-- Agregar permisos específicos para las páginas
INSERT INTO permissions (name, description) VALUES
    ('view_affiliate', 'Permiso para ver la página de afiliados'),
    ('view_children', 'Permiso para ver la página de niños'),
    ('view_delegate', 'Permiso para ver la página de delegados'),
    ('edit_affiliate', 'Permiso para editar afiliados'),
    ('edit_children', 'Permiso para editar niños'),
    ('edit_delegate', 'Permiso para editar delegados'),
    ('create_affiliate', 'Permiso para crear afiliados'),
    ('create_children', 'Permiso para crear niños'),
    ('create_delegate', 'Permiso para crear delegados');

-- Crear usuarios del staff
INSERT INTO users (username, password_hash, role) VALUES
    ('Vero', crypt('Ate2025', gen_salt('bf')), 'usuario'),
    ('Flavia', crypt('Ate2025', gen_salt('bf')), 'usuario'),
    ('Dani', crypt('Ate2025', gen_salt('bf')), 'usuario');

-- Asignar permisos a los usuarios
WITH staff_users AS (
    SELECT id FROM users WHERE username IN ('Vero', 'Flavia', 'Dani')
)
INSERT INTO user_permissions (user_id, permission_id)
SELECT 
    u.id,
    p.id
FROM staff_users u
CROSS JOIN permissions p
WHERE p.name IN (
    'view_affiliate', 'view_children', 'view_delegate',
    'edit_affiliate', 'edit_children', 'edit_delegate',
    'create_affiliate', 'create_children', 'create_delegate'
); 