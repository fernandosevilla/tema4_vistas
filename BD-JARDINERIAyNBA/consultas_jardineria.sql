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
-- FALTA ARREGLARLO
CREATE OR REPLACE VIEW MEJORCLIXOFICINA AS
SELECT o.CodigoOficina, o.ciudad, o.pais, c.CodigoCliente, c.NombreCliente, 
CONCAT(ROUND(SUM(dp.Cantidad * dp.PrecioUnidad), 2), "€") AS ImportePedidos
FROM oficinas o
JOIN empleados e ON o.CodigoOficina = e.CodigoOficina
JOIN clientes c ON e.CodigoEmpleado = c.CodigoEmpleadoRepVentas
JOIN pedidos p ON c.CodigoCliente = p.CodigoCliente
JOIN detallepedidos dp ON p.CodigoPedido = dp.CodigoPedido
WHERE YEAR(p.FechaPedido) = 2009
GROUP BY o.CodigoOficina, c.CodigoCliente
HAVING ImportePedidos = (
    SELECT CONCAT(ROUND(SUM(dp.Cantidad * dp.PrecioUnidad), 2), "€") AS ImporteTotal
    FROM pedidos p
    JOIN detallepedidos dp ON p.CodigoPedido = dp.CodigoPedido
    WHERE p.CodigoCliente = c.CodigoCliente
    GROUP BY p.CodigoCliente
    ORDER BY ImporteTotal DESC
    LIMIT 1)
ORDER BY o.pais, o.ciudad, ImportePedidos DESC;

SELECT * FROM MEJORCLIXOFICINA;

-- 6 Diseñar una VISTA(RANKING_PRODUCTOS) con los siguientes datos(NOTA IMPORTANTE: en esta vista deben
-- salir todos los productos, los 276 productos¡¡):
-- ARTICULO(CODIGOPRODUCTO,GAMA,NOMBRE),CANTIDAD,IMPORTEPEDIDOS(en Euros y con 2 decimales),
-- PORC_PEDIDOS(en base al importe, 0 decimales y con el símbolo %)
-- Ordenados por importe de mayor a menor.
CREATE OR REPLACE VIEW RANKING_PRODUCTOS AS
SELECT p.CodigoProducto, p.Gama, p.Nombre, SUM(dp.cantidad) AS Cantidad, 
CONCAT(ROUND(SUM(dp.Cantidad * dp.PrecioUnidad), 2), "€") AS ImportePedidos,
CONCAT(ROUND(SUM(dp.Cantidad * dp.PrecioUnidad) * 100 / (SELECT SUM(Cantidad * PrecioUnidad) FROM detallepedidos), 2), "%") AS PORC_PEDIDOS
FROM pedidos ped
INNER JOIN detallepedidos dp ON dp.CodigoPedido = ped.CodigoPedido
RIGHT JOIN productos p ON p.CodigoProducto = dp.CodigoProducto
GROUP BY p.CodigoProducto
ORDER BY SUM(dp.Cantidad * dp.PrecioUnidad) DESC; 

SELECT * FROM RANKING_PRODUCTOS;

-- 7 Diseñar una VISTA(VISTAJEFES) de tal forma que nos salgan los jefes y los empleados que tienen a su cargo
-- con los siguientes datos:
-- CODIGOOFICINA,PUESTO(del Jefe), CODIGOJEFE, NOMBREyAPELLIDOSdelJEFE, CODIGOEMPLEADO,
-- NOMBREyAPELLIDOS(del empleado y PUESTO (del empleado(s) a su cargo)
-- Ordenados por jefe y empleado
CREATE OR REPLACE VIEW VISTAJEFES AS
SELECT e.CodigoOficina, e.Puesto AS PuestoJefe, e.CodigoJefe,
CONCAT(e.Nombre, " ", e.Apellido1, " ", e.Apellido2) AS DatosJefe,
e2.CodigoEmpleado,
CONCAT(e2.Nombre, " ", e2.Apellido1, " ", e2.Apellido2) AS DatosEmpleado,
e2.Puesto
FROM empleados e, empleados e2
WHERE e.CodigoEmpleado = e2.CodigoJefe
ORDER BY e.CodigoJefe, e2.CodigoEmpleado;

SELECT * FROM VISTAJEFES;

-- 8 Diseñar ahora una VISTA similar a la anterior(VISTAEMPLEADOS-JEFE) de tal forma que nos salgan los todos
-- los empleados y su jefe con los siguientes datos:
-- DATOSdelEMPLEADO(código, nombre, apellidos,puesto) y DATOSdelJEFE(código, nombre, apellidos,puesto)
-- Ordenados por jefe y empleados
CREATE OR REPLACE VIEW VISTAEMPLEADOS_JEFE AS
SELECT CONCAT(e.CodigoEmpleado, " ", e.Nombre, " ", e.Apellido1, " ", e.Apellido2) AS DatosEmpleado,
e.Puesto AS PuestoEmpleado,
CONCAT(e2.CodigoJefe, " ", e2.Nombre, " ", e2.Apellido1, " ", e2.Apellido2) AS DatosJefe,
e2.Puesto AS PuestoJefe
FROM empleados e, empleados e2
WHERE e.CodigoJefe = e2.CodigoEmpleado
ORDER BY DatosJefe, DatosEmpleado;

SELECT * FROM VISTAEMPLEADOS_JEFE;