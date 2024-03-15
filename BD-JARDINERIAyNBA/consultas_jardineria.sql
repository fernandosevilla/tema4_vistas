-- 2 Diseñar una VISTA(PEDIDOS_2009) de los pedidos del año 2009 con los siguientes datos: CODIGOPEDIDO, FECHAPED, 
-- ESTADO,CODCLI, NOMCLI, IMPORTEPEDIDO(en Euros y con 2 decimales) Ordenados por cliente y pedido.
CREATE OR REPLACE VIEW PEDIDOS_2009 AS
SELECT DISTINCT p.CodigoPedido, p.FechaPedido, p.estado, p.CodigoCliente,
(SELECT NombreCliente FROM clientes
	WHERE CodigoCliente = p.CodigoCliente) AS NombreCliente,
ROUND((SELECT CONCAT(SUM(dp.Cantidad * dp.PrecioUnidad), "€")
	FROM detallepedidos dp 
	WHERE dp.CodigoPedido = p.CodigoPedido), 2) AS ImportePedido
FROM pedidos p, clientes c, productos pr
WHERE YEAR(p.FechaPedido) = 2009
ORDER BY p.CodigoCliente, p.CodigoPedido;

SELECT * FROM PEDIDOS_2009;

-- 3 Diseñar una VISTA(PEDIDOS_PDTES) de los pedidos pendientes de entrega con los siguientes datos:
-- CODIGOPEDIDO, FECHAPED, CODCLI, NOMCLI, CP,CIUDAD, PAIS, CODOFICINA, CIUDADOFICINA, IMPORTEPEDIDO
-- Ordenados por PAIS, CIUDAD,CLIENTE
CREATE OR REPLACE VIEW PEDIDOS_PDTES AS
SELECT p.CodigoPedido, p.FechaPedido, c.CodigoCliente, c.NombreCliente, o.CodigoPostal, o.Ciudad, o.pais, o.CodigoOficina AS CodigoOfi,
CONCAT(ROUND((SELECT SUM(dp.Cantidad * dp.PrecioUnidad)
	FROM detallepedidos dp 
	WHERE dp.CodigoPedido = p.CodigoPedido), 2),"€") AS ImportePedido
FROM Pedidos p, Clientes c, Oficinas o, detallepedidos dp, Empleados e
WHERE p.CodigoCliente = c.CodigoCliente
AND p.CodigoPedido = dp.CodigoPedido
AND c.CodigoEmpleadoRepVentas = e.CodigoEmpleado 
AND o.CodigoOficina = e.CodigoOficina
AND p.estado = "Pendiente"
GROUP BY p.CodigoPedido
ORDER BY o.pais, o.ciudad, c.CodigoCliente;

SELECT * FROM PEDIDOS_PDTES;

-- 4 . Diseñar una VISTA(PEDIDOSCLIENTES) con el importe total de los pedidos de cada cliente con los siguientes
-- datos(NOTA IMPORTANTE: en esta vista deben salir los 36 clientes¡¡):
-- CODCLI, NOMCLI, CP,CIUDAD, PAIS, IMPORTEPEDIDOS(en Euros y con 2 decimales)
-- Ordenados por PAIS,CIUDAD e IMPORTE(de mayor a menor)
CREATE OR REPLACE VIEW PEDIDOSCLIENTES AS
SELECT c.CodigoCliente, c.NombreCliente, c.CodigoPostal, c.Ciudad, c.pais,
CONCAT(ROUND(SUM(dp.Cantidad * dp.PrecioUnidad)), "€") AS ImportePedidos
FROM clientes c
LEFT JOIN Pedidos p ON p.CodigoCliente = c.CodigoCliente
LEFT JOIN detallepedidos dp ON p.CodigoPedido = dp.CodigoPedido
GROUP BY c.CodigoCliente, c.NombreCliente, c.CodigoPostal, c.Ciudad, c.pais
ORDER BY ImportePedidos DESC, c.Pais DESC, c.ciudad DESC;

SELECT * FROM PEDIDOSCLIENTES;

-- 5 Diseñar una VISTA(MEJORCLIxOFICINA) con los siguientes datos, es decir de cada OFICINA debemos obtener
-- el mejor cliente del año 2009(en base al importe de sus pedidos):
-- CODIGOOFICINA,CIUDAD,PAIS, CODCLI,NOMCLI, IMPORTEPEDIDOS(en Euros y con 2 decimales)
CREATE OR REPLACE VIEW MEJORCLIXOFICINA AS
SELECT o.CodigoOficina, o.ciudad, o.pais, c.CodigoCliente, c.NombreCliente, 
CONCAT(ROUND(SUM(dp.Cantidad * dp.PrecioUnidad)), "€") AS ImportePedidos
FROM oficinas o, detallepedidos dp
RIGHT JOIN empleados e ON e.CodigoOficina = o.CodigoOficina
INNER JOIN clientes c ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
INNER JOIN pedidos p ON p.CodigoCliente = c.CodigoCliente
WHERE YEAR (p.FechaPedido) = 2009
HAVING ImportePedidos = (SELECT CONCAT(ROUND(SUM(dp.Cantidad * dp.PrecioUnidad)), "€")
						
						
                        










