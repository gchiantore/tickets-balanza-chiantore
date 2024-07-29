USE BALANZA;


-- CANTIDAD DE TICKETS POR FECHA Y TURNO
CREATE VIEW TICKETS_POR_TURNOS AS 
SELECT 
	TI.FECHA
, 	TU.NOMBRE
, 	COUNT(TI.IDTICKET) 
FROM 
	TICKETS AS TI 
JOIN TURNOS AS TU 
ON TU.IDTURNO=TI.IDTURNO 
GROUP BY TI.FECHA,TU.IDTURNO;

