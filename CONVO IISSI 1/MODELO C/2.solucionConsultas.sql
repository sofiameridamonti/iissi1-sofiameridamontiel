USE modeloc_julio;
-- 2.1
SELECT 
	productos.nombre AS nombre_producto, 
	lineaspedido.precio AS precio_unitario,
	lineaspedido.unidades AS unidades_vendidas
	
	FROM lineaspedido
	JOIN productos ON lineaspedido.productoId=productos.id
	
	ORDER BY lineaspedido.unidades desc
	LIMIT 5;

-- 2.3
SELECT
	usuarios.nombre AS empleado,
	pedidos.fechaRealizacion AS fecha_pedido,
	SUM(lineaspedido.unidades*lineaspedido.precio) AS precio_total_pedido,
	sum(lineaspedido.unidades) AS unidades_totales
	
	FROM pedidos
	JOIN lineaspedido ON pedidos.id=lineaspedido.pedidoId 
	LEFT JOIN empleados ON pedidos.empleadoId=empleados.id
	LEFT JOIN usuarios ON empleados.usuarioId=usuarios.id
	
	WHERE pedidos.fechaRealizacion < DATE_SUB(CURDATE(), INTERVAL 7 DAY)
	GROUP BY usuarios.nombre, pedidos.fechaRealizacion;
	
	
	
	