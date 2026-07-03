# Cree un procedimiento almacenado con transacción llamado p_anularPedido 
# que reciba como parámetro un número de pedido. 
# Deberá actualizar el campo de stock de aquellos productos 
# que participaban del pedido, así como eliminar las líneas de pedido 
# y el propio pedido.

DELIMITER //
CREATE PROCEDURE p_anularPedido(IN p_pedidoId INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Error al anular el pedido";
	END;

    START TRANSACTION;

    -- 1. Actualizar el stock de los productos según las líneas del pedido
    UPDATE Productos p
    JOIN LineasPedido lp ON p.id = lp.productoId
    SET p.stock = p.stock + lp.unidades
    WHERE lp.pedidoId = p_pedidoId;

    -- 2. Eliminar las líneas del pedido
    DELETE FROM LineasPedido 
    WHERE pedidoId = p_pedidoId;

    -- 3. Eliminar el pedido
    DELETE FROM Pedidos
    WHERE id = p_pedidoId;

    COMMIT;
END //
DELIMITER ;