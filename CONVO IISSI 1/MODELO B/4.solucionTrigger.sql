# Cree un trigger llamado t_limitar_importe_pedidos_de_menores que impida que, 
# a partir de ahora, los pedidos realizados por menores superen los 500€.

DELIMITER //
-- incluya su solución a continuación
CREATE TRIGGER t_limitar_importe_pedidos_de_menores
BEFORE INSERT ON pedidos
FOR EACH ROW
BEGIN

	DECLARE clienteEdad INT;
	DECLARE suma_total DECIMAL(10,2);
	
	SELECT TIMESTAMPDIFF(YEAR, clientes.fechaNacimiento, CURDATE())
		INTO clienteEdad
		FROM pedidos
		JOIN clientes ON pedidos.clienteId= clientes.id
		WHERE pedidos.Id=NEW.pedidoId
	
	SELECT SUM(lineaspedido.unidades*lineaspedido.precio)+SUM(NEW.precio*NEW.unidades)
	INTO suma_total
	FROM lineaspedido
	WHERE lineaspedido.pedidoId= NEW.pedidoId
	
	if clienteEdad<18 AND suma_total >500 then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT='Los pedidos de menores no pueden ser superiores a 500 euros';
	END if; 
	
	END //
-- fin de su solución
DELIMITER ;