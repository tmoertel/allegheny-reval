library(RSQLite)

conn <- dbConnect(dbDriver("SQLite"), dbname = "reval.db")

dbListTables(conn)


muni_revals <-
  dbGetQuery(conn, "
    SELECT
      MuniDesc AS muni_name,
      (0.0 + SUM(Total2013)) / SUM(Total2012) AS rel_asm
    FROM
      reval
    WHERE
      TaxDesc = 'Taxable'
    GROUP BY
      muni_name
    ORDER BY
      rel_asm DESC
    ")

sd_revals <-
  dbGetQuery(conn, "
    SELECT
      SchoolDesc AS sd_name,
      (0.0 + SUM(Total2013)) / SUM(Total2012) AS rel_asm
    FROM
      reval
    WHERE
      TaxDesc = 'Taxable'
    GROUP BY
      sd_name
    ORDER BY
      rel_asm DESC
    ")


## need homestead/farmstead exclusion here
county_reval <-
  dbGetQuery(conn, "
    SELECT
      (0.0 + SUM(Total2013)) / SUM(Total2012) AS rel_asm
    FROM
      reval
    WHERE
      TaxDesc = 'Taxable'
    ")


options(digits = 3)

muni_revals

sd_revals
