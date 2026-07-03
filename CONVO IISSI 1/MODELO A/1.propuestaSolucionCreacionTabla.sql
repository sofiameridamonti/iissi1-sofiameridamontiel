DROP TABLE IF EXISTS Garantias;
CREATE TABLE Garantias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    productoId INT NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    esExtendida BOOLEAN NOT NULL,
    FOREIGN KEY (productoId) REFERENCES Productos(id),
    CHECK (fechaFin > fechaInicio),
    UNIQUE (productoId)
);

-- Ejemplo de inserción de datos
INSERT INTO Garantias (productoId, fechaInicio, fechaFin, esExtendida)
VALUES (1, '2024-01-01', '2026-01-01', TRUE),
       (2, '2024-03-15', '2025-03-15', FALSE),
       (3, '2024-05-10', '2027-05-10', TRUE);
