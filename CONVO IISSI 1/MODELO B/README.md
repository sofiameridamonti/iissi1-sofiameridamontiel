# Enunciado Evaluación Individual de Laboratorio - Modelo B
**Si usted entrega sin haber sido verificada su identidad no podrá ser evaluado.**

## Tienda Online

Partiendo de la `tiendaOnline` vista durante los laboratorios descrita en el modelado conceptual siguiente:

![tiendaOnlineModeladoConceptual](https://github.com/user-attachments/assets/92eb4ba8-1ed8-488b-bb5b-448c0836fee6)

Las tablas y datos de prueba iniciales se encuentran en los ficheros `0.creacionTablas.sql` y `0.poblarBd.sql`.

Realice los siguientes ejercicios:

### 1. Creación de tabla. (1,5 puntos)

Incluya su solución en el fichero `1.solucionCreacionTabla.sql`.


Necesitamos conocer los pagos que se realicen sobre los pedidos. Para ello se propone la creación de una nueva tabla llamada `Pagos`. Cada pedido podrá tener asociado varios pagos y cada pago solo corresponde con un pedido en concreto.

Para cada pago necesitamos conocer la fecha de pago, la cantidad pagada (que no puede ser negativa) y si el pago ha sido revisado o no (por defecto no estará revisado).

### 2. Consultas SQL (DQL). 3 puntos

Incluya su solución en el fichero `2.solucionConsultas.sql`.

#### 2.1. Devuelva el nombre del del empleado, la fecha de realización del pedido y el nombre del cliente de todos los pedidos realizados este mes. (1 puntos)

#### 2.2. Devuelva el nombre, las unidades totales pedidas y el importe total gastado de aquellos clientes que han realizado más de 5 pedidos en el último año. (2 puntos)

### 3. Procedimiento. 3,5 puntos

Incluya su solución en el fichero `3.solucionProcedimiento.sql`.

Cree un procedimiento que permita crear un nuevo producto con posibilidad de que sea para regalo. Si el producto está destinado a regalo se creará un pedido con ese producto y costes 0€ para el cliente más antiguo. (1,5 puntos)

Asegure que el precio del producto para regalo no debe superar los 50 euros y lance excepción si se da el caso con el siguiente mensaje: (1 punto)

`No se permite crear un producto para regalo de más de 50€`.

Garantice que o bien se realizan todas las operaciones o bien no se realice ninguna. (1 punto)

### 4. Trigger. 2 puntos

Incluya su solución en el fichero `4.solucionTrigger.sql`.

Cree un trigger llamado `t_limitar_importe_pedidos_de_menores` que impida que, a partir de ahora, los pedidos realizados por menores superen los 500€.

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
