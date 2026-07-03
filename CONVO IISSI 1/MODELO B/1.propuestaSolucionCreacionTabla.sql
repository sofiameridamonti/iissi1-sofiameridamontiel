CREATE TABLE Pagos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedidoId INT NOT NULL,
    fechaPago DATETIME NOT NULL,
    cantidadPagada DECIMAL(10, 2) NOT NULL CHECK (cantidadPagada >= 0),
    revisado BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (pedidoId) REFERENCES Pedidos(id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);