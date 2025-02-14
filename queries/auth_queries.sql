-- Validar login de usuario
SELECT * FROM validate_login('Administrador', 'avhk2267');

-- Consultar permisos de usuario específico
SELECT 
    u.username,
    p.name as permiso,
    p.description as descripcion
FROM users u
JOIN user_permissions up ON u.id = up.user_id
JOIN permissions p ON up.permission_id = p.id
WHERE u.username = 'Administrador';

-- Verificar usuarios administradores y sus permisos
SELECT 
    u.username,
    u.role,
    string_agg(p.name, ', ') as permisos
FROM users u
JOIN user_permissions up ON u.id = up.user_id
JOIN permissions p ON up.permission_id = p.id
WHERE u.username IN ('Administrador', 'Secretaría')
GROUP BY u.username, u.role;

-- Verificar permisos de usuarios del staff
SELECT 
    u.username,
    u.role,
    string_agg(p.name, ', ' ORDER BY p.name) as permisos
FROM users u
JOIN user_permissions up ON u.id = up.user_id
JOIN permissions p ON up.permission_id = p.id
WHERE u.username IN ('Vero', 'Flavia', 'Dani')
GROUP BY u.username, u.role; 