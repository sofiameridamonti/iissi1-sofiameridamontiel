
-- Insertar datos en la tabla Pedidos
INSERT INTO Pedidos (fechaRealizacion, fechaEnvio, direccionEntrega, comentarios, clienteId, empleadoId) VALUES
('2024-10-02', NULL, '456 Avenida Secundaria', 'Entregar en recepción', 2, NULL);

-- Insertar datos en la tabla LineasPedido - Conjunto de inserciones con error
-- Incluye un producto no permitido para menores (Videojuego) que causará un error para el cliente menor de 18 años
INSERT INTO LineasPedido (pedidoId, productoId, unidades, precio) VALUES
(3, 6, 1, 29.99),    -- Curso online (permitido)
(3, 4, 1, 59.99);    -- Videojuego (restringido para menores y fallará si cliente tiene menos de 18 años)
