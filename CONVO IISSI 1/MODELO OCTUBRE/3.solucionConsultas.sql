-- 3.1
SELECT DISTINCT u.nombre
FROM usuarios u 
JOIN clientes c ON u.id=c.usuarioId
JOIN pedidos p ON p.clienteId=c.id
RIGHT JOIN envios e ON e.id=p.envioId
WHERE e.id IS NULL OR e.estado NOT LIKE 'Entregado';


-- 3.2

SELECT
	envios.id as envio,
	envios.fechaEntrega,
	COUNT(DISTINCT pedidos.envioId) AS numeroClientes
	FROM envios
	JOIN pedidos ON envios.id=pedidos.envioId
	WHERE envios.fechaEntrega IS NULL 
	HAVING numeroClientes > 1
	ORDER BY envios.fechaCreacion
	
