# Cree un trigger llamado p_limitar_unidades_mensuales_de_productos_fisicos que, 
# a partir de este momento, 
# impida la venta de más de 1000 unidades al mes de cualquier producto físico.

DELIMITER //
-- incluya su solución a continuación
CREATE TRIGGER p_limitar_unidades_mensuales_de_productos_fisicos
BEFORE INSERT ON lineaspedido
FOR EACH ROW
BEGIN
	DECLARE unidades_fisicas INT DEFAULT 0;
	DECLARE es_fisico BOOLEAN;
	
	SELECT (tiposproducto.nombre= 'Físicos')
	INTO es_fisico
	FROM productos
	JOIN tiposproducto ON productos.tipoProductoId = tiposproducto.id
	WHERE productos.id= NEW.productoId;
	
	if es_fisico= TRUE then
		SELECT IFNULL(SUM(lineaspedido.unidades), 0) INTO unidades_fisicas
		FROM lineaspedido
		JOIN pedidos ON lineaspedido.pedidoId=pedidos.id
		WHERE lineaspedido.productoId= NEW.productoId
			AND MONTH(pedidos.fechaRealizacion)=MONTH(CURDATE())
			AND YEAR(pedidos.fechaRealizacion)=YEAR(CURDATE());
		
		if (unidades_fisicas +NEW.unidades)>1000 then
			SIGNAL SQLSTATE '45000'
        	SET MESSAGE_TEXT = 'Operación cancelada: No se pueden vender más de 1000 unidades al mes de un producto físico.';
   	END IF;
        
    END IF;
END //

-- fin de su solución
DELIMITER ;