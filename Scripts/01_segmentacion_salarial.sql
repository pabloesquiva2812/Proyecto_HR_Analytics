/*
===============================================================================
PROYECTO PEOPLE ANALYTICS: Fuga de Talento (Attrition)
Script 01: Segmentación Salarial
Hipótesis de negocio: La escasez salarial absoluta actúa como factor principal de expulsión.
Objetivo técnico: Recodificación de salarios continuos en estratos categóricos.
===============================================================================
*/
SELECT 
    CASE 
        WHEN MonthlyIncome < 3000 THEN '1_Salario Bajo'
        WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN '2_Salario Medio'
        ELSE '3_Salario Alto'
    END AS tramo_salarial,
    COUNT(*) AS total_empleados,
   --Cuantificación del volumen de abandonos absolutos
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_abandonos,
    -- Cálculo de la tasa porcentual para aislar el impacto real frente al volumen del estrato
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS tasa_abandono_porcentaje
FROM employees
GROUP BY 
    tramo_salarial
ORDER BY 
    tramo_salarial ASC;