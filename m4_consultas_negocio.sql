-- Motor utilizado: MySQL (MySQL Workbench)
-- pre-entrega M4 del caso TechStore

USE Ventas_Tech_DB;
-- CONSULTA 1 -  Resumen ejecutivo mensual
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_de_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

-- CONSULTA 2 — Ranking de productos
SELECT 
	id_producto,
	sum(cantidad) as unidades_vendidas, 
	sum(cantidad*precio_unitario) as total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado desc
LIMIT 5;


-- CONSULTA 3 — Clientes recurrentes
SELECT 
	id_cliente, 
	count(*) as cantidad_pedidos, 
	sum(cantidad*precio_unitario) as total_gastado
from ventas
GROUP BY id_cliente
HAVING count(*) > 1;


-- CONSULTA 4  — Productos por encima/por debajo del promedio

WITH facturacion_por_producto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_por_producto
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_por_producto
ORDER BY total_facturado DESC;

-- BLOQUE DE CIERRE
-- 1. El producto 1 generó $3.600, aproximadamente el 55,9% de la facturación total.
-- 2. Los productos 1 y 3 concentraron en conjunto aproximadamente el 76,8% de la facturación.
-- 3. Los cinco clientes realizaron 2 pedidos cada uno; el cliente 1 fue quien más gastó, con un total de $2.640.

