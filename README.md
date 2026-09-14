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

Fase de Visualización y Modelado Analítico (Power BI)
La extracción de datos relacionales se ha integrado en un modelo semántico en Power BI para el desarrollo de un panel interactivo. El objetivo es proporcionar una herramienta de diagnóstico visual para la evaluación de las métricas de retención en tiempo real.

1. Transformación de Datos (ETL) en Power Query
Se ejecutó un proceso de limpieza clínica para asegurar la integridad del modelo de datos:

Eliminación de varianza cero: Se suprimieron las variables EmployeeCount, Over18 y StandardHours al contener valores constantes que consumen recursos de memoria sin aportar información analítica.

Binarización de la variable objetivo: Transformación de la variable categórica de texto Attrition (Yes/No) a una variable dicotómica numérica Fuga_Talento (1/0) para habilitar su agregación matemática.

Auditoría de tipos de datos: Reconfiguración de formatos alfanuméricos a números enteros en las variables operativas para prevenir fallos de cálculo en el motor DAX.

2. Modelado de Datos (Expresiones DAX)
Se desestimó el uso de sumarizaciones implícitas en favor de medidas DAX explícitas, garantizando el control técnico absoluto sobre los Indicadores Clave de Rendimiento (KPIs):

Total Empleados: Recuento estructural de la plantilla activa e inactiva.

Fragmento de código
Total Empleados = COUNTROWS('Empleados')
Fugas Totales: Agregación de la variable dicotómica de retención.

Fragmento de código
Fugas Totales = SUM('Empleados'[Fuga_Talento])
Tasa de Rotación: Ratio porcentual de desgaste operativo.

Fragmento de código
Tasa Rotacion = DIVIDE([Fugas Totales], [Total Empleados], 0)
3. Diagnóstico Visual y Focos de Expulsión
El panel interactivo confirma y cuantifica patrones de rotación perjudiciales para la estructura de la compañía:

Impacto del Sobreesfuerzo (OverTime): La asunción de horas extraordinarias triplica la probabilidad de fuga. El segmento sometido a esta carga presenta una tasa de rotación del 30,53%, frente al 10,44% del segmento regular.

Inestabilidad por Departamento: El área de Ventas (Sales) sufre la mayor inestabilidad estructural con un 20,63% de rotación, seguida estrechamente por Recursos Humanos (19,05%).

Desgaste Crítico por Rol: Los perfiles base asumen el mayor desgaste operativo. Sales Representative (39,76%) y Laboratory Technician (23,94%) son los roles con mayor incapacidad de retención.

(Nota técnica: El archivo fuente .pbix y la previsualización del dashboard en .pdf se encuentran disponibles en el directorio /powerbi de este repositorio).
FROM PoblacionPrecariedad
GROUP BY OverTime;
