/*
===============================================================================
PROYECTO PEOPLE ANALYTICS: Fuga de Talento (Attrition)
Script 05: Detonante de Horas Extra
Hipótesis de negocio: La sobrecarga horaria actúa como el detonante definitivo de expulsión en la población precaria.
Objetivo técnico: Aislamiento de un estrato económico base mediante CTE para evaluar el impacto de una variable binaria.
===============================================================================
*/

-- Aislamiento de la población base sometida a escasez salarial absoluta
WITH PoblacionPrecariedad AS (
    SELECT Attrition, OverTime
    FROM employees
    WHERE MonthlyIncome < 3000
)
SELECT 
    OverTime AS horas_extra,
    COUNT(*) AS total_empleados,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS abandonos,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS tasa_abandono
FROM PoblacionPrecariedad
GROUP BY OverTime;