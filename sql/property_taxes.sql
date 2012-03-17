/* COMPUTE PROPERTY TAXES */


/* compute old and new propery taxes for each property for each tax district */

CREATE VIEW td_ptx AS
SELECT
  PIN,
  tds.kind,
  tds.name,
  (
    bldg_rate * Building2013 +
    land_rate * Land2013 +
    total_rate * MAX(0, Total2013 - (HomesteadFlag='C') * homestead_exclusion)
    ) / 1000 / tds.rel_asm_total AS Tax2013,
  (
    bldg_rate * Building2012 +
    land_rate * Land2012 +
    total_rate * MAX(0, Total2012 - (HomesteadFlag='C') * homestead_exclusion)
    ) / 1000 AS Tax2012
FROM
  reval JOIN muni_td_wards USING (Municode) JOIN tds ON (
    (tds.kind = 'County') OR
    (tds.kind = 'SD'   AND tds.name = reval.SchoolDesc) OR
    (tds.kind = 'Muni' AND tds.name = muni_td_wards.TaxDistrict)
  )
WHERE
  TaxDesc = 'Taxable'
;


/* compute overall old and new property taxes for each property */

CREATE VIEW ptx AS
SELECT
  PIN,
  SUM(Tax2013) AS Tax2013,
  SUM(Tax2012) AS Tax2012,
  SUM(Tax2013) / SUM(Tax2012) AS ptx_rel
FROM
  td_ptx
GROUP BY
  PIN
;
