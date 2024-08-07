USE BALANZA;


DROP FUNCTION IF EXISTS CONTAR_TICKET_PENDIENTES_CLIENTE;
DROP FUNCTION IF EXISTS CALCULAR_PRECIO_TICKET;
DROP FUNCTION IF EXISTS CALCULAR_PESO_NETO;
DROP FUNCTION IF EXISTS DETERMINAR_ESTADO;



-- ESTA FUNCION ME DEVUELVE LA CANTIDAD DE TICKETS PENDIENTES DE UN CLIENTE EN UN RANGO DETERMINADO DE FECHAS 
-- EJEMPLO : SELECT CONTAR_TICKET_PENDIENTES_CLIENTE(3,'2024-01-05','2024-07-14');
DELIMITER //

CREATE FUNCTION CONTAR_TICKET_PENDIENTES_CLIENTE(CLIENTE_ID INT, F_INICIO DATETIME, F_FIN DATETIME) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE Q_PENDIENTES INT;
    
    SELECT COUNT(*) INTO Q_PENDIENTES
    FROM TICKETS
    WHERE IDCLIENTE = CLIENTE_ID
    AND FECHA >= F_INICIO
    AND FECHA <= F_FIN
    AND PENDIENTE=0;
    
    RETURN Q_PENDIENTES;
END //

DELIMITER ;


-- CALCULA EL PRECIO DEL TICKET EN FUNCION DE LA CONDICION COMERCIAL QUE TIENE EL CLINETE
-- EJEMPLO : SELECT CALCULAR_PRECIO_TICKET(3);

DELIMITER //
CREATE FUNCTION CALCULAR_PRECIO_TICKET(CLIENTEID INT) RETURNS DECIMAL
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE PRECIO DECIMAL;
    SELECT CO.PRECIO INTO PRECIO
    FROM CONDICION CO
    LEFT JOIN CLIENTES CL
    ON CO.IDCONDICION=CL.IDCONDICION
    WHERE CL.IDCLIENTE = CLIENTEID;
    RETURN PRECIO;
END //

DELIMITER ;


DELIMITER //

-- CALCULA EL PESO NETO (BRUTO-TARA) DE UN TICKET
-- EJEMPLO : SELECT CALCULAR_PESO_NETO(18339);

CREATE FUNCTION CALCULAR_PESO_NETO(TICKET INT) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE NETO INT;
    DECLARE BRUTO INT;
    DECLARE TARA INT;
    
    SELECT BRUTOPESO, TARAPESO INTO BRUTO, TARA
    FROM TICKETS TI
    WHERE TI.IDTICKET = TICKET;
    
    IF TARA=0 OR BRUTO=0 THEN 
		SET NETO = TARA;
    ELSE
		SET NETO = BRUTO-TARA;
    END IF;   
        
    RETURN NETO;
END //

DELIMITER ;

DELIMITER //

-- DETERMINA SI EL TICKET ESTA PENDIENTE O NO DE ACUERDO A SI SE HA PESADO LA TARA Y EL BRUTO
-- EJEMPLO : SELECT DETERMINAR_ESTADO(18339);

CREATE FUNCTION DETERMINAR_ESTADO(TICKET INT) RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE PENDIENTE BOOLEAN;
    DECLARE BRUTO INT;
    DECLARE TARA INT;
    
    SELECT BRUTOPESO, TARAPESO INTO BRUTO, TARA
    FROM TICKETS TI
    WHERE TI.IDTICKET = TICKET;
    
    IF TARA=0 OR BRUTO=0 THEN 
		SET PENDIENTE = true;
    ELSE
		SET PENDIENTE = false;
    END IF;   
        
    RETURN PENDIENTE;
END //

DELIMITER ;

SELECT DETERMINAR_ESTADO(18339);