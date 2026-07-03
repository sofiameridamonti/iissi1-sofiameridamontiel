CREATE OR REPLACE TABLE Promociones(
	id INT PRIMARY KEY AUTO_INCREMENT,
	descuento DECIMAL(4,2) NOT NULL CHECK (descuento >0 AND descuento<=1),
	fechaInicio DATE NOT NULL,
	fechaFin DATE NOT NULL CHECK (fechaFin>fechaInicio),
	productoId INT NOT NULL,
	FOREIGN KEY (productoId) REFERENCES productos(id)
		ON DELETE CASCADE ON UPDATE CASCADE
);