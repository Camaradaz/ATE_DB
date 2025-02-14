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

-- Create affiliates table
CREATE TABLE IF NOT EXISTS affiliates (
    id_associate SERIAL PRIMARY KEY,
    affiliate_code INTEGER UNIQUE,
    affiliate_name VARCHAR(200) NOT NULL,
    dni VARCHAR(20) NOT NULL UNIQUE,
    gender CHAR(1) NOT NULL,
    contact VARCHAR(100),
    sector_id INTEGER REFERENCES sectors(sector_id),
    has_children BOOLEAN DEFAULT false,
    has_disability BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT gender_check CHECK (gender IN ('M', 'F', 'O'))
);

-- Create affiliate history table
CREATE TABLE IF NOT EXISTS affiliate_history (
    history_id SERIAL PRIMARY KEY,
    affiliate_id INTEGER REFERENCES affiliates(id_associate),
    action_type VARCHAR(50) NOT NULL, -- 'UPDATE', 'BENEFIT_GRANTED', etc.
    action_description TEXT NOT NULL,
    old_data JSONB,
    new_data JSONB,
    performed_by UUID REFERENCES auth.users(id),
    performed_at TIMESTAMPTZ DEFAULT now()
);

-- Create indexes for affiliates table
CREATE INDEX IF NOT EXISTS idx_affiliates_sector_id ON affiliates(sector_id);
CREATE INDEX IF NOT EXISTS idx_affiliates_dni ON affiliates(dni);
CREATE INDEX IF NOT EXISTS idx_affiliates_affiliate_code ON affiliates(affiliate_code);
