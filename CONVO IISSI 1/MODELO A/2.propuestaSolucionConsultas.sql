-- 2.1
SELECT
    p.nombre AS nombre_producto,
    tp.nombre AS nombre_tipo_producto,
    lp.precio AS precio_unitario
FROM
    LineasPedido lp
JOIN
    Productos p ON lp.productoId = p.id
JOIN
    TiposProducto tp ON p.tipoProductoId = tp.id
WHERE
    tp.nombre = 'Digitales';


-- 2.2 Solución admisible con condición en LEFT JOIN
SELECT
    u.nombre AS nombre_empleado,
    COUNT(DISTINCT p.id) AS numero_pedidos_mas_de_500,
    SUM(lp.precio * lp.unidades) AS importe_total
FROM
    Empleados e
LEFT JOIN
    Usuarios u ON e.usuarioId = u.id
LEFT JOIN
    Pedidos p ON e.id = p.empleadoId AND YEAR(p.fechaRealizacion) = YEAR(CURDATE()) -- Filtrar pedidos del año actual
LEFT JOIN
    LineasPedido lp ON p.id = lp.pedidoId
GROUP BY
    u.id, u.nombre
HAVING
    SUM(lp.precio * lp.unidades) > 500 OR numero_pedidos_mas_de_500 = 0 -- Incluye empleados sin pedidos
ORDER BY
    importe_total DESC;


-- 2.2 Solución admisible con condición en HAVING (no aparecen empleados sin pedidos)
SELECT
    u.nombre AS nombre_empleado,
    COUNT(DISTINCT p.id) AS numero_pedidos_mas_de_500,
    SUM(lp.precio * lp.unidades) AS importe_total
FROM
    Empleados e
LEFT JOIN
    Usuarios u ON e.usuarioId = u.id
LEFT JOIN
    Pedidos p ON e.id = p.empleadoId
LEFT JOIN
    LineasPedido lp ON p.id = lp.pedidoId
WHERE
    YEAR(p.fechaRealizacion) = YEAR(CURDATE()) -- Filtrar pedidos realizados en el año actual
GROUP BY
    u.id, u.nombre
HAVING
    SUM(lp.precio * lp.unidades) > 500 OR numero_pedidos_mas_de_500 = 0 -- Incluye empleados con pedidos > 500
ORDER BY
    importe_total DESC;



-- 2.2 Solución exahustiva (considera casos raros)
SELECT
    u.nombre AS nombre_empleado,
    COUNT(DISTINCT CASE
                      WHEN YEAR(p.fechaRealizacion) = YEAR(CURDATE())
                           AND (SELECT SUM(lp2.precio * lp2.unidades)
                                FROM LineasPedido lp2
                                WHERE lp2.pedidoId = p.id) > 500
                      THEN p.id
                  END) AS numero_pedidos_mas_de_500,
    SUM(CASE
            WHEN YEAR(p.fechaRealizacion) = YEAR(CURDATE())
                 AND (SELECT SUM(lp2.precio * lp2.unidades)
                      FROM LineasPedido lp2
                      WHERE lp2.pedidoId = p.id) > 500
            THEN lp.precio * lp.unidades
            ELSE 0
        END) AS importe_total
FROM
    Empleados e
LEFT JOIN
    Usuarios u ON e.usuarioId = u.id
LEFT JOIN
    Pedidos p ON e.id = p.empleadoId
LEFT JOIN
    LineasPedido lp ON p.id = lp.pedidoId
GROUP BY
    u.id, u.nombre
HAVING
    numero_pedidos_mas_de_500 > 0
    OR numero_pedidos_mas_de_500 = 0 -- Incluye empleados sin pedidos
ORDER BY
    importe_total DESC;
