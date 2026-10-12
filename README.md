https://github.com/orgs/IISSI1-IS-2025/repositories

----------------PLANTILLA PROCEDURE----------------
DELIMITER //

CREATE PROCEDURE nombre_procedimiento(
    IN p_parametro1 INT,
    IN p_parametro2 DECIMAL(10,2)
    -- OUT p_resultado INT  -- (Descomentar solo si te piden un parámetro de salida)
)
BEGIN
    ------------------------------------------------------------------
    -- 1. DECLARACIÓN DE VARIABLES LOCALES (¡SIEMPRE AL PRINCIPIO!)
    ------------------------------------------------------------------
    DECLARE v_variable1 INT;
    DECLARE v_variable2 DECIMAL(10,2);
    -- DECLARE v_existe BOOLEAN;

    ------------------------------------------------------------------
    -- 2. HANDLER DE CONTROL DE ERRORES (Garantiza "Todo o Nada")
    ------------------------------------------------------------------
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        -- SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error inesperado en la base de datos';
    END;

    ------------------------------------------------------------------
    -- 3. INICIO DE LA TRANSACCIÓN
    ------------------------------------------------------------------
    START TRANSACTION;

    ------------------------------------------------------------------
    -- 4. CAPTURA DE DATOS (SELECT ... INTO)
    ------------------------------------------------------------------
    SELECT columna1, columna2
    INTO v_variable1, v_variable2
    FROM Tabla
    WHERE id = p_parametro1;

    ------------------------------------------------------------------
    -- 5. VALIDACIONES Y ERRORES (SIGNAL)
    ------------------------------------------------------------------
    -- Validación A: ¿Existe el registro buscado?
    IF v_variable1 IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El registro especificado no existe.';
    END IF;

    -- Validación B: Regla de negocio personalizada (Ejemplo: precio / stock / permiso)
    IF v_variable2 < p_parametro2 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Mensaje de error exacto del enunciado.';
    END IF;

    ------------------------------------------------------------------
    -- 6. OPERACIONES (UPDATE / INSERT / DELETE)
    ------------------------------------------------------------------
    -- Operación 1: Actualizar tabla principal
    UPDATE TablaPrincipal
    SET columna = p_parametro2
    WHERE id = p_parametro1;

    -- Operación 2: Actualizar o insertar en tabla secundaria (si aplica)
    UPDATE TablaSecundaria ts
    JOIN TablaPrincipal tp ON ts.relacionId = tp.id
    SET ts.columna = p_parametro2
    WHERE tp.id = p_parametro1;

    ------------------------------------------------------------------
    -- 7. CONFIRMACIÓN DEFINITIVA
    ------------------------------------------------------------------
    COMMIT;

    DELIMITER //

----------------PLANTILLA TRIGGER----------------

CREATE TRIGGER nombre_trigger
BEFORE INSERT ON NombreTabla  -- Opciones de tiempo: BEFORE | AFTER
                              -- Opciones de evento: INSERT | UPDATE | DELETE
FOR EACH ROW
BEGIN
    ------------------------------------------------------------------
    -- 1. DECLARACIÓN DE VARIABLES LOCALES (¡SIEMPRE AL PRINCIPIO!)
    ------------------------------------------------------------------
    DECLARE v_variable INT;
    DECLARE v_existe BOOLEAN;

    ------------------------------------------------------------------
    -- 2. CAPTURA / LECTURA DE DATOS DE OTRAS TABLAS (SELECT ... INTO)
    ------------------------------------------------------------------
    -- Ejemplo A: Consultar un dato de otra tabla relacionado con la fila entrante
    SELECT columna 
    INTO v_variable 
    FROM OtraTabla 
    WHERE id = NEW.idRelacionado; -- Usa NEW en INSERT/UPDATE

    -- Ejemplo B: Comprobar si existe un conflicto/duplicado/incompatibilidad
    SELECT EXISTS (
        SELECT 1 
        FROM OtraTabla 
        WHERE id = NEW.idRelacionado AND condicion = 'x'
    ) INTO v_existe;

    ------------------------------------------------------------------
    -- 3. VALIDACIÓN DE REGLAS DE NEGOCIO Y ERROR (SIGNAL)
    ------------------------------------------------------------------
    -- Si rompe alguna regla, cancelamos lanzando una excepción:
    IF v_existe THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Mensaje de error exacto del enunciado.';
    END IF;

    -- Ejemplo de validación directa con valores de la misma fila:
    -- IF NEW.precio < 0 THEN ...

    ------------------------------------------------------------------
    -- 4. ACCIONES SECUNDARIAS (Opcional, muy habitual en triggers AFTER)
    ------------------------------------------------------------------
    -- UPDATE OtraTabla SET stock = stock - NEW.unidades WHERE id = NEW.productoId;

END //

DELIMITER ;

END //

DELIMITER ;
