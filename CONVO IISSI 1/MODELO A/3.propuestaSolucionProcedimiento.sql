DELIMITER //

CREATE PROCEDURE actualizar_precio_producto_lineas(
    IN p_productoId INT,
    IN p_nuevoPrecio DECIMAL(10,2)
)
BEGIN
    DECLARE v_precioActual DECIMAL(10,2);

    -- Iniciar transacción
    START TRANSACTION;

    -- Obtener el precio actual del producto
    SELECT precio INTO v_precioActual
    FROM Productos
    WHERE id = p_productoId;

    -- Si el producto no existe, lanzar un error
    IF v_precioActual IS NULL THEN
        ROLLBACK; -- Revertir cambios antes de salir
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no encontrado';
    END IF;

    -- Verificar que el nuevo precio no sea un 50% menor
    IF p_nuevoPrecio < v_precioActual * 0.5 THEN
        ROLLBACK; -- Revertir cambios antes de salir
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nuevo precio no puede ser un 50% menor que el actual';
    END IF;

    -- Actualizar el precio del producto
    UPDATE Productos
    SET precio = p_nuevoPrecio
    WHERE id = p_productoId;

    -- Actualizar las líneas de pedido de pedidos no enviados
    UPDATE LineasPedido
    SET precio = p_nuevoPrecio
    WHERE productoId = p_productoId
      AND pedidoId IN (
          SELECT id
          FROM Pedidos
          WHERE fechaEnvio IS NULL
      );

    -- Confirmar transacción
    COMMIT;
END//

DELIMITER ;
