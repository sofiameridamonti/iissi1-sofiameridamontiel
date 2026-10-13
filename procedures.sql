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
-- ----------------------------------------------------------------
  DELIMITER //
# Cree un procedimiento que permita crear un nuevo producto con 
# posibilidad de que sea para regalo. 
# Si el producto está destinado a regalo  
# se creará un pedido con ese producto y costes 0€ 
# para el cliente más antiguo.

# Asegure que el precio del producto para regalo no debe superar los 50 euros 
# y lance excepción si se da el caso con el siguiente mensaje:

CREATE PROCEDURE insertar_producto_y_regalos(
    IN p_nombre VARCHAR(255),
    IN p_descripcion VARCHAR(255),
    IN p_precio DECIMAL(10,2),
    IN p_tipoProductoId INT,
    IN p_esParaRegalo BOOLEAN
)
-- incluya su solución a continuación
	BEGIN
	DECLARE cliente_antiguo_ID INT;
	DECLARE cliente_antiguo_DIRECCION VARCHAR(255);
	DECLARE cliente_antiguo_CODIGOPOSTAL VARCHAR(255);
	
	DECLARE nuevoProducto_ID INT;
	
	IF p_esParaRegalo AND p_precio>50 then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT ='No se puede regalar un productos que no sea regalo y con valor de más de 50 euros';
	END if;

	START TRANSACTION;
	
	INSERT INTO productos(nombre, descripcion, precio, tipoProductoId)
	VALUES (p_nombre, p_descripcion, p_precio, p_tipoProductoId);
	
	SET nuevoProducto_ID = LAST_INSERT_ID();
	
	if p_esParaRegalo then
		SELECT id, direccionEnvio, codigoPostal INTO cliente_antiguo_ID,cliente_antiguo_DIRECCION,cliente_antiguo_CODIGOPOSTAL
		FROM clientes 
		ORDER BY id ASC 
		LIMIT 1;
		
		INSERT INTO pedidos(fechaRealizacion, direccionEntrega, clienteId, comentarios)
		VALUES(CURDATE(), cliente_antiguo_DIRECCION, cliente_antiguo_ID, 'Pedido de regalo');
		
		INSERT INTO lineaspedido(pedidoId, productoId, unidades, precio)
		VALUES(LAST_INSERT_ID(),nuevoProducto_ID, 1, 0);
	END if;
	
	COMMIT;
	
	END //
-- fin de su solución
DELIMITER ;
-- -------------------------------------------------------
DELIMITER //

#Cree un procedimiento que permita bonificar un pedido que se ha retrasado 
#debido a la mala gestión del empleado a cargo. 
#Recibirá un identificador de pedido, asignará a otro empleado como gestor 
#y reducirá un 20% el precio unitario de cada línea de pedido asociada a ese pedido. 


#Asegure que el pedido estaba asociado a un empleado Y 
#en caso contrario lance excepción con el siguiente mensaje: EL pedido NO tiene gestor

#Garantice que o bien se realizan todas las operaciones o bien no se realice ninguna. 

CREATE PROCEDURE bonificar_pedido_retrasado(IN p_pedidoId INT)
-- incluya su solución a continuación
	BEGIN
	
		DECLARE empleado_actual_id INT;
		DECLARE nuevo_empleado_id INT;
		
		SELECT empleadoId
		INTO empleado_actual_id
		FROM pedidos
		WHERE id = p_pedidoId;
		
		if empleado_actual_id IS NULL then
			ROLLBACK; -- Revertir cambios antes de salir
	   	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EL pedido NO tiene gestor';
	   END IF;
	   
	   SELECT id 
		INTO nuevo_empleado_id
		FROM empleados
		WHERE id <> empleado_actual_id
		LIMIT 1;
	    
	   START TRANSACTION;
		 
			UPDATE pedidos
			SET empleadoId= nuevo_empleado_Id
			WHERE id= p_pedidoId;
			 
			UPDATE lineaspedido
			SET precio = precio*0.8
			WHERE pedidoId= p_pedidoId;
			 	 
		COMMIT;
	END //

-- fin de su solución
DELIMITER ;
-- -----------------------------------------------------------
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
-- ------------------------------------------
DELIMITER //
-- Cree un procedimiento que permita dar de alta un nuevo envío, con fecha de envío la de hoy y estado "En preparación"
-- y asigne todos aquellos pedidos realizados hasta el día de ayer y que NO hayan sido incluídos en ningún otro envío aún.
CREATE OR REPLACE PROCEDURE p_nuevoEnvio()
BEGIN
	DECLARE envio_id INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Error al crear el envío";
	END;

    START TRANSACTION;

    -- 1. Crear el envío, guardando su id
   INSERT INTO envios (fechaEnvio, fechaEntrega, estadoEnvio) VALUES
	(CURDATE(), NULL, 'En preparación');
	SET envio_id = LAST_INSERT_ID();
    
    UPDATE Pedidos p
    SET p.envioId = envio_id
    WHERE p.fechaRealizacion < CURDATE() AND p.envioId IS NULL;

    COMMIT;
END //
DELIMITER ;


