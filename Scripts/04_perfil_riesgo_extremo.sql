/*
===============================================================================
PROYECTO PEOPLE ANALYTICS: Fuga de Talento (Attrition)
Script 04: Perfil de Riesgo Extremo
Hipótesis de negocio: La acumulación de factores (brecha salarial + trayectos largos en el área más afectada) dispara el riesgo de fuga.
Objetivo técnico: Uso de CTEs (Common Table Expressions) para fusionar variables complejas de forma modular y auditable.
===============================================================================
*/

-- CTE 1: Aísla exclusivamente a la población del departamento con mayor rotación por agravio
WITH EmpleadosVentas AS (
    SELECT EmployeeNumber, MonthlyIncome, DistanceFromHome, Attrition
    FROM employees
    WHERE Department = 'Sales'
),
-- CTE 2: Calcula la media matemática de la población aislada previamente
MediaVentas AS (
    SELECT AVG(MonthlyIncome) AS media_salarial
    FROM EmpleadosVentas
)
SELECT 
    COUNT(*) AS poblacion_riesgo_extremo,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS abandonos,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS tasa_abandono_critica
FROM EmpleadosVentas, MediaVentas
-- Ejecución del cruce de los dos factores de estrés estructural
WHERE EmpleadosVentas.MonthlyIncome < MediaVentas.media_salarial
  AND EmpleadosVentas.DistanceFromHome > 15;