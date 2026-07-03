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