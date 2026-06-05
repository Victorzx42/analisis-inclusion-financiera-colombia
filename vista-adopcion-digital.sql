CREATE OR REPLACE VIEW `personal-projects-497114.inclusion_financiera_colombia.vw_adopcion_digital_municipios`
AS
WITH BaseAdopcion AS (
  SELECT
    CASE
      WHEN UPPER(TRIM(departamento)) LIKE '%NARIﾑ%'   THEN 'NARIÑO'
      WHEN UPPER(TRIM(departamento)) LIKE '%BOLﾍ%'    THEN 'BOLIVAR'
      WHEN UPPER(TRIM(departamento)) LIKE '%BOYACﾁ%'  THEN 'BOYACA'
      WHEN UPPER(TRIM(departamento)) LIKE '%ANTIOQU%' THEN 'ANTIOQUIA'
      ELSE UPPER(TRIM(departamento))
    END AS departamento,

    CASE
      WHEN UPPER(TRIM(municipio)) LIKE 'PUERTO NARE%'        THEN 'PUERTO NARE'
      WHEN UPPER(TRIM(municipio)) LIKE 'SANTAFE DE BOGOTA%'  THEN 'BOGOTA'
      WHEN UPPER(TRIM(municipio)) LIKE 'BOGOTA%'             THEN 'BOGOTA'
      WHEN UPPER(TRIM(municipio)) LIKE 'BRICEﾃ`O%'           THEN 'BRICEÑO'
      WHEN UPPER(TRIM(municipio)) LIKE 'BRICEÃ`O%'           THEN 'BRICEÑO'
      WHEN UPPER(TRIM(municipio)) LIKE 'GUACHENﾉ%'           THEN 'GUACHENÉ'
      WHEN UPPER(TRIM(municipio)) LIKE 'CHACHAGﾜI%'          THEN 'CHACHAGÜÍ'
      WHEN UPPER(TRIM(municipio)) LIKE 'SAN JOSﾉ DE URﾉ%'    THEN 'SAN JOSÉ DE URÉ'
      WHEN UPPER(TRIM(municipio)) LIKE 'PIJIM%'              THEN 'PIJIÑO'
      WHEN UPPER(TRIM(municipio)) LIKE 'UNIﾓN PANAMERICANA%' THEN 'UNIÓN PANAMERICANA'
      WHEN UPPER(TRIM(municipio)) LIKE 'RIO IRO%'            THEN 'RÍO IRO'
      WHEN UPPER(TRIM(municipio)) LIKE 'RÍO IRO%'            THEN 'RÍO IRO'
      WHEN UPPER(TRIM(municipio)) LIKE 'MEDIO BAUDﾓ%'        THEN 'MEDIO BAUDÓ'
      WHEN UPPER(TRIM(municipio)) LIKE 'DISTRACCIﾓN%'        THEN 'DISTRACCIÓN'
      WHEN UPPER(TRIM(municipio)) LIKE 'EL RETﾉN%'           THEN 'EL RETÉN'
      ELSE
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                REPLACE(
                  UPPER(TRIM(municipio)),
                  'ﾑ', '##ENYE##'),
                'Ñ', 'M'),
              '##ENYE##', 'Ñ'),
            'ﾁ', 'A'),
          'ﾍ', 'I')
    END AS municipio,

    PARSE_DATE('%d/%m/%Y', fecha_de_corte) AS fecha_de_corte,

    SAFE_CAST(
      REPLACE(REPLACE(nro_total_cta_ahorros, '.', ''), ',', '')
    AS INT64) AS nro_total_cuentas,

    SAFE_CAST(
      REPLACE(REPLACE(REPLACE(saldo_total_cta_ahorros, '$', ''), '.', ''), ',', '.')
    AS FLOAT64) AS saldo_total_cuentas,

    SAFE_CAST(
      REPLACE(REPLACE(nro_total_cta_ahorros_electronicas, '.', ''), ',', '')
    AS INT64) AS nro_cuentas_electronicas,

    SAFE_CAST(
      REPLACE(REPLACE(REPLACE(saldo_total_cta_ahorros_electronicas, '$', ''), '.', ''), ',', '.')
    AS FLOAT64) AS saldo_cuentas_electronicas

  FROM `personal-projects-497114.inclusion_financiera_colombia.datos_colombia`
  WHERE departamento IS NOT NULL
    AND departamento != 'DEPARTAMENTO'
),

FiltroLimpieza AS (
  SELECT *
  FROM BaseAdopcion
  WHERE departamento NOT LIKE 'TOTAL %'
    AND departamento != 'TOTAL NACIONAL'
    AND municipio NOT LIKE 'TOTAL %'
    AND municipio NOT LIKE 'DEP%SITO%'
    AND municipio NOT LIKE 'DEP%NERO%'
    AND municipio NOT LIKE 'M%VILRED'
    AND municipio NOT LIKE 'V%A BALOTO'
    AND municipio NOT LIKE 'CUENTAS %'
    AND municipio NOT LIKE 'TRANSFERENCIAS %'
    AND municipio NOT LIKE 'ACT ARTIST%'
    AND municipio NOT LIKE 'ESTABLECIMIENTOS DE CR%'
    AND municipio NOT IN (
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
)

SELECT
  fecha_de_corte,
  EXTRACT(YEAR FROM fecha_de_corte) AS anio,
  departamento,
  municipio,
  CONCAT(municipio, ', Colombia') AS municipio_geo,
  SUM(nro_total_cuentas)          AS total_cuentas,
  SUM(saldo_total_cuentas)        AS saldo_total,
  SUM(nro_cuentas_electronicas)   AS total_digitales,
  SUM(saldo_cuentas_electronicas) AS saldo_digitales,
  ROUND(
    SAFE_DIVIDE(SUM(nro_cuentas_electronicas), SUM(nro_total_cuentas)) * 100, 2
  ) AS pct_adopcion_usuarios,
  ROUND(
    SAFE_DIVIDE(SUM(saldo_cuentas_electronicas), SUM(saldo_total_cuentas)) * 100, 2
  ) AS pct_participacion_capital

FROM FiltroLimpieza
GROUP BY 1, 2, 3, 4, 5;
