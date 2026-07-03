# Cree un trigger llamado trg_actualizar_precio_pedido_promocion que 
# aplique las promociones activas cuando se realice un pedido.

DELIMITER //
CREATE OR REPLACE TRIGGER trg_actualizar_precio_pedido_promocion
BEFORE INSERT ON LineasPedido FOR EACH ROW 
BEGIN
	DECLARE descuentoActivo DECIMAL(4,2);
	 
    SELECT descuento INTO descuentoActivo
    FROM Promociones
    WHERE productoId = new.productoId
      AND CURRENT_DATE BETWEEN fechaInicio AND fechaFin;

    IF (descuentoActivo IS NOT NULL) THEN
        SET new.precio = new.precio * (1 - descuentoActivo);
    END IF;
END //
DELIMITER ;