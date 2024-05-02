SET GLOBAL log_bin_trust_function_creators=1;

-- 1
DROP TRIGGER IF EXISTS asignacion;
DELIMITER $$
CREATE TRIGGER asignacion BEFORE UPDATE ON clientes FOR EACH ROW
BEGIN
	DECLARE limite DECIMAL DEFAULT 0;
	DECLARE estado VARCHAR(100) DEFAULT "";
    
    SET limite = NEW.LimiteCredito;
    
    IF limite < 5000 THEN
		SET estado = "Malo";
	ELSEIF limite < 10000 THEN
		SET estado = "Normal";
	ELSEIF limite < 50000 THEN
		SET estado = "Bueno";
	ELSEIF limite >= 50000 THEN
		SET estado = "VIP";
    END IF;
    
    SET NEW.ESTATUS = estado;
END
$$

UPDATE clientes SET LimiteCredito = 5000 WHERE CodigoCliente = 1;

-- 2
DROP TRIGGER IF EXISTS asignacion2;
DELIMITER $$
CREATE TRIGGER asignacion2 BEFORE INSERT ON clientes FOR EACH ROW
BEGIN
	SET NEW.LimiteCredito = 7000;
    SET NEW.ESTATUS = "Normal";
END
$$

INSERT INTO clientes (CodigoCliente, NombreCliente, NombreContacto, ApellidoContacto, Telefono, Fax, LineaDireccion1, LineaDireccion2, Ciudad, Region, Pais, CodigoPostal, CodigoEmpleadoRepVentas) 
VALUES
(40, 'Nuevo Cliente', 'Contacto', 'Apellido', '123456789', '987654321', 'Dirección 1', 'Dirección 2', 'Ciudad', 'Región', 'País', '12345', 1);

-- 3
DROP TRIGGER IF EXISTS actualizarStock;
DELIMITER $$
CREATE TRIGGER actualizarStock BEFORE INSERT ON pedidos FOR EACH ROW
BEGIN
	DECLARE stock SMALLINT;
    
    
    
    
END
$$




























