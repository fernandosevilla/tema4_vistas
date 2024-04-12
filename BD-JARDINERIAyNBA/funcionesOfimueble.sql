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












