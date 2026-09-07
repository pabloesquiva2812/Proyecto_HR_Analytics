CREATE VIEW vista_rrhh_limpia AS
SELECT 
    EmployeeNumber,
    Department,
    JobRole,
    Attrition,
    MonthlyIncome,
    CASE 
        WHEN MonthlyIncome < 3000 THEN '1_Salario Bajo'
        WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN '2_Salario Medio'
        ELSE '3_Salario Alto'
    END AS tramo_salarial,
    DistanceFromHome,
    CASE 
        WHEN DistanceFromHome <= 5 THEN '1_Cerca (0-5 km)'
        WHEN DistanceFromHome BETWEEN 6 AND 15 THEN '2_Media (6-15 km)'
        ELSE '3_Lejos (+15 km)'
    END AS tramo_distancia,
    OverTime
FROM employees ;