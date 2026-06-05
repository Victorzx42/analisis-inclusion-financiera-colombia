CREATE OR REPLACE VIEW `personal-projects-497114.inclusion_financiera_colombia.vw_inclusion_financiera_municipios`
AS
WITH DatosLimpios AS (
  SELECT 
    CASE 
      WHEN municipio LIKE 'CHACHAG%' THEN 'CHACHAGÜÍ'
      WHEN municipio LIKE 'BRICEÃ%'  THEN 'BRICEÑO'
      ELSE UPPER(municipio)
    END AS municipio_limpio,

    PARSE_DATE('%d/%m/%Y', fecha_de_corte) AS fecha_de_corte,

    COALESCE(SAFE_CAST(REPLACE(REPLACE(nro_corresponsales,      '.', ''), ',', '.') AS INT64),   0) AS nro_corresponsales,
    COALESCE(SAFE_CAST(REPLACE(REPLACE(saldo_total_cta_ahorros, '.', ''), ',', '.') AS FLOAT64), 0) AS saldo_total_cta_ahorros,
    COALESCE(SAFE_CAST(REPLACE(REPLACE(nro_total_cta_ahorros,   '.', ''), ',', '.') AS FLOAT64), 0) AS nro_total_cta_ahorros

  FROM `personal-projects-497114.inclusion_financiera_colombia.datos_colombia`
),

DatosAgrupados AS (
  SELECT
    municipio_limpio,
    CONCAT(municipio_limpio, ', Colombia') AS municipio_geo,
    fecha_de_corte,
    EXTRACT(YEAR FROM fecha_de_corte)        AS anio,
    SUM(nro_corresponsales)                  AS total_corresponsales,
    SUM(saldo_total_cta_ahorros)             AS saldo_total,
    SAFE_DIVIDE(
      SUM(saldo_total_cta_ahorros),
      SUM(nro_total_cta_ahorros)
    )                                        AS saldo_promedio_por_cuenta

  FROM DatosLimpios
  WHERE municipio_limpio NOT LIKE 'TOTAL%' 
    AND municipio_limpio NOT LIKE 'DEPÓSITOS%' 
    AND municipio_limpio NOT LIKE 'DEP DINERO%' 
    AND municipio_limpio NOT LIKE 'CUENTAS%'
    AND municipio_limpio NOT LIKE 'TRANSFERENCIAS%'
    AND municipio_limpio NOT LIKE 'DEP%SITO%'
    AND municipio_limpio NOT LIKE 'DEP%NERO%'
    AND municipio_limpio NOT LIKE 'M%VILRED'
    AND municipio_limpio NOT LIKE 'V%A BALOTO'
    AND municipio_limpio NOT IN (
      'AGENCIA SU RED', 'ASSENDA RED S.A', 'BQUANTUM', 'COMCARD', 'DISTRICOL', 
      'E-PAGO', 'EDEQ', 'ESTABLECIMIENTOS DE CRÉDITO', 'FULLCARGA', 'GRANDES SUPERFICIES', 
      'MERCAR', 'MULTIPAY S.A', 'MÓVILRED', 'PAGA TODO', 'PUNTO RED', 'RED CERCA', 
      'REVAL', 'SERBINET', 'SERVYPAGOS', 'VÍA BALOTO', 'SUPERGIROS', 'EFECTY', 
      'RETIROS', 'PAGOS', 'OTROS', 'ACT ARTÍST, DE ENTRET Y RECREA Y TURISMO',
      'COMERCIO DE ALIMENTOS Y BEBIDAS', 
      'SERVICIOS DE TELECOMUNICACION Y POSTALES', 
      'ACTIVIDADES FINANCIERAS Y DE SEGUROS', 
      'COMERCIO BIENES CONSUMO DIFERENTES ALIME', 
      'COMERCIO PRODUC Y SERVI AUT Y TRANSPORTE'
    )
  GROUP BY 1, 2, 3, 4
)

SELECT
  municipio_limpio,
  municipio_geo,
  fecha_de_corte,
  anio,
  total_corresponsales,
  saldo_total,
  saldo_promedio_por_cuenta,

  CASE
    WHEN NTILE(10) OVER (PARTITION BY anio ORDER BY total_corresponsales ASC) = 1
    THEN '10% Más Bajo'
    ELSE 'Resto del País'
  END AS grupo_exclusion_corresponsales,

  CASE
    WHEN NTILE(10) OVER (PARTITION BY anio ORDER BY saldo_promedio_por_cuenta ASC NULLS LAST) = 1
    THEN '10% Más Bajo'
    ELSE 'Resto del País'
  END AS grupo_exclusion_saldos

FROM DatosAgrupados;
