CREATE OR REPLACE VIEW `personal-projects-497114.inclusion_financiera_colombia.vw_creditos_consumo_por_departamento`
AS
WITH limpieza_textos AS (
  SELECT 
    REPLACE(UPPER(TRIM(departamento)), 'NARIﾑO', 'NARIÑO') AS departamento,
    PARSE_DATE('%d/%m/%Y', fecha_de_corte) AS fecha_de_corte,
    
    SAFE_CAST(REPLACE(REPLACE(nro_credito_consumo_mujeres, '.', ''), ',', '') AS INT64) AS nro_credito_consumo_mujeres,
    SAFE_CAST(REPLACE(REPLACE(nro_credito_consumo_hombres, '.', ''), ',', '') AS INT64) AS nro_credito_consumo_hombres,
    
    SAFE_CAST(REPLACE(REPLACE(REPLACE(monto_credito_consumo_mujeres, '$', ''), '.', ''), ',', '.') AS FLOAT64) AS monto_credito_consumo_mujeres,
    SAFE_CAST(REPLACE(REPLACE(REPLACE(monto_credito_consumo_hombres, '$', ''), '.', ''), ',', '.') AS FLOAT64) AS monto_credito_consumo_hombres

  FROM `personal-projects-497114.inclusion_financiera_colombia.datos_colombia`
  WHERE departamento IS NOT NULL 
    AND departamento != 'DEPARTAMENTO' 
    AND departamento != 'TOTAL NACIONAL'
    AND departamento NOT IN (
      'AGREGADORES DE CORRESPONSALES',
      'CORRESPONSALES TIPO NEGOCIO',
      'CUENTAS DE AHORRO',
      'CUENTAS DE AHORRO ELECTRONICAS',
      'CUENTAS DE AHORRO TRAMITE SIMPLIFICADO',
      'DEPOSITOS DINERO ELECT TRAMITE SIMPLIFI',
      'DEPOSITOS DINERO ELECTRONICO'
    )
)
SELECT 
  departamento,
  fecha_de_corte,
  SUM(nro_credito_consumo_mujeres) AS total_creditos_mujeres,
  ROUND(SUM(monto_credito_consumo_mujeres), 2) AS monto_total_mujeres,
  SUM(nro_credito_consumo_hombres) AS total_creditos_hombres,
  ROUND(SUM(monto_credito_consumo_hombres), 2) AS monto_total_hombres,
  ROUND(SAFE_DIVIDE(SUM(monto_credito_consumo_mujeres), SUM(nro_credito_consumo_mujeres)), 2) AS ticket_promedio_mujeres,
  ROUND(SAFE_DIVIDE(SUM(monto_credito_consumo_hombres), SUM(nro_credito_consumo_hombres)), 2) AS ticket_promedio_hombres
FROM limpieza_textos
GROUP BY departamento, fecha_de_corte
ORDER BY departamento, fecha_de_corte;
