
CREATE TABLE delegates (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    sector_id INTEGER REFERENCES sectors(sector_id),
    is_active BOOLEAN DEFAULT true,
    status VARCHAR(50) DEFAULT 'Activo',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE delegate_products (
    id SERIAL PRIMARY KEY,
    delegate_id INTEGER REFERENCES delegates(id),
    product_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL,
    delivery_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);


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


CREATE INDEX IF NOT EXISTS idx_delegates_sector ON delegates(sector_id);
CREATE INDEX IF NOT EXISTS idx_delegates_dni ON delegates(dni);
CREATE INDEX IF NOT EXISTS idx_delegate_products_delegate ON delegate_products(delegate_id);

INSERT INTO delegates (first_name, last_name, dni, sector_id, is_active, status) VALUES
    ('Carmen', 'Recanatti', '24567891', 16, true, 'Activo'),
    ('Griselda', 'Aguiar', '25789432', 16, true, 'Activo'),
    ('Daniela', 'Perez Carrasco', '26543218', 16, true, 'Activo'),
    ('Patricia', 'Novarino', '27891234', 16, true, 'Activo'),
    ('Karina', 'Marccio', '28456789', 16, true, 'Activo'),
    ('Vanina', 'Giraldi', '29123456', 16, true, 'Activo'),
    ('Leandro', 'Pita', '30789123', 16, true, 'Activo'),
    ('Viviana', 'Gadaleta', '31234567', 16, true, 'Activo'),
    ('Marcelo', 'Nuñez', '32890123', 16, true, 'Activo');

