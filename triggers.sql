DELIMITER //

-- impida que, a partir de ahora, 
-- un mismo pedido incluya productos físicos y digitales.

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
-- ----------------------------------------------------------------
  DELIMITER //

CREATE TRIGGER t_limitar_importe_pedidos_de_menores
BEFORE INSERT ON LineasPedido
FOR EACH ROW
BEGIN
    DECLARE clienteEdad INT;
    DECLARE sumaTotal DECIMAL(10, 2);

    -- Obtener la edad del cliente asociado al pedido
    SELECT TIMESTAMPDIFF(YEAR, c.fechaNacimiento, CURDATE()) 
    INTO clienteEdad
    FROM Pedidos p
    JOIN Clientes c ON p.clienteId = c.id
    WHERE p.id = NEW.pedidoId;

    -- Calcular el importe total del pedido actual más la nueva línea
    SELECT SUM(lp.unidades * lp.precio) + (NEW.unidades * NEW.precio) 
    INTO sumaTotal
    FROM LineasPedido lp
    WHERE lp.pedidoId = NEW.pedidoId;

    -- Verificar la restricción para menores
    IF clienteEdad < 18 AND sumaTotal > 500 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Los pedidos realizados por menores no pueden superar los 500€';
    END IF;
END //

DELIMITER ;
-- -----------------------------------------------------------------
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
-- -----------------------------------------------------------------------------
-- 4.1 Trigger: Al insertar una nueva línea de pedido, automáticamente aplica el precio con descuento si hay promoción activa.

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
-- ---------------------------------------------------------------------------------------
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
  

  ELIMITER ;
-- 
