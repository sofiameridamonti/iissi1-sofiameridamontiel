CREATE OR DROP DATABASE peluqueria;

CREATE TABLE Usuarios(
	id INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	contraseña VARCHAR (255) NOT NULL
);

CREATE TABLE Peluquero(
	id INT PRIMARY KEY AUTO_INCREMENT,
	usuarioId INT NOT NULL,
	FOREIGN KEY (usuarioId) REFERENCES usuarios(id)
		ON DELETE CASCADE,
		ON UPDATE CASCADE
);

CREATE TABLE Cliente(
	id INT PRIMARY KEY AUTO_INCREMENT,
	usuarioId INT NOT NULL,
	FOREIGN KEY (usuarioId) REFERENCES usuarios(id)
		ON DELETE CASCADE,
		ON UPDATE CASCADE
);

CREATE TABLE Servicio(
	id INT PRIMARY KEY AUTO_INCREMENT,
	tipoServicio ENUM('Lavado', 'Lavado+Corte', 'Tinte')
	duracionDefecto INT NOT NULL
);

CREATE TABLE CitaServicio(
	id INT PRIMARY KEY AUTO_INCREMENT,
	

CREATE TABLE Cita(
	id INT PRIMARY KEY AUTO_INCREMENT,
	fecha DATE NOT NULL,
	horaInicio TIME NOT NULL,
	fechaHoraSolicitud DATETIME NOT null,
	fechaHoraConfirmacion DATETIME,
	estadoCita ENUM('Por confirmar', 'Confirmada', 'Cumplida', 'No asistida') DEFAULT 'Por confirmar',
	peluqueroId INT NOT NULL,
	clienteId INT NOT NULL,
	servicioId INT NOT NULL,
	FOREIGN KEY (peluqueroId) REFERENCES Peluquero(id)
		ON DELETE SET NULL
		ON UPDATE SET NULL,
	FOREIGN KEY (clienteId) REFERENCES Cliente(id)
		ON DELETE SET NULL
		ON UPDATE SET NULL,
	FOREIGN KEY (servicioId) REFERENCES Servicio(id)
);
	
	
	
	
	
	