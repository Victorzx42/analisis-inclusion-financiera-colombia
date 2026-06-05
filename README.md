# Análisis Estratégico de Inclusión Financiera en Colombia 🇨🇴📊

## 📌 Descripción General del Proyecto
Este proyecto analiza el estado actual de la inclusión financiera en Colombia, procesando datos públicos gubernamentales para identificar brechas sociales, geográficas y tecnológicas. A través de un pipeline ELT implementado con PySpark y Google BigQuery, se procesaron y modelaron los datos para alimentar paneles interactivos en Looker Studio. El objetivo principal es extraer *insights* accionables que guíen la apertura de nuevos canales de atención y el diseño de productos financieros más equitativos y accesibles.

## 🏢 Comprensión Empresarial
El proyecto nace como respuesta a un requerimiento de la Dirección de Estrategia Comercial para validar tres hipótesis críticas del negocio:
1. **Brecha de Género:** ¿Existe una diferencia significativa en el acceso y monto de créditos otorgados entre hombres y mujeres a nivel departamental?
2. **Zonas de Exclusión:** ¿Cuáles son los municipios con mayor vulnerabilidad financiera debido a la falta de infraestructura física (corresponsales)?
3. **Adopción Digital:** ¿Cuál es la penetración real de las cuentas digitales frente a la banca tradicional y cómo se comporta el capital en estas plataformas?

## 🛠️ Comprensión de los Datos y Stack Tecnológico
Los datos crudos fueron extraídos del portal de Datos Abiertos del Gobierno de Colombia (datos.gov.co). Para el procesamiento y análisis se utilizó el siguiente stack de datos en la nube:
* **Extracción y Transformación (Python/PySpark):** Lectura de archivos CSV directamente desde un Data Lake en Google Cloud Storage. Se realizó limpieza de encabezados, estandarización de esquemas y optimización de memoria (`inferSchema=False`).
* **Carga y Modelado (Google BigQuery & SQL):** Ingesta de datos limpios a BigQuery. Mediante consultas SQL avanzadas se corrigieron errores de codificación complejos (mojibake) en nombres de municipios, se filtraron anomalías y se calcularon las métricas de negocio.
* **Visualización (Looker Studio):** Desarrollo de 3 dashboards interactivos para responder a las preguntas de negocio.

## 📈 Resultados y Hallazgos Clave

### 1. Brecha de Género en Créditos
* **Insight:** Existe una brecha general del 6,79% a favor de los hombres en el valor promedio de los créditos asignados.
* **Comportamiento Urbano:** En hubs urbanos como Bogotá y Atlántico, las mujeres solicitan un mayor volumen de créditos que los hombres, pero por montos drásticamente menores (ticket promedio más bajo).
*(Agrega aquí la imagen de tu dashboard: `![Dashboard Brecha de Género](ruta_de_tu_imagen.png)`)*

### 2. Brecha de Exclusión Financiera Municipal
* **Insight:** Se evidenció una desigualdad extrema. Mientras el consolidado nacional sostiene un saldo promedio por cuenta de $1.664.382, los "Municipios con Menor Acceso" apenas alcanzan los $632.098.
* **Zonas Críticas:** Municipios como Pacoa y Puerto Alegría registran cero (0) corresponsales, lo que se traduce en una captación nula de ahorro formal.
*(Agrega aquí la imagen de tu dashboard: `![Dashboard Exclusión Financiera](ruta_de_tu_imagen.png)`)*

### 3. Adopción: Banca Tradicional vs. Digital
* **Insight:** La digitalización del portafolio se encuentra en una fase temprana, con una Tasa Nacional de Adopción de apenas el 6,0%.
* **Uso Real:** El indicador más crítico revela que solo el 0,77% utiliza la cuenta digital como su cuenta principal; la gran mayoría la abre como producto secundario o de prueba, manteniendo su capital anclado a la banca tradicional.
*(Agrega aquí la imagen de tu dashboard: `![Dashboard Adopción Digital](ruta_de_tu_imagen.png)`)*

## 🚀 Conclusiones y Pasos Futuros (Recomendaciones Estratégicas)
Con base en los datos analizados, se recomiendan las siguientes acciones comerciales:
* **Diseño de Productos Inclusivos:** Crear líneas de crédito con topes más altos dirigidas a mujeres en hubs urbanos, aprovechando su alta disposición a solicitar productos financieros.
* **Intervención Geográfica:** Diseñar un plan piloto de infraestructura ligera (corresponsales móviles) e incentivos comerciales para tenderos en los municipios del decil más bajo de acceso.
* **Incentivar la Transaccionalidad Principal:** Rediseñar los beneficios de las cuentas digitales (ej. cero cuota de manejo) condicionados a la domiciliación de nómina, para atacar directamente el bajo KPI de uso principal (0,77%).
