DELIMITER //

CREATE TRIGGER t_asegurar_mismo_tipo_producto_en_pedidos
BEFORE INSERT ON LineasPedido
FOR EACH ROW
BEGIN
    DECLARE v_idTipoProductoNuevo INT;
    DECLARE v_existeOtroTipoProductoEnPedido BOOLEAN;

    -- Obtener el tipo del producto que se intenta insertar
    SELECT Productos.tipoProductoId
    INTO v_idTipoProductoNuevo
    FROM Productos p
    WHERE p.id = NEW.productoId;

    -- Verificar si el pedido ya tiene líneas y qué tipo de producto contiene
    SELECT EXISTS (
        SELECT *
        FROM LineasPedido lp
        JOIN Productos p ON lp.productoId = p.id
        WHERE lp.pedidoId = NEW.pedidoId
          AND p.tipoProductoId <> v_idTipoProductoNuevo
    ) INTO v_existeOtroTipoProductoEnPedido;

    -- Si el pedido ya tiene líneas, comparar los tipos y lanzar excepción si son diferentes
    IF v_existeOtroTipoProductoEnPedido THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido no puede incluir productos de tipos diferentes (físicos y digitales).';
    END IF;
END//

DELIMITER ;
