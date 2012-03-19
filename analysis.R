library(RSQLite)
library(ggplot2)
library(scales)
library(plyr)
library(reshape2)
library(lubridate)

conn <- dbConnect(dbDriver("SQLite"), dbname = "data/reval.db")

dbListTables(conn)

sales <-
  dbGetQuery(conn, "
    SELECT
      SALEDATE,
      SALEPRICE
    FROM
      sales
    WHERE
      SALECODE = '0'  /* = valid sale */
    ")

sales <- mutate(sales,
                SALEDATE = mdy(SALEDATE),
                YEAR = (SALEDATE - min(SALEDATE)) / dyears(1))

sales_ts <- subset(sales, SALEPRICE > 1000 & SALEDATE > ymd("1998-01-01"))

qplot(SALEDATE, SALEPRICE, geom = c("point", "smooth"), log = "y",
      data = sales_ts)

p <-
qplot(SALEDATE, SALEPRICE, geom = c("point", "smooth"), log = "y",
      data = subset(sales, SALEPRICE > 1000 & SALEDATE > ymd("1970-01-01")))
p <- p + scale_y_log10(labels = dollar)
p <- p + opts(title = "OPA RE Sales (Since 1970)")
p <- p + labs(x = "Sale date", y = "Sale price (log scale)")
p

ggsave(p, file = "/tmp/opasales.png", width = 7, height = 5)


(m1 <- lm(log(SALEPRICE) ~ YEAR, data = sales_ts))

(m2 <- lm(log(SALEPRICE) ~ SALEDATE,
          data = subset(sales_ts, SALEDATE > ymd("2000-01-1"))))

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
