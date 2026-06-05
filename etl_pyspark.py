import SparkSession
import re
# 1. Iniciar la sesión de Apache Spark
spark = SparkSession.builder \
    .appName("Limpieza e Ingestion ELT Colombiana") \
    .getOrCreate()
# 2. Extracción (Load to Spark): Leer el archivo crudo desde tu Data Lake en Cloud Storage
ruta_gcs = "gs://inclusion-financiera-colombia-raw-victorzx42/Inclusion_Financiera_20260521.csv"
# Cambio clave: inferSchema=False para evitar el colapso de memoria
df = spark.read.csv(ruta_gcs, header=True, inferSchema=False)
# 3. Transformación (T): Estandarizar encabezados problemáticos
nuevas_columnas = []
for col in df.columns:
    # Convertir a minúsculas y quitar espacios en los extremos
    clean_col = col.lower().strip()
    # Reemplazar cualquier caracter que NO sea letra, número o guion bajo, por un guion bajo
    clean_col = re.sub(r'[^a-z0-9_]', '_', clean_col)
    # Eliminar guiones bajos múltiples seguidos
    clean_col = re.sub(r'_+', '_', clean_col) 
    nuevas_columnas.append(clean_col)
# Aplicar los nuevos nombres de columnas limpios al DataFrame
df_limpio = df.toDF(*nuevas_columnas)
# 4. Carga (L): Escribir los datos procesados directamente en BigQuery
ruta_bq = "personal-projects-497114.inclusion_financiera_colombia.datos_colombia"
df_limpio.write \
    .format("bigquery") \
    .option("table", ruta_bq) \
    .option("temporaryGcsBucket", "inclusion-financiera-colombia-raw-victorzx42") \
    .mode("overwrite") \
    .save()
spark.stop()
