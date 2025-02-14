-- Create sectors table
CREATE TABLE IF NOT EXISTS sectors (
    sector_id SERIAL PRIMARY KEY,
    sector_name VARCHAR(50) NOT NULL UNIQUE,
    sector_code VARCHAR(12) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT now()
);