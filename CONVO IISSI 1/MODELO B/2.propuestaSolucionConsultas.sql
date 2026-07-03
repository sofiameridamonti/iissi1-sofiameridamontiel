-- 2.1. Devuelva el nombre del empleado, la fecha de realización del pedido y el nombre del cliente de todos los pedidos realizados este mes.
SELECT 
    u.nombre AS nombre_empleado, 
    p.fechaRealizacion, 
    c.nombre AS nombre_cliente
FROM Pedidos p
LEFT JOIN Empleados e ON p.empleadoId = e.id
LEFT JOIN Usuarios u ON e.usuarioId = u.id
JOIN Clientes cl ON p.clienteId = cl.id
JOIN Usuarios c ON cl.usuarioId = c.id
WHERE MONTH(p.fechaRealizacion) = MONTH(CURDATE())
  AND YEAR(p.fechaRealizacion) = YEAR(CURDATE());


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