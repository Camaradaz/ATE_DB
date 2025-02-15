-- Crear el tipo ENUM primero
CREATE TYPE tipo_evento_enum AS ENUM (
    'Creación',
    'Actualización',
    'Eliminación',
    'Entrega de Beneficio'
);

CREATE TABLE activity_logs (
    id BIGSERIAL PRIMARY KEY,
    fecha_hora TIMESTAMP NOT NULL,
    tipo_evento tipo_evento_enum NOT NULL,
    usuario_id BIGINT NOT NULL,
    usuario_nombre VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    detalles JSON,
    entidad_tipo VARCHAR(50),
    entidad_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (usuario_id) REFERENCES users(id)
);

-- Función para actualizar el updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger que actualiza updated_at
CREATE TRIGGER update_activity_logs_updated_at
    BEFORE UPDATE ON activity_logs
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Índice para búsquedas por fecha
CREATE INDEX idx_activity_logs_fecha_hora ON activity_logs(fecha_hora);

-- Índice para búsquedas por usuario
CREATE INDEX idx_activity_logs_usuario ON activity_logs(usuario_id);

-- Índice compuesto para búsquedas por entidad
CREATE INDEX idx_activity_logs_entidad ON activity_logs(entidad_tipo, entidad_id);

-- Índice para búsquedas por tipo de evento
CREATE INDEX idx_activity_logs_tipo_evento ON activity_logs(tipo_evento); 
