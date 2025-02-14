-- Create delegates table
CREATE TABLE delegates (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    sector_id INTEGER REFERENCES sectors(id),
    is_active BOOLEAN DEFAULT true,
    status VARCHAR(50) DEFAULT 'Activo',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create table for delegate products/kits
CREATE TABLE delegate_products (
    id SERIAL PRIMARY KEY,
    delegate_id INTEGER REFERENCES delegates(id),
    product_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL,
    delivery_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- Add trigger to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_delegates_updated_at
    BEFORE UPDATE ON delegates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Create indexes for delegates table
CREATE INDEX IF NOT EXISTS idx_delegates_sector ON delegates(sector_id);
CREATE INDEX IF NOT EXISTS idx_delegates_dni ON delegates(dni);
CREATE INDEX IF NOT EXISTS idx_delegate_products_delegate ON delegate_products(delegate_id);