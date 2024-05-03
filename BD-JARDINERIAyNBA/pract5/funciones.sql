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

UPDATE clientes
SET LimiteCredito = 5000 
WHERE CodigoCliente = 1;

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
CREATE TRIGGER actualizarStock BEFORE INSERT ON detallepedidos FOR EACH ROW
BEGIN
    DECLARE stock SMALLINT;

    SELECT CantidadEnStock INTO stock
    FROM productos
    WHERE CodigoProducto = NEW.CodigoProducto;

    UPDATE productos
    SET CantidadEnStock = stock - NEW.Cantidad
    WHERE CodigoProducto = NEW.CodigoProducto;
END
$$

INSERT INTO detallepedidos (CodigoPedido, CodigoProducto, Cantidad, PrecioUnidad, NumeroLinea)
VALUES (1, 'AR-001', 5, 10.99, 1);

-- 4
DROP TRIGGER IF EXISTS reponerStock;
DELIMITER $$
CREATE TRIGGER reponerStock BEFORE DELETE ON detallepedidos FOR EACH ROW
BEGIN
	DECLARE stock SMALLINT;

    SELECT CantidadEnStock INTO stock
    FROM productos
    WHERE CodigoProducto = OLD.CodigoProducto;
    
	UPDATE productos
    SET CantidadEnStock = stock + OLD.Cantidad
    WHERE CodigoProducto = OLD.CodigoProducto;
END
$$

DELETE FROM detallepedidos 
WHERE CodigoPedido = 2
AND NumeroLinea = 6;

-- 5
DROP TRIGGER IF EXISTS estadoPedido;
DELIMITER $$
CREATE TRIGGER estadoPedido BEFORE UPDATE ON pedidos FOR EACH ROW
BEGIN
	IF (OLD.Estado = "Pendiente" OR OLD.Estado IS NULL) AND NEW.FechaEntrega > OLD.FechaPedido THEN
		SET NEW.Estado = "entregado";
	END IF;
END
$$

UPDATE pedidos
SET FechaEntrega = '2008-03-18'
WHERE CodigoPedido = 50;

-- 6
DROP TRIGGER IF EXISTS calcularLineasVenta;
DELIMITER $$
CREATE TRIGGER calcularLineasVenta BEFORE INSERT ON lineasventa FOR EACH ROW
BEGIN
	DECLARE precioLV INT;
    
    SELECT PVP INTO precioLV FROM productos
    WHERE CODIGO = NEW.CODPROD;
    
    SET NEW.PRECIO = precioLV;
    SET NEW.IMPORTELINEA = precioLV * NEW.CTD;
END
$$

INSERT INTO lineasventa (NOVENTA, CODPROD, CTD)
VALUES (50, 2, 5);

-- 7
DROP TRIGGER IF EXISTS actualizaImporte;
DELIMITER $$
CREATE TRIGGER actualizaImporte BEFORE INSERT ON ventas FOR EACH ROW
BEGIN
	UPDATE 
    
END
$$





















