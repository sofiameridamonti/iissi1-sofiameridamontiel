-- Eliminación de tablas para asegurar que el script es ejecutable varias veces sin error
DROP TABLE IF EXISTS lineaspedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS Envios;

-- Creación de la tabla Envíos
CREATE TABLE Envios (
	id INT PRIMARY KEY AUTO_INCREMENT,
	fechaCreacion DATE NOT NULL,
	fechaEntrega DATE CHECK (fechaEntrega is null or fechaCreacion<fechaEntrega),
	estado ENUM('En preparación', 'Enviado', 'Entregado')
);

-- Modificar esta tabla para implementar asociación con Envios
CREATE TABLE Pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fechaRealizacion DATE NOT NULL,
    fechaEnvio DATE,
    direccionEntrega VARCHAR(255) NOT NULL,
    comentarios TEXT,
    clienteId INT NOT NULL,
    empleadoId INT,
    envioId INT,
    FOREIGN KEY (clienteId) REFERENCES Clientes(id) 
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT,
   FOREIGN KEY (empleadoId) REFERENCES Empleados(id) 
        ON DELETE SET NULL 
        ON UPDATE SET NULL,
   FOREIGN KEY (envioId) REFERENCES Envios(id)
			ON DELETE SET null
			ON UPDATE CASCADE
);

CREATE TABLE LineasPedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedidoId INT NOT NULL,
    productoId INT NOT NULL,
    unidades INT NOT NULL CHECK (unidades > 0 AND unidades <= 100),
    precio DECIMAL(10, 2) NOT NULL CHECK (precio >= 0),
    FOREIGN KEY (pedidoId) REFERENCES Pedidos(id),
    FOREIGN KEY (productoId) REFERENCES Productos(id),
    UNIQUE (pedidoId, productoId)
);
