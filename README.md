# Diagnóstico Estructural de Fuga de Talento (People Analytics)

## Contexto de Negocio
El presente proyecto cuantifica los factores de rotación voluntaria (attrition) en la plantilla. Partiendo de una tasa de fuga estructural global del **16%**, el objetivo clínico es abandonar las métricas reactivas y aislar los detonantes sociolaborales exactos empleando modelado relacional en SQL (SQLite).

## Hallazgos Clínicos y Métricas de Impacto
* **Precariedad Salarial:** Actúa como factor primario de expulsión. El estrato salarial más bajo presenta una tasa de fuga del **28,61%**, descendiendo drásticamente al 12% y 10,8% en los tramos medio y alto.
* **Equidad Interna y Agravio Comparativo:** El castigo por cobrar por debajo de la media departamental es asimétrico. El área de Ventas lidera la fuga en esta condición con un **22,38%**. Por el contrario, I+D concentra el mayor volumen absoluto de afectados (655 empleados) pero demuestra mayor resistencia (17,56%).
* **Fricción Geográfica:** Se confirma una correlación directa y positiva; el abandono escala proporcionalmente a la distancia entre el domicilio y el centro de trabajo.
* **Perfil de Riesgo Extremo:** La acumulación simultánea de estresores (pertenecer a Ventas, sufrir brecha salarial interna y asumir trayectos largos) dispara la rotación al **29,51%**, rozando el doble del abandono general.
* **Detonante de Horas Extra:** Constituye la principal falla operativa de la organización. Exigir horas extraordinarias a la población sometida a escasez salarial eleva su fuga a un crítico **56,14%**, triplicando el índice de sus homólogos precarios sin sobrecarga horaria (17,44%).

## Evidencia Técnica (Modelado en SQL)

Para aislar estas variables no se recurre a extracciones planas, sino a la evaluación simultánea de factores mediante funciones de ventana analógicas y expresiones de tabla comunes.

**1. Aislamiento de la Brecha Salarial Interna (Subconsulta Correlacionada):**
Identifica empleados cuyo salario es estrictamente inferior a la media matemática exacta de su grupo de pares (departamento).
```sql
SELECT 
    Department,
    COUNT(*) AS empleados_bajo_media,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS tasa_abandono
FROM vista_rrhh_limpia a
WHERE MonthlyIncome < (
    SELECT AVG(MonthlyIncome) 
    FROM vista_rrhh_limpia b 
    WHERE a.Department = b.Department
)
GROUP BY Department;

WITH PoblacionPrecariedad AS (
    SELECT Attrition, OverTime
    FROM vista_rrhh_limpia
    WHERE MonthlyIncome < 3000
)
SELECT 
    OverTime AS horas_extra,
    COUNT(*) AS total_empleados,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS tasa_abandono
FROM PoblacionPrecariedad
GROUP BY OverTime;
