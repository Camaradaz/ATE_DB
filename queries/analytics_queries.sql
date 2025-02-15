-- Consultar niños por grupo de edad
SELECT 
    c.*,
    calculate_age(birth_date) as edad_texto,
    EXTRACT(YEAR FROM age(current_date, birth_date)) as edad,
    CASE 
        WHEN EXTRACT(YEAR FROM age(current_date, birth_date)) < 5 THEN 'Inicial'
        WHEN EXTRACT(YEAR FROM age(current_date, birth_date)) BETWEEN 5 AND 12 THEN 'Primaria'
        WHEN EXTRACT(YEAR FROM age(current_date, birth_date)) BETWEEN 13 AND 17 THEN 'Adolescentes'
        ELSE 'Universitario'
    END as grupo
FROM children c
WHERE birth_date IS NOT NULL
GROUP BY child_id, birth_date
ORDER BY grupo, birth_date;

