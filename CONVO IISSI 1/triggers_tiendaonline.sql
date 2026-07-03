DELIMITER //
CREATE TRIGGER cliente_edad_minima BEFORE INSERT ON clientes 
FOR EACH ROW
BEGIN
	IF TIMESTAMPDIFF(YEAR, NEW.fechaNacimiento, CURDATE()) <=14 THEN 
	# SI LA DIFF DE YEARS ENTRE NEW.fechaNac y CURDATE (la fecha actual)
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'El cliente debe tener más de 14 años.';
	END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER check_edad_minorista BEFORE INSERT ON lineaspedido
FOR EACH ROW
BEGIN
	DECLARE clienteEdad INT;
	DECLARE ventaPermitida BOOLEAN;
	
	SELECT TIMESTAMPDIFF(YEAR, fechaNacimiento, CURDATE()) INTO clienteEdad
	FROM clientes INNER JOIN pedidos ON clientes.id =pedidos.clienteId
	WHERE pedidos.id= NEW.pedidoId;
	
	SELECT puedeVenderseAMenores INTO ventaPermitida
	FROM productos WHERE id=NEW.productoId;
	
	IF ventaPermitida = FALSE AND clienteEdad<18 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'EL cliente debe ser mayor de edad.';
	END IF;
END//
DELIMITER ;
	
	
	
	