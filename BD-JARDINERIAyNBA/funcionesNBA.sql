SET GLOBAL log_bin_trust_function_creators=1;

-- 11
DROP FUNCTION IF EXISTS totalPartidos;
DELIMITER $$
CREATE FUNCTION totalPartidos(xd VARCHAR(5)) RETURNS INT
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM partidos
    WHERE temporada = xd;

    RETURN total;
END
$$

SELECT totalPartidos("98/99");

-- 12
DROP PROCEDURE IF EXISTS califJugador;
DELIMITER $$
CREATE PROCEDURE califJugador()
BEGIN
	DECLARE inicio, fin INT;
	DECLARE puntos FLOAT;
    DECLARE estatusNuevo VARCHAR(20);
    
    SELECT MIN(codigo) INTO inicio FROM jugadores;
	SELECT MAX(codigo) INTO fin FROM jugadores;
    
    WHILE inicio <= fin DO
		SELECT Puntos_por_partido INTO puntos FROM estadisticas;
    
		IF puntos < 5 THEN
			SET estatusNuevo = "Malo";
		ELSEIF puntos >= 5 AND puntos < 10 THEN
			SET estatusNuevo = "Normal";
		ELSEIF puntos >= 10 AND puntos < 20 THEN
			SET estatusNuevo = "Bueno";
		ELSEIF puntos > 20 THEN
			SET estatusNuevo = "Excelente";
		END IF;
        
        UPDATE jugadores
		SET ESTATUS = estatusNuevo;
		
		SET inicio = inicio + 1;
    END WHILE;
END
$$

CALL califJugador(); -- NO ENTIENDO PORQUE ME DA ERROR














