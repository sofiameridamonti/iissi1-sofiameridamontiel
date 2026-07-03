




SELECT email, nombre FROM usuarios; 

SELECT usuarios.nombre, empleados.salario 
	FROM empleados JOIN usuarios ON empleados.usuarioId = usuarios.id;
	
SELECT nombre, precio FROM productos WHERE precio >=200;

SELECT usuarios.nombre, clientes.direccionEnvio, clientes.codigoPostal, clientes.fechaNacimiento
	FROM clientes JOIN usuarios ON clientes.usuarioId = usuarios.id;
	
SELECT AVG(salario) AS salario_promedio FROM empleados; 

SELECT tiposProducto.nombre AS tipo, COUNT(productos.id) AS total_productos
	FROM productos
	JOIN tiposProducto ON productos.tipoProductoId = tiposProducto.id
	GROUP BY tiposproducto.nombre;
	
SELECT usuarios.nombre AS cliente, pedidos.fechaRealizacion AS fecha
	FROM pedidos
	JOIN clientes ON pedidos.clienteId = clientes.id
	JOIN usuarios ON clientes.usuarioId= usuarios.id;
	
SELECT u.nombre AS cliente, COUNT(DISTINCT lp.productoId) AS numero_productos_distintos
#cojo el nombre de los clientes de la tabla usuarios
#cuento los distintos id de producto que tiene una linea de pedido

	FROM Clientes c	#de los clientes
	#uno la id del cliente con la clienteId de un pedido
	JOIN Pedidos p ON c.id = p.clienteId
	#uno la id del pedido con la pedidoId de una linea de pedido
	JOIN LineasPedido lp ON p.id = lp.pedidoId
	#uno la usuarioId del cliente con la id del usuario para poder saber el nombre del cliente
	JOIN Usuarios u ON c.usuarioId = u.id
	#agrupo segun id de cliente y nombre de usuario (cliente)
	GROUP BY c.id, u.nombre
	#ordeno de forma ascendente segun el numero distinto de productos y me quedo con el primero
	ORDER BY numero_productos_distintos ASC
	LIMIT 1;
 	
SELECT usuarios.nombre AS cliente, pedidos.fechaRealizacion
 	FROM pedidos
 	JOIN clientes ON pedidos.clienteId= clientes.id
 	JOIN usuarios ON clientes.usuarioId= usuarios.id
 	WHERE TIMESTAMPDIFF(YEAR, clientes.fechaNacimiento, CURDATE()) >=18;
 	
SELECT productos.nombre
	FROM productos
	WHERE productos.id NOT IN(  
		SELECT lineaspedido.productoId
		FROM lineaspedido
		JOIN pedidos ON lineaspedido.pedidoId= pedidos.id
		JOIN clientes ON pedidos.clienteId=clientes.id
		WHERE TIMESTAMPDIFF(YEAR, clientes.fechaNacimiento, CURDATE())<18);
		
SELECT pedidos.id AS pedidos_realizados, lineaspedido.id AS lineas_asociadas, productos.nombre AS nombre_producto, lineaspedido.unidades AS unidades
	FROM lineaspedido
	JOIN pedidos ON lineaspedido.pedidoId= pedidos.id
	JOIN productos ON lineaspedido.productoId= productos.id;
	
SELECT productos.nombre AS producto, productos.precio AS precio
FROM productos
WHERE (productos.puedeVenderseAMenores=FALSE);

SELECT clientes.id AS cliente_id, usuarios.nombre
	FROM Clientes
	JOIN Usuarios ON clientes.usuarioId = usuarios.id
	JOIN Pedidos ON clientes.id = pedidos.clienteId
	JOIN LineasPedido ON pedidos.id = lineaspedido.pedidoId
	JOIN Productos ON lineaspedido.productoId = productos.id
	GROUP BY clientes.id
	HAVING 
	  (SELECT SUM(lp1.unidades)
	   FROM LineasPedido lp1
	   JOIN Productos pr1 ON lp1.productoId = pr1.id
	   JOIN Pedidos p1 ON lp1.pedidoId = p1.id
	   WHERE p1.clienteId = clientes.id AND pr1.puedeVenderseAMenores = FALSE) >
	  (SELECT SUM(lp2.unidades)
	   FROM LineasPedido lp2
	   JOIN Productos pr2 ON lp2.productoId = pr2.id
	   JOIN Pedidos p2 ON lp2.pedidoId = p2.id
	   WHERE p2.clienteId = clientes.id AND pr2.puedeVenderseAMenores = TRUE);
	   
SELECT usuarios.nombre, COUNT(pedidos.id) AS total_pedidos
	FROM pedidos
	JOIN clientes ON pedidos.clienteId= clientes.id
	JOIN usuarios ON clientes.usuarioId=usuarios.id
	GROUP BY usuarios.nombre
	ORDER BY total_pedidos ASC 
	LIMIT 1;
			
SELECT pedidos.id, SUM(lineaspedido.precioUnitario * lineaspedido.unidades) AS total_precio
	FROM pedidos
	JOIN lineaspedido ON pedidos.id = lineaspedido.pedidoId
	GROUP BY Pedidos.id;
	
SELECT Pedidos.id AS pedido_id, 
  SUM(LineasPedido.precioUnitario * LineasPedido.unidades) AS total_precio,
  
  (SELECT MAX(t.total) 
   FROM (SELECT SUM(lp.precioUnitario * lp.unidades) AS total
         FROM Pedidos p
         JOIN LineasPedido lp ON p.id = lp.pedidoId
         GROUP BY p.id) AS t) AS importe_maximo
FROM Pedidos
JOIN LineasPedido ON Pedidos.id = LineasPedido.pedidoId 
GROUP BY Pedidos.id
HAVING total_precio = importe_maximo;

SELECT productos.nombre , productos.id
from productos 
LEFT JOIN lineaspedido ON productos.id=lineaspedido.productoId
WHERE lineaspedido.productoId IS null;

SELECT MONTH(pedidos.fechaRealizacion) AS Mes, SUM(LineasPedido.precioUnitario * LineasPedido.unidades) AS total_precio 
FROM pedidos 
JOIN LineasPedido ON Pedidos.id = LineasPedido.pedidoId
GROUP BY MONTH(pedidos.fechaRealizacion);


SELECT usuarios.nombre AS empleado, sum(lineaspedido.preciounitario*lineaspedido.unidades) AS ventas_empleado
FROM usuarios
JOIN empleados ON usuarios.id=empleados.usuarioId
JOIN pedidos ON empleados.id= pedidos.empleadoId
JOIN lineaspedido ON pedidos.id=lineaspedido.pedidoId
GROUP BY empleado
ORDER BY ventas_empleado ASC
LIMIT 1;

SELECT usuarios.nombre, SUM(lineaspedido.precioUnitario*lineaspedido.unidades) AS dinero
FROM empleados 
JOIN usuarios ON empleados.usuarioId=usuarios.id
JOIN pedidos ON pedidos.empleadoId=empleados.id
JOIN lineaspedido ON lineaspedido.pedidoId=pedidos.id
GROUP BY empleados.id
HAVING dinero>=1000.00;



 	
 	
 	
 	
 	