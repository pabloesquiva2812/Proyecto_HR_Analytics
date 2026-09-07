/*
===============================================================================
PROYECTO PEOPLE ANALYTICS: Fuga de Talento (Attrition)
Script 02: Agravio Comparativo por Departamento
Hipótesis de negocio: Cobrar por debajo de la media de los compañeros directos acelera la rotación, con impacto asimétrico por área.
Objetivo técnico: Uso de subconsulta correlacionada para aislar la brecha salarial interna.
===============================================================================
*/
SELECT 
    Department,
    COUNT(*) AS empleados_bajo_media,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS abandonos,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS tasa_abandono
FROM employees a
-- La subconsulta anidada calcula la media exacta del departamento en curso para compararla con el empleado individual
WHERE MonthlyIncome < (
    SELECT AVG(MonthlyIncome) 
    FROM employees b 
    WHERE a.Department = b.Department
)
GROUP BY Department;
