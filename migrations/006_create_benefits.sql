CREATE TABLE benefits (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    age_range_min INTEGER,
    age_range_max INTEGER,
    stock INTEGER DEFAULT 0,
    is_available BOOLEAN DEFAULT true,
    status VARCHAR(50) DEFAULT 'Disponible',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE benefit_movements (
    id SERIAL PRIMARY KEY,
    benefit_id INTEGER REFERENCES benefits(id),
    quantity INTEGER NOT NULL,
    movement_type VARCHAR(20) NOT NULL, -- 'entrada' o 'salida'
    reason VARCHAR(100),
    movement_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100)
);

CREATE OR REPLACE FUNCTION update_benefit_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.movement_type = 'entrada' THEN
        UPDATE benefits 
        SET stock = stock + NEW.quantity,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.benefit_id;
    ELSIF NEW.movement_type = 'salida' THEN
        UPDATE benefits 
        SET stock = stock - NEW.quantity,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.benefit_id;
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_stock_after_movement
    AFTER INSERT ON benefit_movements
    FOR EACH ROW
    EXECUTE FUNCTION update_benefit_stock();


CREATE TRIGGER update_benefits_updated_at
    BEFORE UPDATE ON benefits
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 