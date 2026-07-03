
DROP TABLE if EXISTS valoraciones;

CREATE TABLE Valoraciones(
	id INT PRIMARY KEY AUTO_INCREMENT,
	productoId INT NOT NULL,
	clienteId INT NOT NULL,
	valoracion INT NOT NULL CHECK (valoracion BETWEEN 1 AND 5),
	fechaValoracion DATE NOT NULL,
	FOREIGN KEY (productoId) REFERENCES productos(id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (clienteId) REFERENCES clientes(id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	UNIQUE(productoId, clienteId)
);
