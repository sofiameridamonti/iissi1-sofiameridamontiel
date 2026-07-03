# Enunciado Evaluación Individual de Laboratorio - Modelo C
**Si usted entrega sin haber sido verificada su identidad no podrá ser evaluado.**

## Tienda Online

Partiendo de la `tiendaOnline` vista durante los laboratorios descrita en el modelado conceptual siguiente:

![tiendaOnlineModeladoConceptual](https://github.com/user-attachments/assets/92eb4ba8-1ed8-488b-bb5b-448c0836fee6)

Las tablas y datos de prueba iniciales se encuentran en los ficheros `0.creacionTablas.sql` y `0.poblarBd.sql`.

Realice los siguientes ejercicios:

### 1. Creación de tabla. (1,5 puntos)

Incluya su solución en el fichero `1.solucionCreacionTabla.sql`.

Necesitamos conocer la opinión de nuestros clientes sobre nuestros productos. Para ello se propone la creación de una nueva tabla llamada `Valoraciones`. Cada valoración versará sobre un producto y será realizada por un solo cliente. Cada producto podrá ser valorado por muchos clientes. Cada cliente podrá realizar muchas valoraciones. Un cliente no puede valorar más de una vez un mismo producto.

Para cada valoración necesitamos conocer la puntuación de 1 a 5 (sólo se permiten enteros) y la fecha en que se realiza la valoración.

### 2. Consultas SQL (DQL). 3 puntos

Incluya su solución en el fichero `2.solucionConsultas.sql`.

#### 2.1. Devuelva el nombre del producto, el precio unitario y las unidades compradas para las 5 líneas de pedido con más unidades. (1 punto)

#### 2.3. Devuelva el nombre del empleado, la fecha de realización del pedido, el precio total del pedido y las unidades totales del pedido para todos los pedidos que de más 7 días de antigüedad desde que se realizaron. Si un pedido no tiene asignado empleado, también debe aparecer en el listado devuelto. (2 puntos)

### 3. Procedimiento. Bonificar pedido retrasado. 3,5 puntos

Incluya su solución en el fichero `3.solucionProcedimiento.sql`.

Cree un procedimiento que permita bonificar un pedido que se ha retrasado debido a la mala gestión del empleado a cargo. Recibirá un identificador de pedido, asignará a otro empleado como gestor y reducirá un 20% el precio unitario de cada línea de pedido asociada a ese pedido. (1,5 puntos)

Asegure que el pedido estaba asociado a un empleado y en caso contrario lance excepción con el siguiente mensaje: (1 punto)

`El pedido no tiene gestor`.

Garantice que o bien se realizan todas las operaciones o bien no se realice ninguna. (1 punto)

### 4. Trigger. 2 puntos

Incluya su solución en el fichero `4.solucionTrigger.sql`.

Cree un trigger llamado `p_limitar_unidades_mensuales_de_productos_fisicos` que, a partir de este momento, impida la venta de más de 1000 unidades al mes de cualquier producto físico.

## Procedimiento de entrega:

### 1. Comprimir ficheros

Cree un fichero `zip` que incluya los ficheros:

* `1.solucionCreacionTabla.sql`
* `2.solucionConsultas.sql`
* `3.solucionProcedimiento.sql`
* `4.solucionTrigger.sql`

### 2. Subir fichero `zip`

Súba el `zip` como fichero de solución en el examen de enseñanza virtual. **No pulse aún en enviar.**

### 3. Avisar a profesor ANTES de realizar la entrega

Antes de realizar la entrega, levante la mano y muestre su DNI o similar al profesor del aula para la verificación de su identidad.

**Si usted entrega sin haber sido verificada su identidad no podrá ser evaluado.**
