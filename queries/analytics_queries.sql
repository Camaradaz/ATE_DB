-- Consultar niños por grupo de edad
SELECT 
    c.*,
    calculate_age(birth_date) as edad,
    CASE 
        WHEN calculate_age(birth_date) < 5 THEN 'Inicial'
        WHEN calculate_age(birth_date) BETWEEN 5 AND 12 THEN 'Primaria'
        ELSE 'Adolescentes'
    END as grupo
FROM children c
WHERE birth_date IS NOT NULL
GROUP BY c.id, c.birth_date
ORDER BY grupo, birth_date;

-- Consultar estado de asistencia mensual por niño
SELECT 
    c.first_name,
    c.last_name,
    f.family_name,
    COUNT(a.attendance_date) as dias_asistidos,
    DATE_TRUNC('month', a.attendance_date) as mes
FROM children c
JOIN families f ON c.family_id = f.id
LEFT JOIN attendance a ON c.id = a.child_id
WHERE a.attendance_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '3 months')
GROUP BY c.first_name, c.last_name, f.family_name, DATE_TRUNC('month', a.attendance_date)
ORDER BY mes DESC, family_name;

-- Consultar información completa de familia y niños
SELECT 
    f.family_name,
    f.address,
    f.phone,
    COUNT(c.id) as cantidad_ninos,
    string_agg(c.first_name || ' ' || c.last_name, ', ') as ninos
FROM families f
LEFT JOIN children c ON f.id = c.family_id
GROUP BY f.id, f.family_name, f.address, f.phone
ORDER BY f.family_name; 