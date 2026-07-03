USE modelo_octubre;
-- Insertar datos en la tabla Usuarios
INSERT INTO Usuarios (email, contraseña, nombre) VALUES
('cliente1@example.com', 'password123', 'Cliente Uno'),
('empleado1@example.com', 'password123', 'Empleado Uno'),
('cliente2@example.com', 'password123', 'Cliente Dos'),
('empleado2@example.com', 'password123', 'Empleado Dos'),
('cliente3@example.com', 'password123', 'Cliente Tres'),
('empleado3@example.com', 'password123', 'Empleado Tres');


-- Insertar datos en la tabla Empleados
-- El usuarioId corresponde al segundo usuario, que es un empleado
INSERT INTO Empleados (usuarioId, salario) VALUES
(2, 35000.00);
INSERT INTO Empleados (usuarioId, salario) VALUES
(4, 40000.00);
INSERT INTO Empleados (usuarioId, salario) VALUES
(6, 30000.00);


-- Insertar datos en la tabla Clientes
-- Corresponde a los usuarios cliente
INSERT INTO Clientes (usuarioId, direccionEnvio, codigoPostal, fechaNacimiento) VALUES
(1, '123 Calle Principal', '28001', '2005-03-25'),
(3, '456 Avenida Secundaria', '28002', '2008-07-15'), -- Mayor de 14 años
(5, 'Calle Carlos Marx 12', '41006', '1995-07-15'); -- Mayor de 14 años

-- Insertar datos en la tabla TiposProducto
-- Insertar datos en la tabla TiposProducto
INSERT INTO TiposProducto (nombre) VALUES
('Físicos'),
('Digitales');

-- Insertar datos en la tabla Productos
INSERT INTO Productos (nombre, descripción, precio, tipoProductoId, puedeVenderseAMenores) VALUES
('Smartphone', 'Teléfono inteligente de última generación', 699.99, 1, TRUE), -- Físico
('Laptop', 'Portátil con características avanzadas', 1200.00, 1, TRUE), -- Físico
('Libro Electrónico', 'Libro descargable en formato PDF', 9.99, 2, TRUE), -- Digital
('Videojuego', 'Videojuego descargable para PC', 59.99, 2, FALSE), -- Digital no vendible a menores
('Camiseta', 'Camiseta de algodón', 15.99, 1, TRUE), -- Físico
('Curso Online', 'Acceso a curso en línea sobre programación', 150.00, 2, TRUE), -- Digital
('Película', 'Película en formato digital HD', 19.99, 2, FALSE), -- Digital no vendible a menores
('Audífonos', 'Audífonos inalámbricos', 29.99, 1, TRUE), -- Físico
('Tableta Gráfica', 'Tableta para diseño gráfico', 85.99, 1, TRUE), -- Físico
('Documental', 'Documental descargable', 12.99, 2, TRUE); -- Digital

-- Insertar datos en la tabla Pedidos
INSERT INTO Pedidos (fechaRealizacion, fechaEnvio, direccionEntrega, comentarios, clienteId, empleadoId) VALUES
('2024-10-01', '2025-10-23', '123 Calle Principal', 'Entregar en la puerta. AYUDA: Este pedido estará asociado al envío 1 en preparación', 1,  1),
('2024-10-02', '2025-10-23', '456 Avenida Secundaria', 'Entregar en recepción. AYUDA: Este pedido estará asociado al envío 1 en preparación', 2, 1),
('2010-06-04', '2010-06-05', '123 Calle VeteTuASaber', 'Cliente con movilidad reducida. AYUDA: Este pedido estará asociado al envío 2 entregado', 1,  2),

-- Insertar pedido con más de 5 productos sin envío
('2025-10-10', NULL, '123 Calle Sin Envío', 'Cliente con movilidad reducida. AYUDA: Este pedido no está asociado a ningún envío', 3,  3),
-- Insertar pedido con menos de 5 productos con envío en preparación
('2025-10-12', NULL, '123 Calle En preparación', 'Cliente con movilidad reducida. AYUDA: Este pedido estará asociado al envío 3 en preparación', 3,  2);


-- Insertar datos en la tabla LineasPedido - Conjunto de inserciones correctas
-- Productos permitidos para todos los clientes
INSERT INTO LineasPedido (pedidoId, productoId, unidades, precio) VALUES
(1, 1, 1, 699.99),   -- Smartphone (permitido)
(1, 5, 2, 15.99),    -- Camiseta (permitido)
(1, 3, 1, 9.99),     -- Libro Electrónico (permitido)
(3, 2, 1, 1100.00),   -- Laptop (permitido)
(3, 8, 2, 29.99),    -- Audífono (permitido)
(3, 9, 1, 12.99),     -- Tableta (permitido)
(4, 2, 1, 1100.00),   -- Laptop (permitido)
(4, 8, 4, 29.99),    -- Audífono (permitido)
(4, 9, 2, 12.99),     -- Tableta (permitido)
(5, 9, 1, 13.99);     -- Tableta (permitido)


