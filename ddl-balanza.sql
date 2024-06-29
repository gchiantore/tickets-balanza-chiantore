-- GENERARACION DEL DDL

DROP DATABASE IF EXISTS BALANZA ;

CREATE DATABASE BALANZA;

USE BALANZA;

-- TABLA TICKETS

CREATE TABLE BALANZA.TICKETS (
    IDTICKET INT PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'Identificador Unico del Ticket',
    IDOPERARIO INT NOT NULL COMMENT 'Identificador del operario que abrió el ticket',
    IDTURNO INT NOT NULL COMMENT 'Identificación del turno en el que se abrió el ticket',
    IDCLIENTE INT NOT NULL COMMENT 'Identificación del cliente al que le hicieron el ticket',
    IDEMPRESA INT NOT NULL COMMENT 'Identificacion de la empresa prestadora de servicio',
    IDPRODUCTO INT NOT NULL COMMENT 'Identificación del producto pesado',
    FECHA DATETIME NOT null COMMENT 'Fecha de creación del ticket',
    ORIGEN VARCHAR(40) NOT NULL COMMENT 'Origen del producto transportado',
    DESTINO VARCHAR(40) NOT NULL COMMENT 'Destino del Producto Transportado',
    BRUTOPESO INT COMMENT 'Peso Bruto',
    BRUTOMODO VARCHAR(1) COMMENT 'Modo de toma del peso Bruto (Manual o Automático)',
    BRUTOOPERARIO INT COMMENT 'Identificación del operario que tomo el peso bruto',
    BRUTOFECHA DATETIME COMMENT 'fecha y hora en que se tomo el peso bruto',
    TARAPESO INT COMMENT 'Peso Tara',
    TARAMODO VARCHAR(1) COMMENT 'Modo de toma del peso Tara (Manual o Automático)',
    TARAOPERARIO INT COMMENT 'Identificación del operario que tomo el peso tara',
    TARAFECHA DATETIME COMMENT 'fecha y hora en que se tomo el peso tara',
    NETO INT COMMENT 'Peso Neto',
    CHASIS VARCHAR(7) NOT NULL COMMENT 'Patente o Dominio del chasis del transporte',
    ACOPLADO VARCHAR(7) COMMENT 'Patente o Dominio del acoplado, puede ser nulo',
    CHOFER VARCHAR(40) DEFAULT 'S/ DATO' COMMENT 'Nombre del Chofer',
    IMPORTE DECIMAL(10,2) COMMENT 'Importe del ticket, este depende de la condición comercial del cliente',
    PENDIENTE BOOLEAN NOT NULL DEFAULT 1 COMMENT 'Si el ticket le falta algún peso queda pendiente',
    OBSERVACIONES VARCHAR(100) COMMENT 'Lugar para escribir alguna observación'
)COMMENT 'Almacena la informacion de tickets de pesaje';

-- TABLA TURNOS 

CREATE TABLE BALANZA.TURNOS (
    IDTURNO INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador Unico del truno',
    NOMBRE VARCHAR(100) NOT NULL COMMENT 'Nombre del Turno',
    COLOR VARCHAR(6) NOT NULL COMMENT 'Color en Hexadecimal con el que se va a identificar el turno',
    ICONO VARCHAR(200) NOT NULL COMMENT 'Archivo del icono que representa al turno'
)COMMENT 'Almacena la informacion de los dostintos turnos de pesaje';

-- TABLA OPERARIOS

CREATE TABLE BALANZA.OPERARIO (
    IDOPERARIO INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador Unico del operario',
    NOMBRE VARCHAR(100) NOT NULL DEFAULT 'SIN NOMBRE' COMMENT 'Nombre o razón social de la empresa',
    TELEFONO VARCHAR(20) COMMENT 'Telefono del operario',
    CORREO VARCHAR(100) COMMENT 'e-mail del operario',
    IDEMPRESA INT NOT NULL COMMENT 'Hace referencia a la empresa a la que pertenece el operario'
)COMMENT 'Almacena los datos de los operadores de la balanza que brindan el servicio';

-- TABLA EMPRESA

CREATE TABLE BALANZA.EMPRESA (
    IDEMPRESA INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador Unico de la empresa',
    RSOCIAL VARCHAR(100) NOT NULL DEFAULT 'SIN RAZón SOCIAL' COMMENT 'Nombre o razón social de la empresa',
    DOMICILIO VARCHAR(100) COMMENT 'Domicilio legal de la empresa',
    LOCALIDAD VARCHAR(50) DEFAULT 'SIN LOCALIDAD' COMMENT 'Localidad donde esta situada la empresa',
    TELEFONO VARCHAR(20) DEFAULT 'S/ TELEFONO' COMMENT 'Telefono de la empresa',
    CORREO VARCHAR(100) COMMENT 'e-mail de la empresa'
)COMMENT 'Almacena los datos de la empresa que brinda el servicio de pesada';

-- TABLA TIPRODUCTO

CREATE TABLE BALANZA.TIPRODUCTO (
    IDTIPOPRODUCTO INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador Unico del tipo de producto',
    TIPO VARCHAR(50) NOT NULL COMMENT 'Descripción del tipo de producto',
    COLOR VARCHAR(6) NOT NULL COMMENT 'Especifica el color en Hexadecimal que identifica al tipo de producto.',
    ICONO VARCHAR(200) NOT NULL COMMENT 'Apunta al archivo con la imagen del icono del tipo de pruducto'

)COMMENT 'Almacena el tipo de producto que se va a pesar';

-- TABLA PRODUCTO

CREATE TABLE BALANZA.PRODUCTOS (
    IDPRODUCTO INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador Unico del producto',
    NOMBRE VARCHAR(100) COMMENT 'Descripción del producto',
    IDTIPOPRODUCTO INT COMMENT 'Hace referencia al tipo o categoría de producto',
    ICONO VARCHAR(200) NOT NULL COMMENT 'Apunta al archivo con la imagen del icono del producto'
)COMMENT 'Almacena los productos que se van a pesar';

-- TABLA CONDICION

CREATE TABLE BALANZA.CONDICION (
    IDCONDICION INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador Unico la condicion',
    DESCRIPCION VARCHAR(100) COMMENT 'Descripcion de la condicion comercial',
    PRECIO DECIMAL(10,2) COMMENT 'precio del servicio de acuerdo a esa condicion',
    DPLAZO INT DEFAULT 0 COMMENT 'dias de plazo para abonar el servicio'
)COMMENT 'Almacena las distintas condiciones comerciales que puede tener un cliente';

-- TABLA CLIENTES 

CREATE TABLE BALANZA.CLIENTES (
    IDCLIENTE INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador Unico del Cliente',
    IDCONDICION INT NOT NULL COMMENT 'Nombre o Razón social del cliente',
    NOMBRE VARCHAR(100) COMMENT 'Telefono del Cliente',
    TELEFONO VARCHAR(20) COMMENT 'Correo electrónico del cliente',
    CORREO VARCHAR(100) COMMENT 'Hace referencia a la condición comercial del cliente',
    ENVIAWA BOOLEAN DEFAULT 1 COMMENT 'Indica si se envia o no el ticket por mensaje al cliente'
)COMMENT 'Almacena los Datos de los clientes que solicitan el servicio de pesaje';

-- DEFINICION DE FOREIGN KEYS 

-- OPERARIO

ALTER TABLE BALANZA.OPERARIO
    ADD CONSTRAINT FK_EMP_OPERARIO
    FOREIGN KEY (IDEMPRESA) REFERENCES EMPRESA(IDEMPRESA);
    

-- PRODUCTO

ALTER TABLE BALANZA.PRODUCTOS
    ADD CONSTRAINT FK_PRODUCTO_TIPOPRODUCTO
    FOREIGN KEY (IDTIPOPRODUCTO) REFERENCES TIPRODUCTO(IDTIPOPRODUCTO);


-- CLIENTES
ALTER TABLE BALANZA.CLIENTES
    ADD CONSTRAINT FK_CLIENTE_CONDICION
    FOREIGN KEY (IDCONDICION) REFERENCES CONDICION(IDCONDICION);

-- TICKETS

ALTER TABLE TICKETS
    ADD CONSTRAINT FK_TICKETS_OPERARIO
    FOREIGN KEY (IDOPERARIO) REFERENCES OPERARIO(IDOPERARIO);

ALTER TABLE TICKETS
    ADD CONSTRAINT FK_TICKETS_TURNO
    FOREIGN KEY (IDTURNO) REFERENCES TURNOS(IDTURNO);

ALTER TABLE TICKETS
    ADD CONSTRAINT FK_TICKETS_CLIENTES
    FOREIGN KEY (IDCLIENTE) REFERENCES CLIENTES(IDCLIENTE);

ALTER TABLE TICKETS
    ADD CONSTRAINT FK_TICKETS_EMPRESA
    FOREIGN KEY (IDEMPRESA) REFERENCES EMPRESA(IDEMPRESA);

ALTER TABLE TICKETS
    ADD CONSTRAINT FK_TICKETS_PRODUCTO
    FOREIGN KEY (IDPRODUCTO) REFERENCES PRODUCTOS(IDPRODUCTO);
    
  
