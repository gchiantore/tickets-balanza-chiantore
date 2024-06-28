# tickets-balanza-chiantore
## BASE DE UNA APP PARA PESAJE DE CAMIONES DE CEREAL


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
