# Laboratorio 3 - DML

En esta sesión de laboratorio se aboradrá el uso de instrucciones de manipulación de datos en SQL.

## Puesta en marcha de BD de tiendaOnline

Revise la documentación del laboratorio 2 para crear y poner en marcha la base de datos `tiendaOnline` que es una versión minimalista para soportar la compra y venta de productos de una tienda online genérica. Se proponía el siguiente modelo conceptual:
![Modelo conceptual Tienda Online](./images/ejemploTienda.svg).

El modelo conceptual anterior se transformó en el siguiente modelo relacional:

```Javascript
Usuario(!id, #email, contraseña, nombre)
Empleado(!id, @usuarioId, salario)
Cliente(!id, @usuarioId, direccionEnvio, codigoPostal, fechaNacimiento)
Pedido(!id, @clienteId, @empleadoId, fechaRealizacion, fechaEnvio, direccionEntrega, comentarios)
LineaPedido(!id, #(@pedidoId, @productoId), unidades, precioUnitario)
Producto(!id, nombre, descripción, precioUnitario, @tipoProductoId, puedeVenderseAMenores)
TipoProducto(!id, nombre)
```

e incluía las siguientes restricciones en lenguaje natural:

1. La constraseña debe ser de al menos 8 caracteres
1. El cliente debe ser mayor de 14 años
1. Los clientes menores de 18 años no pueden pedir productos que !puedeVenderseAMenores
1. Los precios no pueden ser negativos
1. La cantidad de un producto en un pedido no puede ser 0 ni superar 100.

Nótese que se ha optado por trasladar cada elemento de la generalización en una relación. Recuerde que hay otras alternativas viables y que cada una tiene sus ventajas e inconvenientes.

## Script proporcionados

Se le vuelve a proporcionar el script siguiente:

1. Fichero `scripts/1.creacionTablas.sql` con todo el código SQL para la creación de las tablas y que aparece en este documento.

## Ejercicio 1: Inserciones en distintas tablas

Recuerde la sintaxis de la operación `INSERT`. Consulte el manual de mariadb para los detalles sintácticos: <https://mariadb.com/kb/en/insert/>

1. **Inserta datos válidos** en la tabla `Usuarios` para cuatro usuarios diferentes, asegurándote de que la contraseña cumpla con la longitud mínima de 8 caracteres y el email sea único.
2. **Inserta un cliente** con una edad superior a 14 años en la tabla `Clientes`, relacionado con uno de los usuarios previamente creados.
3. **Inserta un cliente** con una edad superior a 14 años y menor de 18 años en la tabla `Clientes`, relacionado con uno de los usuarios previamente creados.
4. **Inserta un cliente** que no tendrá ningun pedido.
4. **Inserta un empleado** en la tabla `Empleados`, relacionado con uno de los usuarios previamente creados.
6. **Añade tipos de producto** en la tabla `TiposProducto` para categorías de productos (por ejemplo, "Electrónica", "Alimentos" y "Droguería").
5. **Inserta productos** en la tabla `Productos`, asociándolos a los tipos de producto creados previamente. Asegúrate de cumplir con las siguientes características para cada producto:
   - `Auriculares`: Producto de tipo Electrónica, con un precio de 25.00, permitido para menores.
   - `Vino Tinto`: Producto de tipo Alimentos, con un precio de 15.00, **no permitido para menores**.
   - `Chocolate`: Producto de tipo Alimentos, con un precio de 3.50, permitido para menores.
   - `Cargador USB`: Producto de tipo Electrónica, con un precio de 10.00, permitido para menores.
   - `Whisky`: Producto de tipo Alimentos, con un precio de 45.00, **no permitido para menores**.
6. **Inserta un nuevo pedido** para un cliente en la tabla `Pedidos`. Incluye la fecha de realización, la dirección de entrega y algunos comentarios.
   - **Ejemplo:** Inserta un pedido para el cliente con `clienteId = 1`, con la fecha de realización como la fecha actual, sin fecha de envío, dirección de entrega "Calle Ejemplo 45", y comentarios "Entrega urgente".
7. **Añade líneas de pedido válidas** para el pedido creado, asegurándote de que los productos seleccionados y sus cantidades cumplen las restricciones.
   - **Ejemplo:** Inserta una línea de pedido para el producto con `productoId = 1`, indicando 3 unidades y un precio unitario de 10.00. Inserta otra línea de pedido para el `productoId = 2` con 5 unidades y un precio unitario de 15.00.

#### Inserciones que deben fallar

10. **Inserta una línea de pedido con unidades fuera del rango permitido** para un pedido existente, como 150 unidades, para verificar la restricción `CHECK` de `unidades`.

- **Ejemplo:** Para el pedido creado en el primer ejercicio, intenta añadir una línea de pedido con `productoId = 3`, indicando 150 unidades y un precio de 20.00. Observa el error generado.

11. **Inserta una línea de pedido con precio negativo** para verificar la restricción `CHECK` de `precio`.
12. **Inserta un pedido con un producto no vendible a menores** en `LineasPedido` para un cliente menor de 18 años, y verifica que el trigger `check_edad_minorista` se activa.

- **Ejemplo:** Si el cliente con `clienteId = 2` tiene menos de 18 años, intenta insertar un pedido para él en `Pedidos`, y luego añade una línea de pedido en `LineasPedido` con `productoId` de un producto marcado como no vendible a menores (`puedeVenderseAMenores = FALSE`). Observa el error generado por el trigger.
13. Intenta insertar una línea de pedido con un producto ya existente en el pedido para verificar la restricción UNIQUE
14. Intenta insertar un usuario con una **contraseña de menos de 8 caracteres** en la tabla `Usuarios` y observa el error por el CHECK de longitud.
15. Intenta insertar un cliente menor de **14 años en la tabla `Clientes`** y verifica el funcionamiento del trigger `cliente_edad_minima`.
16. Intenta insertar un producto en la tabla `Productos` con **precio negativo** para verificar el CHECK de precio mínimo.


## Ejercicio 2: Actualización de datos en distintas tablas

Recuerde la sintaxis de la operación `UPDATE`. Consulte el manual de mariadb para los detalles sintácticos:<https://mariadb.com/kb/en/update/>

1. **Actualiza el nombre de un usuario** en la tabla `Usuarios`.
2. **Actualiza el salario** de un empleado en la tabla `Empleados`.
3. **Modifica el precio de un producto** en la tabla `Productos` para asegurarte de que el valor sea positivo y mayor o igual a cero.
4. **Actualizar un pedido para incluir la fecha de envío como la fecha actual**. Use la función `CURDATE()` para obtener la fecha actual.
5. **Actualizar un pedido para incluir el empleado que lo gestion**.

### Actualizaciones que deben fallar

6. Intenta actualizar la contraseña de un usuario con una **contraseña de menos de 8 caracteres** para verificar que el CHECK de longitud se respeta.
7. Intenta modificar el precio de un producto en la tabla `Productos` a un **valor negativo** para verificar la restricción de precio mínimo.
8. Intenta actualizar el número de unidades en la tabla `LineasPedido` a un **valor fuera del rango permitido** (mayor a 100) y observa el error generado.

## Ejercicio 3. Borrado de datos en tablas

1. **Borra un tipo de producto** de la tabla `TiposProducto` que no esté relacionado con ningún producto en `Productos`.

### Borrado con efectos en cascada

2. **Borra un usuario** que tenga dependencias en `Clientes` (configurado con `ON DELETE CASCADE`). Al realizar esta operación, los registros en `Clientes` asociados al usuario también deben eliminarse en cascada. Asegurate que el usuario-cliente no tiene pedidos asociados.
3. **Intenta borrar un cliente** que tenga registros asociados en la tabla `Pedidos`. Este borrado debería fallar debido a la configuración de `ON DELETE RESTRICT`, que impide eliminar un cliente con pedidos asociados.
4. **Borra un empleado** que esté asociado a un pedido en `Pedidos`. Esta operación está configurada con `ON DELETE SET NULL`, por lo que el campo `empleadoId` en la tabla `Pedidos` debería establecerse en `NULL` al eliminar el empleado.
