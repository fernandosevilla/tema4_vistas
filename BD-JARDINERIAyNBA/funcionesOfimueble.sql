SET GLOBAL log_bin_trust_function_creators=1;

-- 1
DROP FUNCTION IF EXISTS ProductoDist;
DELIMITER $$
CREATE FUNCTION ProductoDist() RETURNS INT
BEGIN
	DECLARE numProductos INT;
    
    SET numProductos = (SELECT COUNT(DISTINCT descripcion) FROM productos);

	RETURN numProductos;
END
$$

SELECT ProductoDist();

-- 2
DROP PROCEDURE IF EXISTS PobDistintas;
DELIMITER $$
CREATE PROCEDURE PobDistintas()
BEGIN
	DECLARE numPoblaciones INT;
    
    SET numPoblaciones = (SELECT COUNT(DISTINCT poblacion) FROM poblaciones);
    
    SELECT numPoblaciones;
END
$$

CALL PobDistintas();

-- 3
DROP FUNCTION IF EXISTS ventas;
DELIMITER $$
CREATE FUNCTION ventas() RETURNS INT
BEGIN
	DECLARE numVentas INT;
    
    SET numVentas = (SELECT COUNT(noventa) FROM ventas) + 1;
    
    RETURN numVentas;
END
$$

SELECT ventas();

-- 4
DROP PROCEDURE IF EXISTS zonaCliente;
DELIMITER $$
CREATE PROCEDURE zonaCliente(codigoCliente INT)
BEGIN
	DECLARE codAux INT;
    DECLARE nombrePersona VARCHAR(100);
    DECLARE zona VARCHAR(100);
    DECLARE resultado VARCHAR(250);
    
    SET codAux = codigoCliente;
    SET nombrePersona = (SELECT nombre FROM clientes
						WHERE CODIGO = codAux);
    SET zona = (SELECT z.nombre FROM zonas z
				INNER JOIN provincias prov ON prov.CODZONA = z.CODIGO
                INNER JOIN poblaciones plob ON plob.PROVINCIA = prov.PROVINCIA
                INNER JOIN oficinas o ON o.POBLACION = plob.POBLACION
                INNER JOIN clientes cli ON cli.CODOFIC = o.CODIGO
                WHERE cli.CODIGO = codAux);
                
    SET resultado = CONCAT("El cliente numero ", codAux, " ", nombrePersona, " pertenece a la zona de ", zona);
    
    SELECT resultado;
END
$$

CALL zonaCliente(2);

-- 5
DROP FUNCTION IF EXISTS datosProducto;
DELIMITER $$
CREATE FUNCTION datosProducto(codProducto INT) RETURNS VARCHAR(200)
BEGIN
    DECLARE codAux INT;
    DECLARE descProd VARCHAR(100);
    DECLARE cantidadVendida INT;
    DECLARE precioUnidad INT;
    DECLARE importeTotal INT;
    DECLARE resultado VARCHAR(200);

    SET codAux = codProducto;

    -- Obtener la descripción del producto
    SET descProd = (SELECT descripcion FROM productos WHERE codigo = codAux);

    -- Obtener la cantidad vendida sumando el campo noventa de lineasventa
    SELECT SUM(LV.ctd) INTO cantidadVendida
    FROM lineasventa lv
    WHERE lv.codprod = codAux;

    -- Obtener el precio por unidad del producto
    SET precioUnidad = (SELECT PVP FROM productos WHERE codigo = codAux);

    -- Calcular el importe total
    SET importeTotal = cantidadVendida * precioUnidad;

    -- Construir el resultado
    SET resultado = CONCAT("PRODUCTO: ", codAux, " ", descProd, " CANTIDADVENDIDA: ",
					cantidadVendida, " PVP_UNIDAD: ", precioUnidad,
                    " IMPORTE: ", importeTotal, "€");

    RETURN resultado;
END
$$

SELECT datosProducto(3);

-- 6
DROP FUNCTION IF EXISTS StockXGama;
DELIMITER $$
CREATE FUNCTION StockXGama(nombre VARCHAR(200)) RETURNS VARCHAR(100) READS SQL DATA
BEGIN
	DECLARE resultado VARCHAR(100);
    DECLARE stock INT;
    
    SELECT SUM(EXISTENCIAS) INTO stock
		FROM productos
        WHERE descripcion = nombre;
    
	SET resultado = CONCAT(nombre, ": ", stock);
    
    RETURN resultado;
END
$$

SELECT StockXGama("MESA");

-- 7
DROP PROCEDURE IF EXISTS importeVentas;
DELIMITER $$
CREATE PROCEDURE importeVentas()
BEGIN
	
END
$$

























