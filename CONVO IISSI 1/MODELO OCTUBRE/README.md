# Enunciado Evaluación Individual de Laboratorio - Modelo A
**Si usted entrega sin haber sido verificada su identidad no podrá ser evaluado.**

## Tienda Online

Partiendo de la `tiendaOnline` vista durante los laboratorios descrita en el modelado conceptual siguiente:

![tiendaOnlineModeladoConceptual](https://github.com/user-attachments/assets/92eb4ba8-1ed8-488b-bb5b-448c0836fee6)

Las tablas y datos de prueba iniciales se encuentran en los ficheros `0.creacionTablas.sql` y `0.poblarBd.sql`.

Realice los siguientes ejercicios:

### 1. Creación de tabla. (2,5 puntos)

Incluya su solución en el fichero `1.solucionCreacionTabla.sql`.

Necesitamos guardar información sobre los envíos realizados por la empresa y el estado de los mismos. Para ello se propone la creación de una nueva tabla llamada `Envios`. Cada pedido se enviará en un solo envío, pero en cada envío se podrán incluir varios pedidos (al menos uno). **(1 punto)**

Además de la creación de la nueva tabla, adicionalmente tendrá que modificarse la tabla de pedidos de forma conveniente **(1 punto)** para cumplir con la tercera forma normal (3FN).

Para cada envío necesitamos conocer la fecha de creación del envío, la fecha de entrega (si la hay) y el estado del mismo, que puede ser "En preparación", "Enviado" o "Entregado". Asegure que la fecha de entrega (si la hay) es posterior a la fecha de envío. **(0,5 puntos)**

**NOTA:** el fichero `1.solucionCreacionTabla.sql` incluye comentarios y código para facilitar el ejercicio.

### 2. Inserciones. (1 punto)

Incluya su solución en el fichero `2.solucionInsercion.sql`.

Inserte los siguientes envíos en la nueva tabla con las siguientes características:

* Envío 1: fecha de envío 23/10/2025, sin fecha de entrega, estado "En preparación". Asociado a los pedidos 1 y 2.
* Envío 2: fecha de envío 03/06/2010, fecha de entrega 05/06/2010, estado "Entregado". Asociado al pedido 3.
* Envío 3: fecha de envío 22/10/2025, sin fecha de entrega, estado "En preparación". Asociado al pedido 5.

Inserte de nuevo la información de los pedidos y líneas de pedido que se encuentran en el archivo `0.poblarBd.sql` ya que ha debido recrear las tablas de `pedidos` y `lineaspedido`, borrando todas las filas en el proceso. Para los pedidos, recuerde incluir la referencia a los envíos y modificar lo necesario para cumplir con la tercera forma normal (3FN).

**NOTA:** el fichero `2.solucionInsercion.sql` incluye comentarios y código para facilitar el ejercicio.

### 3. Consultas. (2,5 puntos)

Incluya su solución en el fichero `2.solucionConsultas.sql`.

#### 3.1. Consulta para listar el nombre de los usuarios (sin repeticiones) que tengan al menos un pedido sin entregar. (1 punto)

#### 3.2. Consulta para mostrar los envíos sin fecha de entrega que contengan pedidos de más de un cliente distinto ordenados por fecha de envío. Para cada envío necesitamos el id de envío, la fecha de envío y el número de clientes distintos del envío. (1,5 puntos)

### 4. Procedimiento. Dar de alta un nuevo envío. (2 puntos)

Incluya su solución en el fichero `3.solucionProcedimiento.sql`.

Cree un procedimiento que permita dar de alta un nuevo envío, con fecha de envío la de hoy, y asignarle todos aquellos pedidos realizados hasta el día de ayer y que NO hayan sido incluídos en ningún otro envío aún. (1,5 puntos)

Garantice que o bien se realizan todas las operaciones o bien no se realice ninguna. (0,5 puntos)

### 5. Trigger. (2 puntos)

Incluya su solución en el fichero `4.solucionTrigger.sql`.

Cree un trigger llamado `trg_asegurar_envio_pedidos_fisicos` que impida que un pedido sea enviado si no incluye productos físicos.

## Procedimiento de entrega:

### 1. Comprimir ficheros

Cree un fichero `zip` que incluya los ficheros:

* `1.solucionCreacionTabla.sql`
* `2.solucionInsercion.sql`
* `3.solucionConsultas.sql`
* `4.solucionProcedimiento.sql`
* `5.solucionTrigger.sql`

### 2. Subir fichero `zip`

Súba el `zip` como fichero de solución en el examen de enseñanza virtual. **No pulse aún en enviar.**

### 3. Avisar a profesor ANTES de realizar la entrega

Antes de realizar la entrega, levante la mano y muestre su DNI o similar al profesor del aula para la verificación de su identidad.

**Si usted entrega sin haber sido verificada su identidad no podrá ser evaluado.**
