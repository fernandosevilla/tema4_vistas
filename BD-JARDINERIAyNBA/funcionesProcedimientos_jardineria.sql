SET GLOBAL log_bin_trust_function_creators=1;
DROP PROCEDURE IF EXISTS CalifIF;
DROP FUNCTION IF EXISTS Calificacion1;
DROP PROCEDURE IF EXISTS VerifCli;
DROP FUNCTION IF EXISTS ExistCli;
DROP FUNCTION IF EXISTS pedido;
DROP FUNCTION IF EXISTS par2;
DROP PROCEDURE IF EXISTS par;
DROP FUNCTION IF EXISTS hola3;
DROP FUNCTION IF EXISTS hola2;
DROP PROCEDURE IF EXISTS hola;

DELIMITER $$
CREATE PROCEDURE hola ()
BEGIN
	DECLARE texto VARCHAR(50);
    SET texto = "Este es mi primer procedimiento";
    
    SELECT texto;
END
$$


DELIMITER $$
CREATE FUNCTION hola2() RETURNS VARCHAR(50)
BEGIN
	DECLARE texto2 VARCHAR(50);
    SET texto2 = "Esta es mi primera funcion en MYSQL";
    
    RETURN texto2;
END
$$

DELIMITER $$
CREATE FUNCTION hola3(texto3 VARCHAR(50)) RETURNS VARCHAR(50)
BEGIN
    RETURN texto3;
END
$$

DELIMITER $$
CREATE PROCEDURE par(numero INT)
BEGIN
	DECLARE texto VARCHAR(50);
	IF numero % 2 = 1 THEN
		SET texto = CONCAT("El numero ", numero, "es impar");
    ELSE
		SET texto = CONCAT("El numero ", numero, "es par");
	END IF;
    SELECT texto;
END
$$

DELIMITER $$
CREATE FUNCTION par2(numero INT) RETURNS VARCHAR(50)
BEGIN
	DECLARE texto VARCHAR(50);
	IF numero % 2 = 1 THEN
		SET texto = CONCAT("El numero ", numero, " es impar");
    ELSE
		SET texto = CONCAT("El numero ", numero, " es par");
	END IF;
    RETURN texto;
END
$$

CALL hola();
SELECT hola2();
SELECT hola3("Imprime esto");
CALL par(5);
SELECT par2(6);

-- ------------------------------------------------------------------
-- PRACTICA 3
-- ------------------------------------------------------------------
-- 3

DELIMITER $$
CREATE FUNCTION pedido() RETURNS INT
BEGIN
	DECLARE id INT;
    SET id = (SELECT CodigoPedido FROM Pedidos
			  ORDER BY CodigoPedido DESC
              LIMIT 1) + 1;
	RETURN id;
END
$$

SELECT pedido();

-- 4
DELIMITER $$
CREATE FUNCTION ExistCli(IdClente INT) RETURNS INT
BEGIN
	DECLARE existe VARCHAR(50);
    
    SET existe = (SELECT CodigoCliente FROM clientes
				  WHERE CodigoCliente = IdClente);
                  
	IF existe != 0 THEN -- si existe da 1
		SET existe = 1;
	ELSE 
		SET existe = 0;
	END IF;
    
	RETURN existe;
END
$$

SELECT ExistCli(600);

-- 5
DELIMITER $$
CREATE PROCEDURE VerifCli ()
BEGIN
	DECLARE id INT;
	DECLARE existe VARCHAR(50);
    DECLARE texto VARCHAR(50);
    
    SET id = 23;
    SET existe = ExistCli(id);
    
    IF existe != 0 THEN
		SET texto = CONCAT("El cliente ", id, " existe");
	ELSE
		SET texto = CONCAT("El cliente ", id, " no existe");
	END IF;
	
	SELECT texto;
END
$$
CALL VerifCli();

-- 6
DELIMITER $$
CREATE FUNCTION Calificacion1 (nota INT) RETURNS VARCHAR(100)
BEGIN
	DECLARE texto VARCHAR(100);
    
    IF nota < 5 THEN
		SET texto = "Lo siento, estás suspenso";
	ELSE 
		SET texto = "Enhorabuena, estás aprobado";
	END IF;
    
    RETURN texto;
END
$$

SELECT Calificacion1(8);

-- 7 
DELIMITER $$
CREATE PROCEDURE CalifIF (nota INT)
BEGIN
	DECLARE texto VARCHAR(100);
    
    IF nota < 5 THEN
		SET texto = CONCAT("SUSPENSO: ", nota);
	ELSEIF nota >= 5 AND nota < 6 THEN
		SET texto = CONCAT("SUFICIENTE: ", nota);
	ELSEIF nota >= 6 AND nota < 7 THEN
		SET texto = CONCAT("BIEN: ", nota);
	ELSEIF nota >= 7 AND nota < 9 THEN
		SET texto = CONCAT("NOTABLE: ", nota);
	ELSEIF nota >= 9 AND nota <= 10 THEN
		SET texto = CONCAT("SOBRESALIENTE: ", nota);
	ELSE 
		SET texto = "Calificacion errónea";
    END IF;
    
    SELECT texto;
END
$$

CALL CALIFIF(9);









