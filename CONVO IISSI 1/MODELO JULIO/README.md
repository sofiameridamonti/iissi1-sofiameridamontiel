# Enunciado del Examen Individual de Laboratorio - Segunda Convocatoria

**Si usted entrega sin haber sido verificada su identidad no podrá ser evaluado.**

## Tienda Online

Partiendo de la `tiendaOnline` vista durante los laboratorios descrita en el modelado conceptual siguiente:

![tiendaOnlineModeladoConceptual](https://github.com/user-attachments/assets/92eb4ba8-1ed8-488b-bb5b-448c0836fee6)

Las tablas y datos de prueba iniciales se encuentran en los ficheros `0.1.creacionTablas.sql` y `0.2.poblarBd.sql`. Cree una base de datos y ejecute dichos scripts en el citado orden.

Realice los siguientes ejercicios:

### 1. Creación de tabla. 1 punto

Incluya su solución en el fichero `1.solucionCreacionTabla.sql`.

Necesitamos conocer las promociones de nuestros productos. Para ello se propone la creación de una nueva tabla llamada `Promociones`. Cada promoción solo estará relacionada con un producto, de manera que no todos los productos están promocionados.

Para cada promoción necesitamos conocer el descuento aplicado en forma de un valor mayor que 0 y menor o igual a 1, la fecha de inicio y fecha de fin de la promoción.

Asegure que la fecha de fin de la promoción es posterior a la fecha de inicio.

### 2. Inserción de datos. 1 punto

Incluya su solución en el fichero `2.solucionInsercionTabla.sql`.
A continuación, se detallan las promociones a ingresar:

* Para el producto con ID 1, que corresponde a un smartphone, se aplicaron estas promociones:
  * un 10% de descuento, vigente desde el 1 de enero de 2024 hasta el 15 de enero de 2024.
  * un 15% de descuento, vigente desde el 1 de enero de 2025 hasta el 15 de enero de 2025.
  * un 20% de descuento, vigente desde el 1 de junio de 2025 hasta el 30 de junio de 2025.
* Para el producto con ID 2, que corresponde a un laptop, tiene las siguientes promociones:
  * 30% de descuento, válida desde el 1 de julio de 2024 hasta el 31 de julio de 2024.
  * 20% de descuento, válida desde el 1 de julio de 2025 hasta el 31 de julio de 2025.
* Para el producto con ID 3, un libro electrónico, se ofrece un 10% de descuento, desde el 1 de julio de 2025 hasta el 31 de julio de 2025.
* El producto con ID 4, correspondiente a un videojuego, tiene programada una promoción del 40% de descuento, que estará vigente del 1 al 31 de agosto de 2025.
* El producto con ID 7, una película, tuvo una promoción del 5% de descuento desde el 1 hasta el 30 de junio de 2025.
* Por último, el producto con ID 9, una tableta gráfica, cuenta con una promoción activa del 10% de descuento, vigente del 1 al 31 de julio de 2025.

### 3. Consultas. 3,5 puntos

Incluya sus soluciones en el fichero `3.solucionConsultas.sql`.

#### 3.1. (1 punto)

Obtener los ids y nombres de productos que no tienen ninguna promoción asociada.

#### 3.2. (1,25 puntos)

Obtener las los productos con promociones activas. El resultado debe incluir el id y el nombre del producto, el precio sin promoción y el precio con la promoción aplicada.

#### 3.3 (1,25 puntos)

Obtener los productos ordenados por el número de promociones que tienen asociadas. El resultado debe incluir el id del producto, el nombre del producto y el número de promociones asociadas. Si un producto nunca ha sido promocionado también debe aparecer entre los resultados.

### 4. Trigger. 2 puntos

Incluya su solución en el fichero `4.solucionTrigger.sql`.

Cree un trigger llamado `trg_actualizar_precio_pedido_promocion` que aplique las promociones activas cuando se realice un pedido.

### 5. Procedimiento. 2,5 puntos

Incluya su solución en el fichero `5.solucionProcedimiento.sql`.

Cree un procedimiento almacenado con transacción llamado `p_anularPedido` que reciba como parámetro un número de pedido. Deberá actualizar el campo de stock de aquellos productos que participaban del pedido, así como eliminar las líneas de pedido y el propio pedido.

## Procedimiento de entrega

### 1. Comprimir ficheros

Cree un fichero `zip` que incluya los ficheros:

* `1.solucionCreacionTabla.sql`
* `2.solucionInsercionTabla.sql`
* `3.solucionConsultas.sql`
* `4.solucionTrigger.sql`
* `5.solucionProcedimiento.sql`

### 2. Subir fichero `zip`

Súba el `zip` como fichero de solución en el examen de enseñanza virtual. **No pulse aún en enviar.**

### 3. Avisar a profesor ANTES de realizar la entrega

Antes de realizar la entrega, levante la mano y muestre su DNI o similar al profesor del aula para la verificación de su identidad.

**Si usted entrega sin haber sido verificada su identidad no podrá ser evaluado.**
