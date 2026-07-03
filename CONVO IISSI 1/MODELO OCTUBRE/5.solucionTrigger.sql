# Cree un trigger llamado trg_asegurar_envio_pedidos_fisicos 
# que impida que un pedido sea enviado si no incluye productos físicos.
-- 5 Trigger: No se puede asignar un pedido a un envío si no contiene productos físicos.

DELIMITER //
CREATE OR REPLACE TRIGGER trg_asegurar_envio_pedidos_fisicos
BEFORE UPDATE ON Pedidos FOR EACH ROW 
BEGIN
	
	DECLARE fisicos INT;
	
	SELECT COUNT(*) INTO fisicos
	FROM pedidos p 
		JOIN LineasPedido lp ON lp.pedidoId = p.id
		JOIN productos ON productos.id = lp.productoId
		JOIN tiposproducto tp ON productos.tipoProductoId=tp.id 
	WHERE lp.pedidoId = NEW.id AND tp.nombre LIKE 'Físicos'
	GROUP BY p.id;
		 
   IF (fisicos <=0) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido no puede incluirse en ningún envío por no contener productos físicos.';
   END IF;
END //
DELIMITER ;