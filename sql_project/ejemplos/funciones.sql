
-- ESTA FUNCION ME DEVUELVE LA CANTIDAD DE TICKETS PENDIENTES DE UN CLIENTE EN UN RANGO DETERMINADO DE FECHAS 
SELECT CONTAR_TICKET_PENDIENTES_CLIENTE(3,'2024-01-05','2024-07-14');

-- CALCULA EL PRECIO DEL TICKET EN FUNCION DE LA CONDICION COMERCIAL QUE TIENE EL CLINETE
SELECT CALCULAR_PRECIO_TICKET(3);

-- CALCULA EL PESO NETO (BRUTO-TARA) DE UN TICKET
SELECT CALCULAR_PESO_NETO(18339);

-- DETERMINA SI EL TICKET ESTA PENDIENTE O NO DE ACUERDO A SI SE HA PESADO LA TARA Y EL BRUTO
SELECT DETERMINAR_ESTADO(18339);