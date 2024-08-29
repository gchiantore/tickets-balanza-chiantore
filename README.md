# tickets-balanza-chiantore
## BASE DE DATOS DE UNA APP PARA PESAJE DE CAMIONES DE CEREAL


### Problema:

El problema que debemos resolver es el almacenamiento y gestion de los tickets de pesaje de camiones de cereal en una balanza pública que presta el servicio, el sistema con el que cuentan es manual tomando el peso desde un visor electronico que posee la balanza y se lo plasma por triplicado en un soporte de papel. En estos momentos se encuentra en desarrollo una app que va a tomar el peso directamente de la balanza, y va a permitir la cofección del ticket desde una PC o Tablet, lo que se nos pide es que en función de las características que vamos a detallar hagamos el desarrollo de el modelo de datos y la posterior creacion tanto de la base de datos como de las correspondientes tablas. 


### Descripción del Problema:

Antes que nada, decidimos ver la informacion con la que contaban el el ticket para desmenuzar y determinar que datos nos van a hacer falta y ver como se pueden normalizar, Aqui detallamos el ticket sobre el cual vamos a trabajar

```
************************************************;
      O S C A R  C H I A N T O R E   S R L

     Ruta 17 - Km. 176 - La Para - Córdoba
              WS: +549 3575 400209
       e-mail: cporte@oscarchiantore.com.ar

************************************************

         Servicio de Balanza Pública 

************************************************
Ticket Nro.: 12345
Fecha......: 25/06/2024 12:45:26
Operario...: (4) - Gonzalez Juan
Turno .....: (2) - Mañana
================================================
Origen.....: AGRO DON JOSE
Destino....: AGRICULTORES FEDERADOS ARGENTINOS
------------------------------------------------
Producto ..: SOJA
------------------------------------------------
          **** DETALLE DEL PESO ****
------------------------------------------------
BRUTO :  43.250 KG | A | 5 | 25/06/2024 12:45:26
------------------------------------------------
TARA  :  16.450 KG | M | 4 | 25/06/2024 12:45:26
------------------------------------------------
NETO  :  26.800 KG
================================================
DOMINIO CHASIS   : AA325JD
DOMINIO ACOPLADO : AA457GT
CHOFER ..........: PEREZ JUAN
------------------------------------------------
CLIENTE     : AGRO DON JOSE SRL
IMPORTE     : $ 5.000
------------------------------------------------
Observaciones :
TARA PROPORCIONADA POR EL CHOFER, NO SE PESO 
EN LA BALANZA.
------------------------------------------------


```

Como se observa el el ticket hay demaciados datos y no estan normalizados, entonces como primera medida, vamos a desarmar el ticket en partes a los fines de despejar las entidades intervinientes para luego proceder con la normalizacion. 

Una entidad que es clave sería el Ticket, pero seguramente aplicando las distintas formas normales nos vamos a encontrar con que podemos sacar varias entidades para no tener redundancia, la mas clara de todas esta en el encabezado del ticket, y es la empresa con sus datos la cual podriamos convertir en una entidad.

```
************************************************;
      O S C A R  C H I A N T O R E   S R L

     Ruta 17 - Km. 176 - La Para - Córdoba
              WS: +549 3575 400209
       e-mail: cporte@oscarchiantore.com.ar

************************************************
```

En otra parte del ticket aparte de tener el numero de ticket y la fecha, vemos que tambien hay un operario, que es quien confeccionó el ticket y tambien un Turno, ya que la balanza funciona las 24hs y hay tres trunos; por ende aqui podemos extraer 2 entidades mas, Empleado u Operario y Turno

```
************************************************
Ticket Nro.: 12345
Fecha......: 25/06/2024 12:45:26
Operario...: (4) - Gonzalez Juan
Turno .....: (2) - Mañana
================================================

```

Siguiendo con el analisis del ticekt nos encontramos con el ORIGEN y el DESTINO, estos datos pensamos que podrían estar vinculados a alguna entidad tipo cliente, pero en la práctica no funciona asi, en realidad esos valores deben ser libres ya que solo le interesa al cliente que va a pagar el ticket y es de uso personal ya que el movimiento puede ser de un campo a otro del mismo cliente o algun otro procedimietno que no esta a nuestro alcance, por lo tanto lo dejamos así.

```
================================================
Origen.....: AGRO DON JOSE
Destino....: AGRICULTORES FEDERADOS ARGENTINOS
------------------------------------------------

```

Ahora nos encontramos con un dato que si es factible de convertirlo en entidad, y ese dato es el producto, ya que los productos si los conocemos, son escalables, es decir se pueden agregar mas y mas productos. 

```
------------------------------------------------
Producto ..: SOJA
------------------------------------------------

```

Lo que viene ahora es el detalle del peso, estos datos son inherentes solo al Ticket por lo que no hay nada que normalizar aqui, solo hacer algunas alaraciones de los valores que figuran al lado de cada peso, y para hacerlo tenemos que explicar como es el proceso de pesaje y los tiempos, en primer lugar el camion sube a la balanza y se marca el peso Tara o Bruto (dependiendo de si esta vacio o lleno), una vez pesado el camion baja de la balanza y se va al campo, cuando este carga o descarga, vuelve y pesa de nuevo para saber el otro peso, la resta del bruto menos la tara es el peso Neto. Vamos a plantear un ejemplo para que se entienda mejor:

Supongamos que suba un camion vacio a la balanza, aqui el operario abre el ticket y toma el peso, en este caso lo toma como tara, entences aqui tenemos la fecha y la hora de la apertura del ticket y la fecha y la hora de la toma del peso, como lo tomo la balanza ese peso es automatico, al no tener el peso neto porque no sabemos el bruto el ticket queda pendiente, luego el camion baja de la balanza y se va al campo, mas tarde regresa, sube a la balanza, le indica la patente al operador, este busca el ticket que tenga esa patente y toma el peso, como vino cargado toma el bruto, y lo toma automatico porque peso todo en la balanza.

Para el caso del ticket del ejemplo, vemos que un peso es manual y otro automatico, esto se da muchas veces porque el chofer sabe la tara entonces omite el subir a la balanza a pesar y va directo al campo, y vuelve a pesar el bruto, entonces la balanza toma el bruto automatico y el chofer le dice la tara y el ticket se completa. 

```
------------------------------------------------
          **** DETALLE DEL PESO ****
------------------------------------------------
BRUTO :  43.250 KG | A | 5 | 25/06/2024 12:45:26
------------------------------------------------
TARA  :  16.450 KG | M | 4 | 25/06/2024 12:45:26
------------------------------------------------
NETO  :  26.800 KG
================================================

```

Seguimos con la parte de los datos del chofer y el camion, aqui no hace falta tener una entidad porque no siempre vienen los mismos camiones ni el mismo chofer, lo que si la petente o el dominio del chasis es indispensable y no puede ser nulo. 

```
================================================
DOMINIO CHASIS   : AA325JD
DOMINIO ACOPLADO : AA457GT
CHOFER ..........: PEREZ JUAN
------------------------------------------------

```

Como para ir terminando aqui van los datos del cliente, el que solicito el servicio, y aqui si vemos la necesidad de tener una entidad cliente, pero sucede que la empesa le tiene diferentes condiciones de pago y precio por cada cliente, por lo que aparte de la entidad cliente deberia haber una entidad que sean condiciones. 

```
------------------------------------------------
CLIENTE     : AGRO DON JOSE SRL
IMPORTE     : $ 5.000
------------------------------------------------
```

Por ultimo tenemos la Observacion que es un dato inherente al ticket y no es necesario que se le asigne entidad ya que es solo un campo de texto.

Despejando podemos concluir que del analisis antes expuesto surgen las siguientes entidades :

1. **TICKETS**
2. **EMPRESA**
3. **OPERARIO**
4. **TURNO**
5. **PRODUCTO**
6. **CLIENTE**
7. **CONDICION**


**Registro de Tickets**: Necesitamos un sistema que pueda registrar de manera completa cada ticket, junto con sus referencias a las distintas entidades propuestas.

### Objetivo:

Diseñar e implementar una base de datos relacional que satisfaga todas las necesidades de gestión de tickets de pesaje de la app en desarrollo. Esta base de datos deberá ser eficiente, escalable y fácil de mantener, permitiendo una gestión ágil y precisa de todas las operaciones relacionadas con los tickets de pesaje.


## Descripción de la Base de Datos - Tickets de Pesaje

Esta base de datos se diseñó para gestionar ticket de pesajes de una balanza publica mediante una app, como asi tambien la gestion de las tabla de tickets y las resultanmtes de la normalizacion como clientes, productos, empresa, etc. 

A continuacion se van a enumerar dichas tablas :


### Tablas:

1. `CLIENTE`
   - Almacena información sobre los clientes quienes mandan a pesar los camiones.
   - Atributos: IDCLIENTE, NOMBRE, TELEFONO, CORREO, CONDICION, ENVIAWS.

2. `OPERARIO`
   - Contiene información sobre los operarios involucrados en el proceso de confeccion del ticket.
   - Atributos: IDEMPLEADO, NOMBRE, TELEFONO, CORREO, IDEMPRESA.

3. `EMPRESA`
   - Guarda datos sobre la Empresa que proporciona el servicio.
   - Atributos: IDEMPRESA, RSOCIAL, DIRECCION, LOCALIDAD, TELEFONO, CORREO.

4. `PRODUCTO`
   - Define los productos que estan habilitados para pesarse
   - Atributos: IDPRODUCTO, DESCRIPCION, TIPO.

5. `CONDICION`
   - Almacena información sobre las condiciones de plazo y pago para disponibles.
   - Atributos: IDCONDICION, DESCRIPCION, PRECIO, DPLAZO.

6. `TURNO`
   - Contiene información sobre los nombres de los turnos.
   - Atributos: IDTURNO, DESCRIPCION.

7. `TICKET`
   - Registra los tickets que se generan por los operarios y solicitados por los clientes.
   - Atributos: IDTICKET, IDOPERARIO, IDCLIENTE, IDTURNO, IDEMPRESA, IDPRODUCTO, FECHA, ORIGEN, DESTINO, BRUTOPESO, BRUTOMODO, BRUTOOPERARIO, BRUTOFECHA, TARAPESO,                     TARAMODO, TARAOPERARIO, TARAFECHA, NETO, CHASIS, ACOPLADO, CHOFER, IMPORTE, OBS.


### DIAGRAMA DE ENTIDAD RELACION :


#### DER SIMPLIFICADO

![alt text][ders]

[ders]: https://github.com/gchiantore/tickets-balanza-chiantore/blob/main/assets/DER%20SIMPLE.png

#### DER 

![alt text][der]

[der]: https://github.com/gchiantore/tickets-balanza-chiantore/blob/main/assets/DER.png

### DESCRIPCION DE TABLAS Y ATRIBUTOS 

#### TABLA CLIENTES

Almacena los Datos de los clientes que solicitan el servicio de pesaje

| PK/FK | Atributo    | TIPO    | Tamaño | NULIDAD  | AUTOINC. | DEFAULT | DESCRIPCION                                                  |
|-------|-------------|---------|--------|----------|----------|---------|--------------------------------------------------------------|
| PK    | idcliente   | int     |        | not null | SI       |         | Identificador Unico del Cliente                              |
|       | nombre      | varchar | 100    | not null | NO       | NO NAME | Nombre o Razón social del cliente                            |
|       | telefono    | varchar | 20     |          | NO       | S/D     | Telefono del Cliente                                         |
|       | correo      | varchar | 100    | not null | NO       |         | Correo electrónico del cliente                               |
| FK    | idcondicion | int     |        | not null | NO       |         | Hace referencia a la condición comercial del cliente         |
|       | enviawa     | boolean | 1      | not null | NO       | True    | Indica si se envia o no el ticket por mensaje al cliente     |

------

#### TABLA CONDICION 
Almacena las distintas condiciones comerciales que puede tener un cliente

| PK/FK | Atributo    | TIPO    | Tamaño | NULIDAD  | AUTOINC. | DEFAULT | DESCRIPCION                                                  |
|-------|-------------|---------|--------|----------|----------|---------|--------------------------------------------------------------|
| PK    | idcondicion | int     |        | not null | SI       |         | Identificador Unico la condicion                             |
|       | descripcion | varchar | 100    | not null | NO       | NO COND | Descripcion de la condicion comercial                        |
|       | precio      | deciaml | 10,2   | not null | NO       | 5000,00 | precio del servicio de acuerdo a esa condicion               |
|       | dplazo      | varchar | int    | not null | NO       | 0       | dias de plazo para abonar el servicio                        |


------

#### TABLA PRODUCTO
Almacena los productos que se van a pesar

| PK/FK | Atributo       | TIPO    | Tamaño | NULIDAD  | AUTOINC. | DEFAULT | DESCRIPCION                                               |
|-------|----------------|---------|--------|----------|----------|---------|-----------------------------------------------------------|
| PK    | idproducto     | int     |        | not null | SI       |         | Identificador Unico del producto                          |
|       | descripcion    | varchar | 100    | not null | NO       | S /DESC | Descripción del producto                                  |
| FK    | idtipoproducto | int     |        | not null | NO       |         | Hace referencia al tipo o categoría de producto           |
|       | icono          | varchar | 100    |          | NO       |         | Apunta al archivo con la imagen del icono del producto    |

------

#### TABLA TIPRODUCTO
Almacena el tipo de producto que se va a pesar 

| PK/FK | Atributo       | TIPO    | Tamaño | NULIDAD  | AUTOINC. | DEFAULT | DESCRIPCION                                                               |
|-------|----------------|---------|--------|----------|----------|---------|---------------------------------------------------------------------------|
| PK    | idtipoproducto | int     |        | not null | SI       |         | Identificador Unico del producto                                          |
|       | descripcion    | varchar | 100    | not null | NO       | S /DESC | Descripción del producto                                                  |
|       | color          | varchar | 6      |          | NO       | 000000  | Especifica el color en Hexadecimal que identifica al tipo de producto.    |
|       | icono          | varchar | 100    |          | NO       |         | Apunta al archivo con la imagen del icono del tipo de pruducto            |

------

#### TABLA EMPRESA
Almacena los datos de la empresa que brinda el servicio de pesada

| PK/FK | Atributo  | TIPO    | Tamaño | NULIDAD  | AUTOINC. | DEFAULT | DESCRIPCION                             |
|-------|-----------|---------|--------|----------|----------|---------|-----------------------------------------|
| PK    | idempresa | int     |        | not null | SI       |         | Identificador Unico de la empresa       |
|       | rsocial   | varchar | 100    | not null | NO       | NO/RS   | Nombre o razón social de la empresa     |
|       | domicilio | varchar | 200    |          | NO       | N/D     | Domicilio legal de la empresa           |
|       | localidad | varchar | 100    |          | NO       | N/L     | Localidad donde esta situada la empresa |
|       | telefono  | varchar | 20     |          | NO       |         | Telefono de la empresa                  |
|       | correo    | varchar | 100    |          | NO       |         | e-mail de la empresa                    |

------

#### TABLA OPERARIO
Almacena los datos de los operadores de la balanza que brindan el servicio

| PK/FK | Atributo   | TIPO    | Tamaño | NULIDAD  | AUTOINC. | DEFAULT | DESCRIPCION                                                 |
|-------|------------|---------|--------|----------|----------|---------|-------------------------------------------------------------|
| PK    | idoperario | int     |        | not null | SI       |         | Identificador Unico del operario                            |
|       | nombre     | varchar | 100    | not null | NO       | NONAME  | Nombre o razón social de la empresa                         |
|       | telefono   | varchar | 20     |          | NO       |         | Telefono del operario                                       |
|       | correo     | varchar | 100    |          | NO       |         | e-mail del operario                                         |
| FK    | idempresa  | int     |        | not null | NO       |         | Hace referencia a la empresa a la que pertenece el operario |

------

#### TABLA TURNO 
Almacena la informacion de los dostintos turnos de pesaje

| PK/FK | Atributo | TIPO    | Tamaño | NULIDAD  | AUTOINC. | DEFAULT | DESCRIPCION                                                  |
|-------|----------|---------|--------|----------|----------|---------|--------------------------------------------------------------|
| PK    | idturno  | int     |        | not null | SI       |         | Identificador Unico del truno                                |
|       | nombre   | varchar | 100    | not null | NO       | NONAME  | Nombre del Turno                                             |
|       | color    | varchar | 6      |          | NO       |         | Color en Hexadecimal con el que se va a identificar el turno |
|       | icono    | varchar | 200    |          | NO       |         | Archivo del icono que representa al turno                    |

------

#### TABLA TICKET
Almacena la informacion de tickets de pesaje

| PK/FK | Atributo      | TIPO      | Tamaño | NULIDAD  | AUTOINC. | DEFAULT     | DESCRIPCION                                                            |
|-------|---------------|-----------|--------|----------|----------|-------------|------------------------------------------------------------------------|
| PK    | idticket      | int       |        | not null | SI       |             | Identificador unico del ticket                                         |
| FK    | idoperario    | int       |        | not null | NO       |             | Identificador del operario que abrió el ticket                         |
| FK    | idturno       | int       |        | not null | NO       |             | Identificación del turno en el que se abrió el ticket                  |
| FK    | idcliente     | int       |        | not null | NO       |             | Identificación del cliente al que le hicieron el ticket                |
| FK    | idempresa     | int       |        | not null | NO       |             | Identificacion de la empresa prestadora de servicio                    |
| FK    | idproducto    | int       |        | not null | NO       |             | Identificación del producto pesado                                     |
|       | fecha         | date/time |        | not null | NO       | curren date | Fecha de creación del ticket                                           |
|       | origen        | varchar   | 40     | not null | NO       |             | Origen del producto transportado                                       |
|       | destino       | carchar   | 40     | not null | NO       |             | Destino del Producto Transportado                                      |
|       | brutopeso     | int       |        |          | NO       |             | Peso Bruto                                                             |
|       | brutomodo     | varchar   | 1      |          | NO       |             | Modo de toma del peso Bruto (Manual o Automático)                      |
|       | brutooperario | int       |        |          | NO       |             | Identificación del operario que tomo el peso bruto                     |
|       | brutofecha    | date/time |        |          | NO       |             | fecha y hora en que se tomo el peso bruto                              |
|       | tarapeso      | int       |        |          | NO       |             | Peso Tara                                                              |
|       | taramodo      | carchar   | 1      |          | NO       |             | Modo de toma del peso Tara (Manual o Automático)                       |
|       | taraoperario  | int       |        |          | NO       |             | Identificación del operario que tomo el peso tara                      |
|       | tarafecha     | date/time |        |          | NO       |             | fecha y hora en que se tomo el peso tara                               |
|       | neto          | int       |        |          | NO       |             | Peso Neto                                                              |
|       | chasis        | varchar   | 7      | not null | NO       |             | Patente o Dominio del chasis del transporte                            |
|       | acoplado      | varchar   | 7      |          | NO       |             | Patente o Dominio del acoplado, puede ser nulo                         |
|       | chofer        | varchar   | 40     |          | NO       | S/DATO      | Nombre del Chofer                                                      |
|       | importe       | decimal   | 10,2   |          | NO       |             | Importe del ticket, este depende de la condición comercial del cliente |
|       | pendiente     | boolean   |        | not null | NO       | true        | Si el ticket le falta algún peso queda pendiente                       |
|       | obs           | varchar   | 200    |          | NO       |             | Lugar para escribir alguna observación                                 |


En el archivo ```sql_project/database_structure.sql``` se encuentra los comandos DDL para la creacion de las tablas y las relaciones entre ellas, en el archivo ```sql_project/populaton.sql``` se encuentran los comandos necesarios para haceer la ingesta de prueba de los datos, algunos estan detallados en los mismos comandos y otra provienen de archivos .CSV que se encuentran en la carpeta ```data_csv```.

En la carpeta ```sql_project/database_objects``` estan las funciones, los procedimientos almacenados, los triggers y las vistas de la base de datos, los archivos que contienen los comandos sql para su creacion son los siguientes ```funciones.sql, stored_procedures.sql, triggers-sql, vistas.sql```, a continuacion voy a detallar cada uno de estos objetos y la forma en la que se utilizan, no sin antes mensionar las maneras de replacar esta basese de datos junto con sus datos y sus objetos a los fines de que luego puedas probar con los ejemplos de cada uno de los objetos abajo detallados.

### REPLICAR LA BASE DE DATOS

Hay dos maneras de replicar la base de datos, en forma local, o sea en tu computadora, o bien desde aqui mismo de github usando codespaces.

#### REPLICAR LA BASE DE DATOS DE MANERA LOCAL 

Para esto es necesario primero que tengas acceso al motor de una base de datos MySQL ya sea en tu propio equipo o bien que tengas acceso a un servidor con un usuario con los debidos permisos, es decir con un usuario que pueda crear, eliminar y modificar tanto una base de datos como las tablas, datos y objetos que la misma tenga, dicho esto los paso son los siguientes :

*  Descargar todos los archicvos del proyecto y descomprimir en una carpeta en el disco de tu computadora, ingresar a mysql desde la consola y ejecutar los archicos .sql en el siguiente orden :
  
   1 database_structure.sql
   2 population.sql
   3 database_objects/funciones.sql
   4 database_objects/stored_procedures.sql
   5 database_objects/triggers.sql
   6 database_objects/vistas.sql

una vez ejecutado estos scrips, y si ninguno dio error ya estariamos en condiciones de poder probrar los ejemplo de los objetos de la base de datos que estan descriptos mas abajo. 

Si no quisieramos usar la linea de comando pordriamos hacer lo mismo y en el mismo orden desde algun software como DBeaver o MySql Workbench, a los fines de tener una interfaz grafica y mas intuitiva. 

#### REPLICAR LA BASE DE DATOS CON CODESPACES

Aqui es muy simple, en lugar de quedarnos en la solapa Local que es la que nos permitia descargar el repositorio, hacemos clic al lado, en la solapa CODESPACES, luego hacemos click en el signo + para agregar un codespace, y esperamos que se carga, va a aparecer una intefaz similar a la de visual studio code, y nos va a habilirar una terminal, ahi simplemente escribimos la palabra ``` make ``` y le damos enter, automaticamente va a levantar una base de datos en un contenedor y va a ejecutar los script en el orden correcto, luego nos va a dar acceso otra vez a la linea de comandos, aqui podemos verificar con el comando ```make test-db ``` si todas las tablas y los datos estan correctos, tambien con el comando ``` make access-db ``` podemos ingresar a MySql y comenzar a probar todo desde la linea de comando, tambien es posible crear un tunel con Visual Studio Code y esto se ejecutaria en un contenedor como si estuviera en la computadora local, y ahi una vez que todo esta esjecutado simplemente abrimos DBeaver o Workbench y nos conectamos como el localhost. 

   


### Objetos de la Base de datos

#### FUNCIONES

##### * Funcion CONTAR_TICKET_PENDIENTES_CLIENTE

Esta funcion devuelve un entero que es la cantidad de tickets que tiene pendientes en un determinado rango de fechas un determinado cliente.

Parametros: cliente, fecha_desde, fecha_hasta 
Tablas : TICKETS, CLIENTES 

Ejemplo :

```
SELECT CONTAR_TICKET_PENDIENTES_CLIENTE(3,'2024-01-05','2024-07-14');
```

##### * Funcion CALCULAR_PRECIO_TICKET

Esta funcion devuelve un decimal que es el precio del ticket de pesaje de acuerdo a la condicion comercial del cliente al que se le realizo el ticket

Parametros: cliente
Tablas : TICKETS, CLIENTES, CONDICION 

Ejemplo :

```
SELECT CALCULAR_PRECIO_TICKET(3);
```

##### * Funcion CALCULAR_PESO_NETO

Esta funcion devuelve un entero que es el resultado de la diferencia entre el peso bruto y la tara, si uno de estos es 0, la funcion devuelve 0

Parametros: ticketID
Tablas : TICKETS

Ejemplo :

```
SELECT CALCULAR_PESO_NETO(18);
```

##### * Funcion DETERMINAR_ESTADO

Esta funcion devuelve un booleano, que indica si esl ticket esta pendiente, es decir que todavia falta uno de los pesos, o no, es decir que ya se han completado tanto la tara como el bruto 

Parametros: ticketID
Tablas : TICKETS

Ejemplo :

```
SELECT DETERMINAR_ESTADO(18);
```


#### PROCEDIMIENTOS ALMACENADOS

##### CREA_OPERARIO

Este procedimiento permite la inserción de un operario en una empresa, si la empresa no existe va a dar un error y no se va a agregar el operario 

Parametros : nombre (varchar), telefono(varchar),correo(varchar),empresa(int)
Tablas : OPERARIOS, EMPRESA

Agiliza la insercion de un operario y no permite hacerlo si la empresa no existe, manteniando asi la integridad de la base de datos 

Elemplo
```
-- Agregar un Operario

CALL CREA_OPERARIO('GONZALEZ, JUAN CRUZ','974-604-9127','jcgonzales@pepito.com',1);

```

##### ELIMINAR OPERARIO
Este procedimiento permite la eliminacion de un operario, aun si esta ha realizado tickets, en caso de que los haya realizado, guarda los datos del operario, numero de ticket norme de operario y fecha de eliminacion en la tabla de TICKETS_OPERARIOS_ELIMINADOS, y actualiza el valor de IDOPERARIO en la tabla TICKETS con 0.

Parámetros : IDOPERARIO (INT)
Tablas : OPERARIOS, TICKETS, TICKETS_OPERARIOS_ELIMINADOS

Elemplo
```
-- Eliminar un Operario

CALL ELIMINAR_OPERARIO(12);

```

##### CREA_PRODUCTO

Este procedimiento permite la inserción de un producto y la asignacion del mismo a un tipo de producto determinado, si el tipo de producto no existe, entonces da un error y por consiguiente el producto no se inserta en la tabal 

Parametros : nombre (varchar), tipo de producto (int),icono(varchar)
Tablas : PRODUCTOS, TIPRODUCTOS

Agiliza la insercion de los productos a la base de datos, verificando que vayan a un tipo especifico y existente de produtos, si no es asi no los deja ingresar 

Elemplo
```
-- Agregar un producto 

CALL CREA_PRODUCTO('OTROS',5,'/img/iconos/maiz.png');
```

#### TRIGGERS

Hay dos triggers que se ejecutan antes de insertar un registro y antes de modificar un resgistro de la tabla tickets, esos triggers se encargan de calcular el peso neto, determinar el importe del ticket y establecer el estado del mismo. aqui hay un codigo de ejemplo para poder testear el comportamiento del trigger

Estos triggers nos permiten automatizar el proceso, y hacer calculos espefificos de manera automatica como lo es el Neto, asi mismo tambien se encargan de asignar el importe del ticket buscandolo en la condicion que tiene el cliente, y determinan si los pesos se han completado o no para poner el ticket como pendiente o completado.

```
-- INSERTAR REGISTRO EN LA TABLA TICKETS

INSERT INTO TICKETS (IDOPERARIO, IDTURNO, IDCLIENTE, IDEMPRESA, IDPRODUCTO, FECHA, ORIGEN, DESTINO, BRUTOPESO, BRUTOMODO, BRUTOOPERARIO, BRUTOFECHA, TARAPESO, TARAMODO, TARAOPERARIO, TARAFECHA, CHASIS, ACOPLADO, CHOFER, IMPORTE, PENDIENTE, OBSERVACIONES)
VALUES (1, 1, 1, 1, 1, NOW(), 'Origen1', 'Destino1', 50000, 'A', 1, NOW(), 10000, 'A', 1, NOW(), 'XX NNN XX', 'XX NNN XX', 'Chofer1', 0, 0, '');

-- Aqui muestra el ultimo registro insertado 
SELECT * FROM TICKETS
ORDER BY IDTICKET DESC
LIMIT 1;

-- ACTUALIZAR EL ULTIMO TICKET Y REVISAR ESA ACTUALIZACION
UPDATE TICKETS
JOIN (SELECT IDTICKET FROM TICKETS ORDER BY IDTICKET DESC LIMIT 1) AS AUXILIAR
ON TICKETS.IDTICKET = AUXILIAR.IDTICKET
SET TICKETS.BRUTOPESO = 45000, TICKETS.TARAPESO = 15000;


SELECT * FROM TICKETS
ORDER BY IDTICKET DESC
LIMIT 1

-- TAMBIEN SE PUEDE ACTUALIZAR UN TICKET CUALQUIERA 
UPDATE TICKETS
SET BRUTOPESO = 55000, TARAPESO = 12000
WHERE IDTICKET = --Aqui iria el nombre del registro;
```

#### VISTAS

##### * VISTA CANTIDAD_TICKETS_POR_TURNOS

TABLAS QUE COMPONEN LA VISTA 

* TICKETS
* TURNOS
  

CANTIDAD DE TICKETS POR FECHA Y TURNO
ESTA VISTA ME LISTA LA CANTIDAD DE TICKETS REALIZADAS EN LOS DISTINTIOS TURNOS DE LA UNA FECHA DETERMINADA O DE LA TOTALIDAD DE LAS TABLA 

EJEMPLO 

```
select * from TICKETS_POR_TURNOS where FECHA='2024-01-15';
```

##### * VISTA TICKETS_POR_TURNOS

TABLAS QUE COMPONEN LA VISTA

* TICKETS
* TURNOS
* CLIENTES

TICKETS POR TURNOS
AQUI VOY A TENER UN LISTADO DETALLADO DE LOS TICKETS QUE SE HICIERON EL EL TURNO Y A QUIENES SE LE HICIERON 

```
select * from CANTIDAD_TICKETS_POR_TURNOS where fecha='2024-01-15';
```

##### * VISTA TIPODEPRODUCTOS_PRODUCTOS

TABLAS QUE COMPONEN LA VISTA

* PRODUCTOS
* TIPRODUCTOS

PRODUCTOS POR TIPO
MUESTRA LOS TIPOS DE PRODUCTOS CON SUS RESPECIVOS PRODUCTOS 

```
select * from TIPODEPRODUCTOS_PRODUCTOS;
```

##### * VISTA OPERARIOS_EMPRESAS

MUESTRA LOS OPERARIOS CON SUS RESPECTIVAS EMPRESAS
TABLAS QUE COMPONEN LA VISTA

* OPERARIOS
* EMPRESA

```
select * from OPERARIOS_EMPRESAS;
```

##### * VISTA CLIENTE_CONDICIONES

MUESTRA LOS CLIENTES CON SUS RESPECTIVAS CONDICIONES COMERCIALES
TABLAS QUE COMPONEN LA VISTA

* CLIENTES 
* CONDICION

```
select * from CLIENTES_CONDICIONES;
```
##### * VISTA TICKETS_PENDIENTES

MUESTRA LOS TICKETS CON ESTADO DE PENDIENTE
TABLAS QUE COMPONEN LA VISTA

* TICKETS

```
select * from TICKETS_PENDIENTES where fecha='2024-01-15';
```


