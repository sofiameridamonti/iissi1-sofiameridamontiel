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