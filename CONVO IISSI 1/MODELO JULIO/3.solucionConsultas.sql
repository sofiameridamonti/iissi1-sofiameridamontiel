-- 3.1
SELECT
 productos.id,
 productos.nombre AS producto
 FROM productos
 left JOIN promociones ON productos.id= promociones.productoId
 WHERE promociones.id IS NULL;


-- 3.2
SELECT 
	productos.id AS id_producto,
	productos.nombre AS nombre_producto,
	productos.precio AS precio_original,
	ROUND(productos.precio *(1-promociones.descuento)) AS precio_final
	FROM productos
	JOIN promociones ON productos.id =promociones.productoId
	WHERE CURRENT_DATE BETWEEN promociones.fechaInicio AND promociones.fechaFin;

-- 3.3

SELECT 
	productos.nombre,
	productos.id,
	COUNT(promociones.productoId) AS numero_promociones
	FROM productos
	left JOIN promociones ON productos.id =promociones.productoId
	GROUP BY productos.nombre, productos.id
	ORDER BY numero_promociones desc;
	

