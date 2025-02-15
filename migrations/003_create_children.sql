CREATE TABLE IF NOT EXISTS children (
    child_id SERIAL PRIMARY KEY,
    affiliate_id INTEGER NOT NULL REFERENCES affiliates(id_associate),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    dni VARCHAR(20),
    gender CHAR(1) NOT NULL,
    has_disability BOOLEAN DEFAULT false,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT gender_check CHECK (gender IN ('M', 'F', 'O')),
    CONSTRAINT birth_date_check CHECK (birth_date <= CURRENT_DATE)
);

-- Calcular la edad automatica
CREATE OR REPLACE FUNCTION calculate_age(birth_date DATE)
RETURNS TEXT AS $$
DECLARE
    years INTEGER;
    months INTEGER;
    days INTEGER;
    age_interval INTERVAL;
BEGIN
    age_interval := age(birth_date);
    years := EXTRACT(YEAR FROM age_interval);
    months := EXTRACT(MONTH FROM age_interval);
    days := EXTRACT(DAY FROM age_interval);
    
    RETURN years || ' años, ' || months || ' meses, ' || days || ' días';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION get_child_benefits(birth_date DATE)
RETURNS TEXT[] AS $function$
DECLARE
    age_years INTEGER;
    benefits TEXT[] := ARRAY[]::TEXT[];
BEGIN
    age_years := EXTRACT(YEAR FROM age(birth_date));
    
    IF age_years <= 5 THEN
        benefits := array_append(benefits, 'Kit de Primera Infancia');
    END IF;
    
    IF age_years BETWEEN 6 AND 12 THEN
        benefits := array_append(benefits, 'Kit Escolar Primario');
    END IF;
    
    IF age_years BETWEEN 13 AND 18 THEN
        benefits := array_append(benefits, 'Kit Escolar Secundario');
    END IF;
    
    IF age_years = 15 THEN
        benefits := array_append(benefits, 'Regalo Especial 15 Años');
    END IF;
    
    RETURN benefits;
END;
$function$ LANGUAGE plpgsql IMMUTABLE;


CREATE OR REPLACE VIEW children_details AS
SELECT 
    c.*,
    a.affiliate_name as parent_name,
    calculate_age(c.birth_date) as current_age,
    get_child_benefits(c.birth_date) as eligible_benefits
FROM children c
JOIN affiliates a ON c.affiliate_id = a.id_associate;

-- Create indexes for children table
CREATE INDEX IF NOT EXISTS idx_children_affiliate_id ON children(affiliate_id);
CREATE INDEX IF NOT EXISTS idx_children_dni ON children(dni);
CREATE INDEX IF NOT EXISTS idx_children_birth_date ON children(birth_date);
