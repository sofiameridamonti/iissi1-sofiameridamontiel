-- 3.1
SELECT 
	DISTINCT usuarios.nombre
	FROM pedidos
	JOIN usuarios ON clientes.usuarioId=usuarios.id
	JOIN clientes ON pedidos.clienteId=clientes.id
	WHERE usuarios.nombre 


-- 3.2
