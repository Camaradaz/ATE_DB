SELECT 
    c.*,
    calculate_age(birth_date) as edad
FROM children c
WHERE birth_date IS NOT NULL
ORDER BY family_id, birth_date; 