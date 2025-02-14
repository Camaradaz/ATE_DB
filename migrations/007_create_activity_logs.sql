CREATE TABLE activity_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL,
    tipo_evento ENUM('Creación', 'Actualización', 'Eliminación', 'Entrega de Beneficio') NOT NULL,
    usuario_id BIGINT NOT NULL,
    usuario_nombre VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    detalles JSON,
    entidad_tipo VARCHAR(50),
    entidad_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (usuario_id) REFERENCES users(id)
); 