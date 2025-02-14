CREATE OR REPLACE FUNCTION validate_login(
    p_username VARCHAR,
    p_password VARCHAR
) RETURNS TABLE (
    user_id INTEGER,
    role user_role,
    is_valid BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.role,
        (u.password_hash = crypt(p_password, u.password_hash)) AS is_valid
    FROM users u
    WHERE u.username = p_username AND u.is_active = true;
END;
$$ LANGUAGE plpgsql; 

