#!/bin/bash
#
# Load the data files into a SQLite database for convenient analysis

sqlite3 data/reval.db <<EOF

CREATE TABLE sds (
    SchoolDesc text PRIMARY KEY NOT NULL
  , Bldg_Millage_2011 NOT NULL
  , Land_Millage_2011 NOT NULL
  , Correx_Name NOT NULL
);

.separator ,
.import data/sd_tax_districts.csv sds
DELETE FROM sds WHERE SchoolDesc = 'SchoolDesc';
UPDATE sds
  SET Land_Millage_2011 = Bldg_Millage_2011
  WHERE Land_Millage_2011 = '';


CREATE TABLE muni_tds (
    TaxDistrict text PRIMARY KEY NOT NULL
  , Bldg_Millage_2012 NOT NULL
  , Land_Millage_2012 NOT NULL
);

.import data/muni_tax_districts.csv muni_tds
DELETE FROM muni_tds WHERE TaxDistrict = 'TaxDistrict';
UPDATE muni_tds
  SET Land_Millage_2012 = Bldg_Millage_2012
  WHERE Land_Millage_2012 = '';

CREATE TABLE muni_td_wards (
    TaxDistrict NOT NULL REFERENCES muni_tds (TaxDistrict)
  , Municode NOT NULL
  , MuniDesc NOT NULL
  , PRIMARY KEY (TaxDistrict, Municode, MuniDesc)
);

.import data/muni_tax_district_wards.csv muni_td_wards
DELETE FROM muni_td_wards WHERE TaxDistrict = 'TaxDistrict';


CREATE TABLE reval (
    PIN text PRIMARY KEY NOT NULL
  , PropertyOwner NOT NULL
  , PropertyHouseNumber NOT NULL
  , PropertyFraction NOT NULL
  , PropertyAddress NOT NULL
  , PropertyCityState NOT NULL
  , PropertyUnit NOT NULL
  , PropertyZip NOT NULL
  , Municode NOT NULL REFERENCES muni_td_wards(Municode)
  , MuniDesc NOT NULL
  , SchoolDesc NOT NULL REFERENCES sd_tds(SchoolDesc)
  , OwnerDesc NOT NULL
  , HomesteadFlag NOT NULL
  , FarmsteadFlag NOT NULL
  , SaleDate NOT NULL
  , SalePrice NOT NULL
  , DeedBook NOT NULL
  , DeedPage NOT NULL
  , MultipleAbatement NOT NULL
  , TaxBillFullAddress NOT NULL
  , TaxBillFullAddress2 NOT NULL
  , TaxBillFullAddressCityStateZip NOT NULL
  , TaxBillFullAddress3 NOT NULL
  , ChangeNoticeAddress NOT NULL
  , ChangeNoticeCityStateZip NOT NULL
  , Building2012 NOT NULL
  , Land2012 NOT NULL
  , Total2012 NOT NULL
  , Building2013 NOT NULL
  , Land2013 NOT NULL
  , Total2013 NOT NULL
  , TaxDesc NOT NULL
  , AgentName NOT NULL
  , StateDesc NOT NULL
  , UseDesc NOT NULL
  , NeighDesc NOT NULL
  , LotArea NOT NULL
);

.separator |
.import data/reval_geninfo.psv reval
DELETE FROM reval WHERE PIN = 'PIN';


CREATE VIEW muni_td_reval AS
SELECT
  TaxDistrict,
  SUM(Building2012) AS Building2012,
  SUM(Land2012)     AS Land2012,
  SUM(Total2012)    AS Total2012,
  SUM(Building2013) AS Building2013,
  SUM(Land2013)     AS Land2013,
  SUM(Total2013)    AS Total2013,
  (0.0 + SUM(Building2013)) / SUM(Building2012) AS rel_asm_bldg,
  (0.0 + SUM(Land2013))     / SUM(Land2012)     AS rel_asm_land,
  (0.0 + SUM(Total2013))    / SUM(Total2012)    AS rel_asm_total
FROM
  muni_tds NATURAL JOIN
  muni_td_wards JOIN
  reval USING (Municode)
WHERE
  TaxDesc = 'Taxable'
GROUP BY
  TaxDistrict
;



CREATE VIEW sd_reval AS
SELECT
  SchoolDesc,
  SUM(Building2012) AS Building2012,
  SUM(Land2012)     AS Land2012,
  SUM(Total2012)    AS Total2012,
  SUM(Building2013) AS Building2013,
  SUM(Land2013)     AS Land2013,
  SUM(Total2013)    AS Total2013,
  (0.0 + SUM(Building2013)) / SUM(Building2012) AS rel_asm_bldg,
  (0.0 + SUM(Land2013))     / SUM(Land2012)     AS rel_asm_land,
  (0.0 + SUM(Total2013))    / SUM(Total2012)    AS rel_asm_total
FROM
  sds NATURAL JOIN
  reval
WHERE
  TaxDesc = 'Taxable'
GROUP BY
  SchoolDesc
;

EOF
