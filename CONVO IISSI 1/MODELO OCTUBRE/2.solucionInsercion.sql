-- Insertar los dos envíos pedidos en el enunciado
INSERT INTO envios (fechaCreacion, fechaEntrega, estado) VALUES
	('2025-10-23', NULL, 'En preparación'),
	('2010-06-03', '2010-06-05', 'Entregado'),
	('2025-10-22', NULL, 'En preparación');

-- Insertar los mismos pedidos que en el script de poblado de la base de datos, con los datos de envío pertinentes y cumpliendo con la 3FN.
INSERT INTO Pedidos (fechaRealizacion, fechaEnvio, direccionEntrega, comentarios, clienteId, empleadoId, envioId) VALUES
('2024-10-01', '2025-10-23', '123 Calle Principal', 'Entregar en la puerta. AYUDA: Este pedido estará asociado al envío 1 en preparación', 1,  1, 1),
('2024-10-02', '2025-10-23', '456 Avenida Secundaria', 'Entregar en recepción. AYUDA: Este pedido estará asociado al envío 1 en preparación', 2, 1, 1),
('2010-06-04', '2010-06-05', '123 Calle VeteTuASaber', 'Cliente con movilidad reducida. AYUDA: Este pedido estará asociado al envío 2 entregado', 1,  2, 2),
-- Insertar pedido con menos de 5 productos con envío en preparación
('2025-10-12', NULL, '123 Calle En preparación', 'Cliente con movilidad reducida. AYUDA: Este pedido estará asociado al envío 3 en preparación', 3,  2, 3);


-- Inserciones de líneas pedidos copiadas del script de poblado de la base de datos
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
