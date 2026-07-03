-- 2.1
SELECT 
	e.nombre AS empleado, 
	pedidos.fechaRealizacion AS fecha_realizacion,
	c.nombre AS cliente
	
	FROM pedidos
	LEFT JOIN empleados ON pedidos.empleadoId=empleados.id 
	LEFT JOIN usuarios e ON empleados.usuarioId= e.id
	JOIN clientes ON pedidos.clienteId=empleados.id
	JOIN usuarios c ON clientes.usuarioId=c.id
	
	WHERE MONTH(CURDATE())= MONTH(pedidos.fechaRealizacion) 
		#AND YEAR(CURDATE())= YEAR(pedidos.fechaRealizacion) --comentado porq no hay datos con el año actual
;		
		
-- 2.2. Devuelva el nombre, las unidades totales pedidas y el importe total gastado de aquellos clientes que han realizado más de 5 pedidos en el último año.
SELECT 
    u.nombre AS nombre_cliente, 
    SUM(lp.unidades) AS unidades_totales,
    SUM(lp.unidades * lp.precio) AS importe_total
FROM Pedidos p
JOIN Clientes cl ON p.clienteId = cl.id
JOIN Usuarios u ON cl.usuarioId = u.id
JOIN LineasPedido lp ON p.id = lp.pedidoId

WHERE p.fechaRealizacion >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY u.id
HAVING COUNT(p.id) > 5;