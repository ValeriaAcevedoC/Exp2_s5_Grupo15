-- Caso 1:

SELECT 
TO_CHAR(c.NUMRUN, '99g999G999') || '-' || c.DVRUN                               AS "RUT Cliente",
INITCAP(c.PNOMBRE || ' ' || c.APPATERNO)                                        AS "Nombre Cliente",
UPPER(p.nombre_prof_ofic)                                                       AS "Profesión Cliente",
TO_CHAR(c.FECHA_INSCRIPCION, 'DD-MM-YY')                                        AS "Fecha de Inscripción",
c.DIRECCION                                                                     AS "Dirección Cliente"
FROM cliente c
JOIN 
profesion_oficio p
ON(c.cod_prof_ofic = p.cod_prof_ofic)
WHERE p.nombre_prof_ofic IN ('Contador', 'Vendedor')
AND EXTRACT(year from c.fecha_inscripcion) > (select round(avg(EXTRACT(YEAR FROM fecha_inscripcion))) from cliente)
ORDER BY 1 ASC;


-- Caso 2:

CREATE TABLE CLIENTES_CUPOS_COMPRA AS

SELECT
c.NUMRUN || '-' || c.DVRUN                                                      AS "RUT_CLIENTE",
FLOOR(MONTHS_BETWEEN(SYSDATE, c.fecha_nacimiento) / 12)                         AS "EDAD",
TO_CHAR(t.cupo_disp_compra, '$9G999G999')                                       AS "CUPO_DISPONIBLE_COMPRA",
UPPER(tc.nombre_tipo_cliente)                                                   AS "TIPO_CLIENTE"
FROM cliente c
JOIN 
tipo_cliente tc
ON(c.cod_tipo_cliente = tc.cod_tipo_cliente)
JOIN tarjeta_cliente t
ON(c.numrun = t.numrun)
WHERE t.cupo_disp_compra >= (select MAX(cupo_disp_compra) from tarjeta_cliente
                        WHERE EXTRACT(year from fecha_solic_tarjeta) = extract(year from sysdate) - 1 )
ORDER BY 2 ASC;


select * from clientes_cupos_compra;






