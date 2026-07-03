USE modeloa_julio;

DROP TABLE IF EXISTS Garantias;
CREATE TABLE Garantias(
	id INt PRIMARY KEY AUTO_INCREMENT,
	fechaInicio DATE NOT null,
	fechaFin DATE NOT NULL,
	productoId int NOT NULL,
	esExtendida BOOLEAN NOT NULL,
	FOREIGN KEY (productoId) REFERENCES productos(id),
	CHECK (fechaFin>fechaInicio),
	UNIQUE(productoId)
);

-- Ejemplo de inserción de datos
INSERT INTO Garantias (productoId, fechaInicio, fechaFin, esExtendida)
VALUES (1, '2024-01-01', '2026-01-01', TRUE),
       (2, '2024-03-15', '2025-03-15', FALSE),
       (3, '2024-05-10', '2027-05-10', TRUE);
       
SELECT productos.nombre AS nombre, tiposproducto.nombre AS tipo, lineaspedido.precio AS precio 
FROM lineaspedido
JOIN productos ON lineaspedido.productoId= productos.id
JOIN tiposproducto ON productos.tipoProductoId= tiposproducto.id
WHERE tiposproducto.nombre ='Digitales';

SELECT usuarios.nombre AS empleado, 
	COUNT(DISTINCT pedidos.id) AS total_pedidos,
	SUM(lineaspedido.precio*lineaspedido.unidades) AS dinero
	FROM empleados
		LEFT JOIN usuarios ON empleados.usuarioId=usuarios.id 
		LEFT JOIN pedidos ON pedidos.empleadoId= empleados.id AND YEAR(pedidos.fechaRealizacion) = YEAR(CURDATE())
		LEFT JOIN lineaspedido ON lineaspedido.pedidoId=pedidos.id
	GROUP BY usuarios.id, usuarios.nombre
	HAVING SUM(lineaspedido.precio*lineaspedido.unidades) > 500 OR total_pedidos=0
	ORDER BY dinero DESC;


DELIMITER //
DROP PROCEDURE if EXISTS actualizar_precio;
CREATE PROCEDURE actualizar_precio(in p_productoId INT, IN p_nuevoPrecio DECIMAL(10,2))
BEGIN 
DECLARE v_precioActual DECIMAL(10,2)

START TRANSACTION;
SELECT precio INTO v_precioActual
FROM productos
WHERE id=p_productoId;

if v_precioActual IS NULL then 
	ROLLBACK;
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no encontrado';
END if;

if p_nuevoPrecio < v_precioActual *0.5 THEN
	ROLLBACK;
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nuevo precio no puede ser un 50% menor que el actual';
END if;

UPDATE lineaspedido
SET precio=p_nuevoPrecio
WHERE productoId =p_productoId
	AND pedidoId IN(
		SELECT id
		FROM pedidos
		WHERE fechaEnvio IS null
	);
	
	COMMIT;
END //
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS t_asegurar_mismo_tipo_producto_en_pedidos;
CREATE TRIGGER t_asegurar_mismo_tipo_producto_en_pedidos 
	BEFORE INSERT ON lineaspedido
	FOR EACH ROW
		DECLARE v_idtipoProductoNuevo INT;
		DECLARE v_existeOtroTipoProductoEnPedido BOOLEAN;
		
		SELECT productos.tipoProductoId 
		INTO v_idTipoProductoNuevo
		FROM productos 
		WHERE productos.id= NEW.productoId;
		
		SELECT EXISTS(
			SELECT *
			FROM lineaspedido
			JOIN productos ON lineaspedido.productoId= productos.id
			WHERE lineaspedido.pedidoId= NEW.pedidoId
				AND productos.tipoProductoId <> v_idTipoProductoId
			) INTO v_existeOtroTipoProductoEnPedido;
		
		if v_existeOtroTipoProductoEnPedido then 
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'EL pedido no puede incluir distintos tipos de productos';
		END if;
	END//
delimiter ;
























