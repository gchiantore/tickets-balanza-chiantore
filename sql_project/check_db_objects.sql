-- QUERIES PARA VERIFICAR LAS CREACIONES Y CHEQUEAR DE QUE FUE EXITOSA LA CREACION DE CADA UNA

USE BALANZA;

SELECT 
    TABLE_NAME, 
    TABLE_COMMENT
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_SCHEMA = 'BALANZA';


-- VERIFICACION DE IMPORTACION

SELECT 
    TABLE_NAME AS `Table`, 
    TABLE_ROWS AS `Row Count`
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_SCHEMA = 'BALANZA'
ORDER BY 
    TABKE_ROWS DESC;


-- VERIFICACION DE VISTAS
SELECT 
    TABLE_NAME AS `Vista`,
    TABLE_TYPE AS `Tipo`
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_SCHEMA = 'BALANZA' 
    AND TABLE_TYPE = 'VIEW'
ORDER BY 
    TABLE_NAME;

-- VERIFICACION DE FUNCIONES
SELECT 
    ROUTINE_NAME AS `Función`,
    DATA_TYPE AS `Tipo de Retorno`
FROM 
    INFORMATION_SCHEMA.ROUTINES
WHERE 
    ROUTINE_SCHEMA = 'BALANZA' 
    AND ROUTINE_TYPE = 'FUNCTION'
ORDER BY 
    ROUTINE_NAME;

-- VERIFICACION DE PROCEDURES

SELECT 
    ROUTINE_NAME AS `Procedimiento`,
    ROUTINE_TYPE AS `Tipo`
FROM 
    INFORMATION_SCHEMA.ROUTINES
WHERE 
    ROUTINE_SCHEMA = 'BALANZA' 
    AND ROUTINE_TYPE = 'PROCEDURE'
ORDER BY 
    ROUTINE_NAME;

-- VERIFICACION DE TRIGGERS

SELECT 
    TRIGGER_NAME AS `Nombre del Trigger`,
    EVENT_MANIPULATION AS `Evento`,
    EVENT_OBJECT_TABLE AS `Tabla`,
    ACTION_TIMING AS `Momento`
FROM 
    INFORMATION_SCHEMA.TRIGGERS
WHERE 
    TRIGGER_SCHEMA = 'BALANZA'
ORDER BY 
    EVENT_OBJECT_TABLE, 
    ACTION_TIMING, 
    EVENT_MANIPULATION;
