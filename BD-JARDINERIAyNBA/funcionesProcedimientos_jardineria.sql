SET GLOBAL log_bin_trust_function_creators=1;

-- ------------------------------------------------------------------
-- PRACTICA 3
-- ------------------------------------------------------------------

-- 1
DROP PROCEDURE IF EXISTS hola;
DELIMITER $$
CREATE PROCEDURE hola ()
BEGIN
	DECLARE texto VARCHAR(50);
    SET texto = "Este es mi primer procedimiento";
    
    SELECT texto;
END
$$
CALL hola();

-- 2
DROP FUNCTION IF EXISTS hola2;
DELIMITER $$
CREATE FUNCTION hola2() RETURNS VARCHAR(50)
BEGIN
	DECLARE texto2 VARCHAR(50);
    SET texto2 = "Esta es mi primera funcion en MYSQL";
    
    RETURN texto2;
END
$$
SELECT hola2();

-- 3
DROP FUNCTION IF EXISTS hola3;
DELIMITER $$
CREATE FUNCTION hola3(texto3 VARCHAR(50)) RETURNS VARCHAR(50)
BEGIN
    RETURN texto3;
END
$$
SELECT hola3("Imprime esto");

-- 4
DROP PROCEDURE IF EXISTS par;
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
CALL par(5);

-- 5
DROP FUNCTION IF EXISTS par2;
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
SELECT par2(6);

-- 6
DROP PROCEDURE IF EXISTS CuentaLetras;
DELIMITER $$
CREATE PROCEDURE CuentaLetras(texto VARCHAR(50))
BEGIN
	DECLARE contador VARCHAR(100);
    SET contador = length(texto);
    
    SELECT contador;
END
$$
CALL CuentaLetras("asdkfnajsdkfjasdfasdjñfa asdl kasdjf askf asd");

-- 7
DROP FUNCTION IF EXISTS CuentaDigitos;
DELIMITER $$
CREATE FUNCTION CuentaDigitos(numero INT) RETURNS VARCHAR(50)
BEGIN
	DECLARE contador VARCHAR(100);
    SET contador = length(numero);
    
	RETURN contador;
END
$$
SELECT CuentaDigitos(2222);

-- ------------------------------------------------------------------
-- PRACTICA 3
-- ------------------------------------------------------------------
-- 3
DROP FUNCTION IF EXISTS pedido;
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
DROP FUNCTION IF EXISTS ExistCli;
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
DROP PROCEDURE IF EXISTS VerifCli;
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
DROP FUNCTION IF EXISTS Calificacion1;
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
DROP PROCEDURE IF EXISTS CalifIF;
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

-- 8
DROP FUNCTION IF EXISTS Suma100;
DELIMITER $$
CREATE FUNCTION Suma100() RETURNS INT
BEGIN
	DECLARE numero INT DEFAULT 0;
    DECLARE contador INT DEFAULT 1;
	bucle: LOOP
		SET numero = numero + contador;
		SET contador = contador + 1;
        
        IF contador <= 100 THEN
			ITERATE bucle;
		END IF;
        LEAVE bucle;
    END LOOP bucle;
    
    RETURN numero;
END
$$

SELECT Suma100();

-- 9
DROP PROCEDURE IF EXISTS SumaX;
DELIMITER $$
CREATE PROCEDURE SumaX(numero INT)
BEGIN
	DECLARE aux INT DEFAULT 0;
    DECLARE contador INT DEFAULT 0;
    
    bucle: WHILE contador <= numero DO
		SET aux = aux + contador;
		SET contador = contador + 1;
    END WHILE;
    
    SELECT aux;
END
$$

CALL SumaX(100);

-- 10
DROP PROCEDURE IF EXISTS Factorial;
DELIMITER $$
CREATE PROCEDURE Factorial(numero INT)
BEGIN
	DECLARE aux INT DEFAULT 1;
    DECLARE contador INT DEFAULT 1;
    
    REPEAT 
		SET aux = aux * contador;
		SET contador = contador + 1;
    UNTIL contador >= numero
    END REPEAT;
    
    SELECT aux;
END
$$

CALL Factorial(5);

-- 11
DROP PROCEDURE IF EXISTS Quiniela;
DELIMITER $$
CREATE PROCEDURE Quiniela()
BEGIN
	DECLARE numRandom INT;
	DECLARE numRandomConvertido CHAR(1);
    DECLARE contador INT DEFAULT 0;
    DECLARE resultado VARCHAR(255);
    
    SET resultado = "Resultado: ";
    
    WHILE contador < 14 DO
		SET numRandom = TRUNCATE(RAND() * 3, 0);
		SET numRandomConvertido = CONVERT(numRandom, CHAR);
		
		IF numRandomConvertido = "1" THEN
			SET numRandomConvertido = "1";
		ELSEIF numRandomConvertido = "2" THEN
			SET numRandomConvertido = "2";
		ELSE
			SET numRandomConvertido = "X";
		END IF;
		
		SET resultado = CONCAT(resultado, numRandomConvertido, " ");
		SET contador = contador + 1;
    END WHILE;
    
    SELECT resultado;
END
$$

CALL Quiniela();

-- 12
DROP FUNCTION IF EXISTS QuinielaF;
DELIMITER $$
CREATE FUNCTION QuinielaF() RETURNS VARCHAR(100)
BEGIN
	DECLARE numRandom INT;
	DECLARE numRandomConvertido CHAR(1);
    DECLARE contador INT DEFAULT 0;
    DECLARE resultado VARCHAR(255);
    
    SET resultado = "Resultado: ";
    
    WHILE contador < 14 DO
		SET numRandom = TRUNCATE(RAND() * 3, 0);
		SET numRandomConvertido = CONVERT(numRandom, CHAR);
		
		IF numRandomConvertido = "1" THEN
			SET numRandomConvertido = "1";
		ELSEIF numRandomConvertido = "2" THEN
			SET numRandomConvertido = "2";
		ELSE
			SET numRandomConvertido = "X";
		END IF;
		
		SET resultado = CONCAT(resultado, numRandomConvertido, " ");
		SET contador = contador + 1;
    END WHILE;
    
    RETURN resultado;
END
$$

SELECT QuinielaF();

-- 13 y 14
DROP PROCEDURE IF EXISTS MultiQuiniela;
DELIMITER $$
CREATE PROCEDURE MultiQuiniela(columnas INT)
BEGIN
    DECLARE contador INT DEFAULT 1;
    DECLARE resultado VARCHAR(255);
    
    WHILE contador <= columnas DO
        SET resultado = CONCAT("COLUMNA ", contador, ": ", QuinielaF());
        SELECT resultado;
        SET contador = contador + 1;
    END WHILE;
    
END
$$

CALL MultiQuiniela(3);

-- 15
DROP PROCEDURE IF EXISTS Primitiva;
DELIMITER $$
CREATE PROCEDURE Primitiva()
BEGIN
	DECLARE numRandom INT;
	DECLARE numRandomConvertido CHAR(2);
	DECLARE contador INT DEFAULT 1;
    DECLARE resultado VARCHAR(100);
    SET resultado = "RESULTADO: ";
    
    WHILE contador <= 6 DO
		SET numRandom = TRUNCATE(RAND() * 50, 0);
        SET numRandomConvertido = CONVERT(numRandom, CHAR);
        SET resultado = CONCAT(resultado, numRandomConvertido, " ");
		SET contador = contador + 1;
	END WHILE;
	
    SELECT resultado;
END
$$

CALL Primitiva();

-- 16
DROP FUNCTION IF EXISTS PrimitivaF;
DELIMITER $$
CREATE FUNCTION PrimitivaF() RETURNS VARCHAR(100)
BEGIN
	DECLARE numRandom INT;
	DECLARE numRandomConvertido CHAR(2);
	DECLARE contador INT DEFAULT 1;
    DECLARE resultado VARCHAR(100);
    SET resultado = "RESULTADO: ";
    
    WHILE contador <= 6 DO
		SET numRandom = TRUNCATE(RAND() * 50, 0);
        SET numRandomConvertido = CONVERT(numRandom, CHAR);
        SET resultado = CONCAT(resultado, numRandomConvertido, " ");
		SET contador = contador + 1;
	END WHILE;
	
    RETURN resultado;
END
$$

SELECT PrimitivaF();

-- 17
DROP PROCEDURE IF EXISTS MultiPrimitiva;
DELIMITER $$
CREATE PROCEDURE MultiPrimitiva(columnas INT)
BEGIN
	DECLARE contador INT DEFAULT 1;
    DECLARE resultado VARCHAR(255);
    
    WHILE contador <= columnas DO
        SET resultado = CONCAT("COLUMNA ", contador, ": ", PrimitivaF());
        SELECT resultado;
        SET contador = contador + 1;
    END WHILE;
END
$$

CALL MultiPrimitiva(3);


