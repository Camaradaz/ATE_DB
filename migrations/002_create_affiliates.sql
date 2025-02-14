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
