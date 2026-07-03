DELIMITER //

CREATE PROCEDURE insertar_producto_y_regalos(
    IN p_nombre VARCHAR(255),
    IN p_descripcion VARCHAR(255),
    IN p_precio DECIMAL(10,2),
    IN p_tipoProductoId INT,
    IN p_esParaRegalo BOOLEAN
)
BEGIN
    -- Declaramos variables para datos del cliente
    DECLARE clienteMasAntiguoId INT;
    DECLARE clienteMasAntiguoDireccion VARCHAR(255);
    DECLARE clienteMasAntiguoCodigoPostal VARCHAR(10);
    
    -- Declaramos variable para guardar el ID del producto recién creado
    DECLARE v_nuevoProductoId INT;

    -- Verificar si el producto es para regalo y su precio
    IF p_esParaRegalo AND p_precio > 50 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se permite crear un producto para regalo de más de 50€';
    END IF;

    -- Iniciar transacción
    START TRANSACTION;

    -- 1. Insertar el producto
    INSERT INTO Productos (nombre, descripcion, precio, tipoProductoId)
    VALUES (p_nombre, p_descripcion, p_precio, p_tipoProductoId);

    -- 2. IMPORTANTE: Guardamos el ID del producto antes de hacer cualquier otro INSERT
    SET v_nuevoProductoId = LAST_INSERT_ID();

    -- Si es para regalo, crear un pedido para el cliente más antiguo
    IF p_esParaRegalo THEN
        -- Obtener cliente más antiguo
        SELECT id, direccionEnvio, codigoPostal INTO clienteMasAntiguoId, clienteMasAntiguoDireccion, clienteMasAntiguoCodigoPostal
        FROM Clientes
        ORDER BY id ASC
        LIMIT 1;

        -- 3. Crear pedido
        -- Al hacer este INSERT, LAST_INSERT_ID() cambiará al ID del nuevo pedido
        INSERT INTO Pedidos (fechaRealizacion, direccionEntrega, clienteId, comentarios)
        VALUES (CURDATE(), clienteMasAntiguoDireccion, clienteMasAntiguoId, 'Pedido de regalo');

        -- 4. Agregar línea de pedido
        -- LAST_INSERT_ID() = ID del Pedido (recién creado arriba)
        -- v_nuevoProductoId = ID del Producto (guardado previamente)
        INSERT INTO LineasPedido (pedidoId, productoId, unidades, precio)
        VALUES (LAST_INSERT_ID(), v_nuevoProductoId, 1, 0);
    END IF;

    -- Confirmar transacción
    COMMIT;
END //

DELIMITER ;
