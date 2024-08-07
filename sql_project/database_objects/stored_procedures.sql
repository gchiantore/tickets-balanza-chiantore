USE BALANZA;

DROP PROCEDURE IF EXISTS CREA_OPERARIO;
DROP PROCEDURE IF EXISTS CREA_PRODUCTO;



DELIMITER //

CREATE PROCEDURE CREA_OPERARIO(
    IN O_NOMBRE VARCHAR(100),
    IN O_TELEFONO VARCHAR(20),
    IN O_CORREO VARCHAR(100),
    IN O_IDEMPRESA INT
)
BEGIN
    DECLARE EMPRESA INT;
    
    -- Verificar si el restaurante existe
    SELECT COUNT(*) INTO EMPRESA
    FROM EMPRESA
    WHERE IDEMPRESA = O_IDEMPRESA;
    
    IF EMPRESA > 0 THEN
        INSERT INTO OPERARIO (NOMBRE, TELEFONO, CORREO, IDEMPRESA)
        VALUES (O_NOMBRE, O_TELEFONO, O_CORREO, O_IDEMPRESA);
        
        SELECT 'Operario ingresado exitosamente';
    ELSE
        SELECT 'No pudimos vincular el operario a la empresa especifidada por que no existe';
    END IF;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE CREA_PRODUCTO(
    IN P_NOMBRE VARCHAR(100),
    IN P_IDTIPOPRODUCTO INT,
    IN P_ICONO VARCHAR(100)
)
BEGIN
    DECLARE TIPOPRODUCTO INT;

    SELECT COUNT(*) INTO TIPOPRODUCTO
    FROM TIPRODUCTO
    WHERE IDTIPOPRODUCTO = P_IDTIPOPRODUCTO;
    
    IF TIPOPRODUCTO > 0 THEN
        INSERT INTO PRODUCTOS (NOMBRE, IDTIPOPRODUCTO, ICONO)
        VALUES (P_NOMBRE, P_IDTIPOPRODUCTO, P_ICONO);
        
        SELECT 'Producto ingresado exitosamente';
    ELSE
        SELECT 'No pudimos crear el producto porque el tipo al que hace referencia no existe';
    END IF;
END //

DELIMITER ;

DELIMITER //