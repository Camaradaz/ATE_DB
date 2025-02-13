CREATE OR REPLACE FUNCTION calculate_age(birth_date date)
RETURNS integer AS $$
BEGIN
    RETURN date_part('year', age(current_date, birth_date));
END;
$$ LANGUAGE plpgsql; 