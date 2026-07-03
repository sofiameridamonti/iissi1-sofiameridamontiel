DELIMITER //

CREATE TRIGGER t_limitar_importe_pedidos_de_menores
BEFORE INSERT ON LineasPedido
FOR EACH ROW
BEGIN
    DECLARE clienteEdad INT;
    DECLARE sumaTotal DECIMAL(10, 2);

    -- Obtener la edad del cliente asociado al pedido
    SELECT TIMESTAMPDIFF(YEAR, c.fechaNacimiento, CURDATE()) INTO clienteEdad
    FROM Pedidos p
    JOIN Clientes c ON p.clienteId = c.id
    WHERE p.id = NEW.pedidoId;

    -- Calcular el importe total del pedido actual más la nueva línea
    SELECT SUM(lp.unidades * lp.precio) + (NEW.unidades * NEW.precio) INTO sumaTotal
    FROM LineasPedido lp
    WHERE lp.pedidoId = NEW.pedidoId;

    -- Verificar la restricción para menores
    IF clienteEdad < 18 AND sumaTotal > 500 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Los pedidos realizados por menores no pueden superar los 500€';
    END IF;
END //

DELIMITER ;
