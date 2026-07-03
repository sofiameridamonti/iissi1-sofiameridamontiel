# Cree un procedimiento que permita dar de alta un nuevo envío, 
# con fecha de envío la de hoy, 
# y asignarle todos aquellos pedidos realizados hasta el día de ayer Y 
# que NO hayan sido incluídos en ningún otro envío aún. (1,5 puntos)

# Garantice que o bien se realizan todas las operaciones o 
# bien no se realice ninguna. (0,5 puntos)
DELIMITER //
CREATE or replace PROCEDURE p_nuevo_envio()
BEGIN
	DECLARE envio_id INT;
	
	DECLARE exit handler FOR sqlexception
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ="Error al crear el envío";
	END;
	
	START TRANSACTION;
	
	INSERT INTO envios(fechaCreacion, fechaEntrega, estado) values
	(CURDATE(), NULL, 'En preparación');
	SET envio_id = LAST_INSERT_ID();
	
	UPDATE pedidos
	SET pedidos.envioId= envio_id
	WHERE pedidos.fechaRealizacion < CURDATE() AND pedidos.envioId IS NULL;
	
	COMMIT;
	END //
DELIMITER ;

CALL p_nuevo_envio();
	


