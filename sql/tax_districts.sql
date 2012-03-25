/* CONSTRUCT MASTER TABLE OF TAX DISTRICTS */

CREATE TABLE tds (

  kind NOT NULL,
  name NOT NULL,

  /* supply total_rate OR both bldg_rate and land_rate */
  bldg_rate REAL NOT NULL,
  land_rate REAL NOT NULL,
  total_rate REAL NOT NULL,

  homestead_exclusion REAL NOT NULL,
  rel_asm_total REAL NOT NULL,
  PRIMARY KEY (kind, name)
);


/* school districts */

INSERT INTO tds
SELECT
  'SD'               AS kind,
  SchoolDesc         AS name,
  Bldg_Millage_2011  AS bldg_rate,
  Land_Millage_2011  AS land_rate,
  0                  AS total_rate,
  0                  AS homestead_exclusion,
  rel_asm_total
FROM
  sds NATURAL JOIN sd_reval
;


/* municipalities */

INSERT INTO tds
SELECT
  'Muni'             AS kind,
  TaxDistrict        AS name,
  Bldg_Millage_2012  AS bldg_rate,
  Land_Millage_2012  AS land_rate,
  0                  AS total_rate,
  0                  AS homestead_exclusion,
  rel_asm_total
FROM
  muni_tds NATURAL JOIN muni_td_reval
;


/* county */

CREATE VIEW county_reval AS
SELECT
  PIN,
  MAX(0, Total2012 - (HomesteadFlag = 'C') * 15000) AS Total2012_county,
  MAX(0, Total2013 - (HomesteadFlag = 'C') * 15000) AS Total2013_county
FROM
  reval
WHERE
  TaxDesc = 'Taxable' AND
  Total2013 >= 0  /* skip 18 properties assessed < $0, totaling -$182,900 */
;

INSERT INTO tds
SELECT
  'County'     AS kind,
  'Allegheny'  AS name,
  0            AS bldg_rate,
  0            AS land_rate,
  5.69         AS total_rate,
  15000        AS homestead_exclusion,
  (SELECT SUM(Total2013_county) / SUM(Total2012_county) FROM county_reval)
               AS rel_asm_total
;
