USE BALANZA;


-- Ejemplo de la vista TICKETS POR TURNOS, 

select * from TICKETS_POR_TURNOS where FECHA='2024-01-15';

-- Ejemplo de la vista Cantidad de Tickets por turno y fecha

select * from CANTIDAD_TICKETS_POR_TURNOS where fecha='2024-01-15';

-- Ejemplo Tipo de productos - Productos 

select * from TIPODEPRODUCTOS_PRODUCTOS;

-- Ejemplo Operarios - Empresas

select * from OPERARIOS_EMPRESAS;

-- Ejemplo Clientes - Condiciones

select * from CLIENTES_CONDICIONES;

-- Ejemplo Tickets pendientes

select * from TICKETS_PENDIENTES where fecha='2024-01-15';

