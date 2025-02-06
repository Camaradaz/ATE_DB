/*
  # Children Schema for ATE

  1. New Tables
    - `children`
      - `child_id` (serial, primary key)
      - `affiliate_id` (integer, foreign key to affiliates)
      - `first_name` (varchar)
      - `last_name` (varchar)
      - `birth_date` (date)
      - `dni` (varchar, unique)
      - `gender` (char)
      - `has_disability` (boolean)
      - `notes` (text)

  2. New Functions
    - `calculate_age`: Calculates exact age based on birth date
    - `get_child_benefits`: Function to determine eligible benefits based on age

  3. Security
    - Enable RLS
    - Add policies for authenticated users
*/

-- Create children table
CREATE TABLE IF NOT EXISTS children (
    child_id SERIAL PRIMARY KEY,
    affiliate_id INTEGER NOT NULL REFERENCES affiliates(id_associate),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    gender CHAR(1) NOT NULL,
    has_disability BOOLEAN DEFAULT false,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT gender_check CHECK (gender IN ('M', 'F', 'O')),
    CONSTRAINT birth_date_check CHECK (birth_date <= CURRENT_DATE)
);

-- Create function to calculate exact age
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

-- Create function to determine benefits
CREATE OR REPLACE FUNCTION get_child_benefits(birth_date DATE)
RETURNS TEXT[] AS $$
DECLARE
    age_years INTEGER;
    benefits TEXT[] := '{}';
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
$$ LANGUAGE plpgsql IMMUTABLE;

-- Create view for children with calculated age and benefits
CREATE OR REPLACE VIEW children_details AS
SELECT 
    c.*,
    a.affiliate_name as parent_name,
    calculate_age(c.birth_date) as current_age,
    get_child_benefits(c.birth_date) as eligible_benefits
FROM children c
JOIN affiliates a ON c.affiliate_id = a.id_associate;

-- Enable Row Level Security
ALTER TABLE children ENABLE ROW LEVEL SECURITY;

-- Create policies for children
CREATE POLICY "Allow authenticated users to read children"
    ON children
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow authenticated users to insert children"
    ON children
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update children"
    ON children
    FOR UPDATE
    TO authenticated
    USING (true);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_children_affiliate_id ON children(affiliate_id);
CREATE INDEX IF NOT EXISTS idx_children_birth_date ON children(birth_date);
CREATE INDEX IF NOT EXISTS idx_children_dni ON children(dni);