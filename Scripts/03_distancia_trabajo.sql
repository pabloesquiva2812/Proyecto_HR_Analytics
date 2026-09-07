/*
===============================================================================
PROYECTO PEOPLE ANALYTICS: Fuga de Talento (Attrition)
Script 03: Impacto del Desplazamiento
Hipótesis de negocio: La fricción geográfica opera como un factor de expulsión estructural independiente.
Objetivo técnico: Recodificación condicional de la distancia en anillos geográficos de fricción.
===============================================================================
*/

SELECT 
    CASE 
        WHEN DistanceFromHome <= 5 THEN '1_Cerca (0-5 km)'
        WHEN DistanceFromHome BETWEEN 6 AND 15 THEN '2_Media (6-15 km)'
        ELSE '3_Lejos (+15 km)'
    END AS tramo_distancia,
    COUNT(*) AS total_empleados,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS abandonos,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS tasa_abandono
FROM employees
GROUP BY 
    tramo_distancia
ORDER BY 
    tramo_distancia ASC;