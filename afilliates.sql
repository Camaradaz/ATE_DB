/*
  # Inventory System Schema for ATE

  1. New Tables
    - `sectors`
      - `sector_id` (serial, primary key)
      - `sector_name` (varchar, unique)
      - `sector_code` (varchar, unique)
    
    - `affiliates`
      - `id_associate` (serial, primary key)
      - `affiliate_code` (integer, unique)
      - `affiliate_name` (varchar)
      - `dni` (varchar, unique)
      - `gender` (char)
      - `email` (varchar, unique)
      - `sector_id` (integer, foreign key)
      - `has_children` (boolean)
      - `has_disability` (boolean)

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users to manage data
*/

-- Create sectors table
CREATE TABLE IF NOT EXISTS sectors (
    sector_id SERIAL PRIMARY KEY,
    sector_name VARCHAR(50) NOT NULL UNIQUE,
    sector_code VARCHAR(12) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create affiliates table
CREATE TABLE IF NOT EXISTS affiliates (
    id_associate SERIAL PRIMARY KEY,
    affiliate_code INTEGER NOT NULL UNIQUE,
    affiliate_name VARCHAR(200) NOT NULL,
    dni VARCHAR(20) NOT NULL UNIQUE,
    gender CHAR(1) NOT NULL,
    email VARCHAR(100) UNIQUE,
    sector_id INTEGER REFERENCES sectors(sector_id),
    has_children BOOLEAN DEFAULT false,
    has_disability BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT gender_check CHECK (gender IN ('M', 'F', 'O'))
);

-- Enable Row Level Security
ALTER TABLE sectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliates ENABLE ROW LEVEL SECURITY;

-- Create policies for sectors
CREATE POLICY "Allow authenticated users to read sectors"
    ON sectors
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow authenticated users to insert sectors"
    ON sectors
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update sectors"
    ON sectors
    FOR UPDATE
    TO authenticated
    USING (true);

-- Create policies for affiliates
CREATE POLICY "Allow authenticated users to read affiliates"
    ON affiliates
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow authenticated users to insert affiliates"
    ON affiliates
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update affiliates"
    ON affiliates
    FOR UPDATE
    TO authenticated
    USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_affiliates_sector_id ON affiliates(sector_id);
CREATE INDEX IF NOT EXISTS idx_affiliates_dni ON affiliates(dni);
CREATE INDEX IF NOT EXISTS idx_affiliates_affiliate_code ON affiliates(affiliate_code);