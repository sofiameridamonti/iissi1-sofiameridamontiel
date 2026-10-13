# Cree un trigger llamado p_limitar_unidades_mensuales_de_productos_fisicos que, 
# a partir de este momento, 
# impida la venta de más de 1000 unidades al mes de cualquier producto físico.

DELIMITER //
-- incluya su solución a continuación
CREATE TRIGGER p_limitar_unidades_mensuales_de_productos_fisicos
BEFORE INSERT ON lineaspedido
FOR EACH ROW
BEGIN
	DECLARE unidades_fisicas INT;
	DECLARE es_fisico VARCHAR(255);
	
	SELECT (tiposproducto.nombre= 'Físicos')
	INTO es_fisico
	FROM productos
	JOIN tiposproducto ON productos.tipoProductoId = tiposproducto.id
	WHERE productos.id= NEW.productoId;
	
	if es_fisico= 'Físicos' then
		SELECT COALESCE(SUM(lineaspedido.unidades), 0) + NEW.unidades
		INTO unidades_fisicas
		FROM lineaspedido
		JOIN pedidos ON lineaspedido.pedidoId=pedidos.id
		WHERE lineaspedido.productoId= NEW.productoId
			AND MONTH(pedidos.fechaRealizacion)=MONTH(CURDATE())
			AND YEAR(pedidos.fechaRealizacion)=YEAR(CURDATE());
		
		if unidades_fisicas>1000 then
			SIGNAL SQLSTATE '45000'
        	SET MESSAGE_TEXT = 'Operación cancelada: No se pueden vender más de 1000 unidades al mes de un producto físico.';
   	END IF;
        
    END IF;
END //

-- fin de su solución
DELIMITER ;
