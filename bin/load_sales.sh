#!/bin/bash
#
# Load the sales data into a SQLite database for convenient analysis


## The following data sets have duplicate entries for some sales.  To
## clean them, we first load each data set into a temporary table in
## which each row has been annotated with its data length (see Perl
## magic at end of script).  Then we find the duplicate sales entries
## and keep the one entry for each sale that is the most descriptive.
## (Usually, the duplicate entries are missing fields.)



load() {
sqlite3 data/reval.db <<EOF

PRAGMA foreign_keys = ON;

/* OPA sales data */

CREATE TEMPORARY TABLE opa_sales_load (
    ID   INT PRIMARY KEY  NOT NULL
  , PIN                   NOT NULL
  , PROPERTYOWNER         NOT NULL
  , PROPERTYHOUSENUM      NOT NULL
  , PROPERTYFRACTION      NOT NULL
  , PROPERTYADDRESS       NOT NULL
  , PROPERTYCITY          NOT NULL
  , PROPERTYSTATE         NOT NULL
  , PROPERTYUNIT          NOT NULL
  , PROPERTYLOCATION2     NOT NULL
  , PROPERTYZIP           NOT NULL
  , MUNICODE              NOT NULL
  , MUNIDESC              NOT NULL
  , SCHOOLCODE            NOT NULL
  , SCHOOLDESC            NOT NULL
  , NEIGHCODE             NOT NULL
  , NEIGHDESC             NOT NULL
  , TAXCODE               NOT NULL
  , TAXDESC               NOT NULL
  , OWNERCODE             NOT NULL
  , OWNERDESC             NOT NULL
  , STATECODE             NOT NULL
  , STATEDESC             NOT NULL
  , USECODE               NOT NULL
  , USEDESC               NOT NULL
  , LOTAREA               NOT NULL
  , HOMESTEADFLAG         NOT NULL
  , FARMSTEADFLAG         NOT NULL
  , SALEDATE              NOT NULL
  , SALEPRICE  REAL       NOT NULL
  , SALECODE              NOT NULL
  , SALEDESC              NOT NULL
  , DEEDBOOK              NOT NULL
  , DEEDPAGE              NOT NULL
  , MABT                  NOT NULL
  , AGENT                 NOT NULL
  , TAXFULLADDRESS1       NOT NULL
  , TAXFULLADDRESS2       NOT NULL
  , TAXFULLADDRESS3       NOT NULL
  , TAXFULLADDRESS4       NOT NULL
  , CHANGENOTICEADDRESS1  NOT NULL
  , CHANGENOTICEADDRESS2  NOT NULL
  , CHANGENOTICEADDRESS3  NOT NULL
  , CHANGENOTICEADDRESS4  NOT NULL
  , COUNTYBUILDING        NOT NULL
  , COUNTYLAND            NOT NULL
  , COUNTYTOTAL           NOT NULL
  , COUNTYEXEMPTBLDG      NOT NULL
  , LOCALBUILDING         NOT NULL
  , LOCALLAND             NOT NULL
  , LOCALTOTAL            NOT NULL
  , FAIRMARKETBUILDING    NOT NULL
  , FAIRMARKETLAND        NOT NULL
  , FAIRMARKETTOTAL       NOT NULL
  , STYLE                 NOT NULL
  , STYLEDESC             NOT NULL
  , STORIES               NOT NULL
  , YEARBLT               NOT NULL
  , EXTERIORFINISH        NOT NULL
  , EXTFINISH_DESC        NOT NULL
  , ROOF                  NOT NULL
  , ROOFDESC              NOT NULL
  , BASEMENT              NOT NULL
  , BASEMENTDESC          NOT NULL
  , GRADE                 NOT NULL
  , GRADEDESC             NOT NULL
  , CONDITION             NOT NULL
  , CONDITIONDESC         NOT NULL
  , TOTALROOMS            NOT NULL
  , BEDROOMS              NOT NULL
  , FULLBATHS             NOT NULL
  , HALFBATHS             NOT NULL
  , HEATINGCOOLING        NOT NULL
  , HEATINGCOOLINGDESC    NOT NULL
  , FIREPLACES            NOT NULL
  , ATTACHEDGARAGES       NOT NULL
  , FINISHEDLIVINGAREA    NOT NULL
  , CARDNUMBER            NOT NULL
  , ALT_ID                NOT NULL
  , TAXSUBCODE_DESC       NOT NULL
  , TAXSUBCODE            NOT NULL
  , len    INTEGER        NOT NULL
);

.separator |
.import $1 opa_sales_load

CREATE TABLE opa_sales (
    PIN                   NOT NULL
  , PROPERTYOWNER         NOT NULL
  , PROPERTYHOUSENUM      NOT NULL
  , PROPERTYFRACTION      NOT NULL
  , PROPERTYADDRESS       NOT NULL
  , PROPERTYCITY          NOT NULL
  , PROPERTYSTATE         NOT NULL
  , PROPERTYUNIT          NOT NULL
  , PROPERTYLOCATION2     NOT NULL
  , PROPERTYZIP           NOT NULL
  , MUNICODE              NOT NULL
  , MUNIDESC              NOT NULL
  , SCHOOLCODE            NOT NULL
  , SCHOOLDESC            NOT NULL
  , NEIGHCODE             NOT NULL
  , NEIGHDESC             NOT NULL
  , TAXCODE               NOT NULL
  , TAXDESC               NOT NULL
  , OWNERCODE             NOT NULL
  , OWNERDESC             NOT NULL
  , STATECODE             NOT NULL
  , STATEDESC             NOT NULL
  , USECODE               NOT NULL
  , USEDESC               NOT NULL
  , LOTAREA               NOT NULL
  , HOMESTEADFLAG         NOT NULL
  , FARMSTEADFLAG         NOT NULL
  , SALEDATE              NOT NULL
  , SALEPRICE  REAL       NOT NULL
  , SALECODE              NOT NULL
  , SALEDESC              NOT NULL
  , DEEDBOOK              NOT NULL
  , DEEDPAGE              NOT NULL
  , MABT                  NOT NULL
  , AGENT                 NOT NULL
  , TAXFULLADDRESS1       NOT NULL
  , TAXFULLADDRESS2       NOT NULL
  , TAXFULLADDRESS3       NOT NULL
  , TAXFULLADDRESS4       NOT NULL
  , CHANGENOTICEADDRESS1  NOT NULL
  , CHANGENOTICEADDRESS2  NOT NULL
  , CHANGENOTICEADDRESS3  NOT NULL
  , CHANGENOTICEADDRESS4  NOT NULL
  , COUNTYBUILDING        NOT NULL
  , COUNTYLAND            NOT NULL
  , COUNTYTOTAL           NOT NULL
  , COUNTYEXEMPTBLDG      NOT NULL
  , LOCALBUILDING         NOT NULL
  , LOCALLAND             NOT NULL
  , LOCALTOTAL            NOT NULL
  , FAIRMARKETBUILDING    NOT NULL
  , FAIRMARKETLAND        NOT NULL
  , FAIRMARKETTOTAL       NOT NULL
  , STYLE                 NOT NULL
  , STYLEDESC             NOT NULL
  , STORIES               NOT NULL
  , YEARBLT               NOT NULL
  , EXTERIORFINISH        NOT NULL
  , EXTFINISH_DESC        NOT NULL
  , ROOF                  NOT NULL
  , ROOFDESC              NOT NULL
  , BASEMENT              NOT NULL
  , BASEMENTDESC          NOT NULL
  , GRADE                 NOT NULL
  , GRADEDESC             NOT NULL
  , CONDITION             NOT NULL
  , CONDITIONDESC         NOT NULL
  , TOTALROOMS            NOT NULL
  , BEDROOMS              NOT NULL
  , FULLBATHS             NOT NULL
  , HALFBATHS             NOT NULL
  , HEATINGCOOLING        NOT NULL
  , HEATINGCOOLINGDESC    NOT NULL
  , FIREPLACES            NOT NULL
  , ATTACHEDGARAGES       NOT NULL
  , FINISHEDLIVINGAREA    NOT NULL
  , CARDNUMBER            NOT NULL
  , ALT_ID                NOT NULL
  , TAXSUBCODE_DESC       NOT NULL
  , TAXSUBCODE            NOT NULL
  , PRIMARY KEY (PIN, SALEDATE, SALEPRICE)
);

INSERT INTO opa_sales
SELECT
    PIN
  , PROPERTYOWNER
  , PROPERTYHOUSENUM
  , PROPERTYFRACTION
  , PROPERTYADDRESS
  , PROPERTYCITY
  , PROPERTYSTATE
  , PROPERTYUNIT
  , PROPERTYLOCATION2
  , PROPERTYZIP
  , MUNICODE
  , MUNIDESC
  , SCHOOLCODE
  , SCHOOLDESC
  , NEIGHCODE
  , NEIGHDESC
  , TAXCODE
  , TAXDESC
  , OWNERCODE
  , OWNERDESC
  , STATECODE
  , STATEDESC
  , USECODE
  , USEDESC
  , LOTAREA
  , HOMESTEADFLAG
  , FARMSTEADFLAG
  , SALEDATE
  , SALEPRICE
  , SALECODE
  , SALEDESC
  , DEEDBOOK
  , DEEDPAGE
  , MABT
  , AGENT
  , TAXFULLADDRESS1
  , TAXFULLADDRESS2
  , TAXFULLADDRESS3
  , TAXFULLADDRESS4
  , CHANGENOTICEADDRESS1
  , CHANGENOTICEADDRESS2
  , CHANGENOTICEADDRESS3
  , CHANGENOTICEADDRESS4
  , COUNTYBUILDING
  , COUNTYLAND
  , COUNTYTOTAL
  , COUNTYEXEMPTBLDG
  , LOCALBUILDING
  , LOCALLAND
  , LOCALTOTAL
  , FAIRMARKETBUILDING
  , FAIRMARKETLAND
  , FAIRMARKETTOTAL
  , STYLE
  , STYLEDESC
  , STORIES
  , YEARBLT
  , EXTERIORFINISH
  , EXTFINISH_DESC
  , ROOF
  , ROOFDESC
  , BASEMENT
  , BASEMENTDESC
  , GRADE
  , GRADEDESC
  , CONDITION
  , CONDITIONDESC
  , TOTALROOMS
  , BEDROOMS
  , FULLBATHS
  , HALFBATHS
  , HEATINGCOOLING
  , HEATINGCOOLINGDESC
  , FIREPLACES
  , ATTACHEDGARAGES
  , FINISHEDLIVINGAREA
  , CARDNUMBER
  , ALT_ID
  , TAXSUBCODE_DESC
  , TAXSUBCODE
FROM
  opa_sales_load
WHERE
  ID IN (
    SELECT ID
    FROM
    (
      SELECT PIN, SALEDATE, SALEPRICE, MAX(len) AS len
      FROM opa_sales_load
      GROUP BY 1, 2, 3
    ) AS a
    NATURAL JOIN
    (
      SELECT PIN, SALEDATE, SALEPRICE, len, MIN(ID) AS ID
      FROM opa_sales_load
      GROUP BY 1, 2, 3
    ) AS b
  )
;



/* UCSUR sales data

Courtesy of the Pittsburgh Neighborhood and Community Information
System at the University Center for Social and Urban Research:
http://www.ucsur.pitt.edu/thepub.php?pl=370)

*/

CREATE TEMPORARY TABLE ucsur_sales_load (
    ID INTEGER PRIMARY KEY NOT NULL
  , PIN               NOT NULL
  , PROPERTYHOUSENUM  NOT NULL
  , PROPERTYFRACTION  NOT NULL
  , PROPERTYADDRESS   NOT NULL
  , PROPERTYCITYSTATE NOT NULL
  , PROPERTYUNIT      NOT NULL
  , PROPERTYZIP       NOT NULL
  , SALEDATE          NOT NULL
  , SALEPRICE  REAL   NOT NULL
  , MUNICODE          NOT NULL
  , MUNDESC           NOT NULL
  , X                 NOT NULL
  , Y                 NOT NULL
  , USECODE           NOT NULL
  , USEDESC           NOT NULL
  , YEARBUILT         NOT NULL
  , TOTALROOMS        NOT NULL
  , BEDROOMS          NOT NULL
  , FULLBATHS         NOT NULL
  , HALFBATHS         NOT NULL
  , STYLE_DESC        NOT NULL
  , STORIES           NOT NULL
  , FINISHEDLI        NOT NULL
  , GARAGE            NOT NULL
  , len       INTEGER NOT NULL
);

.import $2 ucsur_sales_load

CREATE TABLE ucsur_sales (
    PIN               NOT NULL
  , PROPERTYHOUSENUM  NOT NULL
  , PROPERTYFRACTION  NOT NULL
  , PROPERTYADDRESS   NOT NULL
  , PROPERTYCITYSTATE NOT NULL
  , PROPERTYUNIT      NOT NULL
  , PROPERTYZIP       NOT NULL
  , SALEDATE          NOT NULL
  , SALEPRICE  REAL   NOT NULL
  , MUNICODE          NOT NULL
  , MUNDESC           NOT NULL
  , X                 NOT NULL
  , Y                 NOT NULL
  , USECODE           NOT NULL
  , USEDESC           NOT NULL
  , YEARBUILT         NOT NULL
  , TOTALROOMS        NOT NULL
  , BEDROOMS          NOT NULL
  , FULLBATHS         NOT NULL
  , HALFBATHS         NOT NULL
  , STYLE_DESC        NOT NULL
  , STORIES           NOT NULL
  , FINISHEDLI        NOT NULL
  , GARAGE            NOT NULL
  , PRIMARY KEY (PIN, SALEDATE, SALEPRICE)
);

INSERT INTO ucsur_sales
SELECT
    PIN
  , PROPERTYHOUSENUM
  , PROPERTYFRACTION
  , PROPERTYADDRESS
  , PROPERTYCITYSTATE
  , PROPERTYUNIT
  , PROPERTYZIP
  , SALEDATE
  , SALEPRICE
  , MUNICODE
  , MUNDESC
  , X
  , Y
  , USECODE
  , USEDESC
  , YEARBUILT
  , TOTALROOMS
  , BEDROOMS
  , FULLBATHS
  , HALFBATHS
  , STYLE_DESC
  , STORIES
  , FINISHEDLI
  , GARAGE
FROM
  ucsur_sales_load
WHERE
  ID IN (
    SELECT ID
    FROM
    (
      SELECT PIN, SALEDATE, SALEPRICE, MAX(len) AS len
      FROM ucsur_sales_load
      GROUP BY 1, 2, 3
    ) AS a
    NATURAL JOIN
    (
      SELECT PIN, SALEDATE, SALEPRICE, len, MIN(ID) AS ID
      FROM ucsur_sales_load
      GROUP BY 1, 2, 3
    ) AS b
  )
;


EOF
}


# the following trick strips the header line from the CSV files we're importing

load \
     \
  <(tail -n +2 data/opa_sales.psv       \
    | perl -lpe '$_ .= "|" . length')   \
                                        \
  <(tail -n +2 data/ucsur_sales.psv     \
    | perl -lpe '$_ .= "|" . length'    \
    | nl -s '|')
