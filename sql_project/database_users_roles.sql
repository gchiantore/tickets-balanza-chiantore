-- Eliminar usuario si existe
DROP USER IF EXISTS 'nlazzero'@'%';
DROP USER IF EXISTS 'gchiantore'@'%';
DROP USER IF EXISTS 'rperez'@'%';

-- Eliminar roles si existen
DROP ROLE IF EXISTS 'admin';
DROP ROLE IF EXISTS 'vendedor';

-- Crear usuarios con sus contraseñas
CREATE USER 'nlazzero'@'%' IDENTIFIED BY '1234';
CREATE USER 'gchiantore'@'%' IDENTIFIED BY '5678';
CREATE USER 'rperez'@'%' IDENTIFIED BY '9012';

-- Crear roles
CREATE ROLE 'admin';
CREATE ROLE 'vendedor';

-- Asignar roles a usuarios
GRANT 'admin' TO 'nlazzero'@'%';
GRANT 'vendedor' TO 'gchiantore'@'%';
GRANT 'vendedor' TO 'rperez'@'%';

-- Otorgar permisos a roles
-- Rol admin tiene acceso total
GRANT ALL PRIVILEGES ON *.* TO 'admin';
-- Rol vendedor solo tiene permisos para leer e insertar datos
GRANT SELECT, INSERT ON BALANZA.* TO 'vendedor';

-- Aplicar cambios
FLUSH PRIVILEGES;