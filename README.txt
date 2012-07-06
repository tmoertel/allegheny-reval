README

Tom Moertel <tom@moertel.org>
July 2012


This repository contains data sets relating to the 2012/2013
reassessment of properties in Allegheny County, Pennsylvania.  The
following data sets are included:

* Assessed values of all properties, before and after the reassessment
  (Source: Allegheny County Office of Property Assessments)

* Sales history for all properties
  (Source: Allegheny County Office of Property Assessments)

* Property characteristics for properties
  (Source: Allegheny County Office of Property Assessments)

* Recent sales history for residential properties
  (Source: Pittsburgh Neighborhood and Community Information System
  at the University Center for Social and Urban Research
  http://www.ucsur.pitt.edu/thepub.php?pl=370)


ACKNOWLEDGMENTS

I would like to thank Jeremy Boren at the Pittsburgh Tribune-Review
for obtaining the first three data sets.


REQUIREMENTS

To run the analyses in this project, you will need a Unix-like
operating system (e.g., Linux or Mac OS X) and the following software:

* The R statistical computing system
  http://www.r-project.org/

* The following R packages:
  - ggplot2
  - lubridate
  - plyr
  - reshape2
  - RSQLite
  - scales

* GNU Make (probably already installed on your computer)
  http://www.gnu.org/software/make/


WHAT'S IN THE BOX?

The main contribution of this effort is a SQLite3 database that
combines the data sets mentioned earlier and augments them with
metadata tables that represent knowledge of tax districts and their
taxing formulas.  These can be used to compute estimates of
interesting quantities, such as property-level tax effects due to the
reassessment.  The database also contains views that compute, on the
fly, some of these estimates.

Here's a quick overview of the tables in the database:

  Tax districts

  tds                  -- tax districts (sd or muni)
  sds                  -- school districts
  muni_tds             -- municipal tax districts
  muni_td_wards        -- wards into which municipalites are partitioned

  Properties and assessed values

  reval                -- before/after property assessments
  bldg                 -- property characteristics
  opa_sales            -- historical property sales
  ucsur_sales          -- recent residential property sales

  Computed estimates

  county_reval (view)  -- county-level assessment effects on properties
  sd_reval (view)      -- sd-level assessment effects on properties
  muni_td_reval (view) -- muni-level assessment effects on properties
  td_ptx (view)        -- est. property taxes for each td for each property
  ptx (view)           -- est. total property taxes due for each property


BUILDING THE DATABASE

If you downloaded the Git source-code repository for this project,
you can build the database from the raw data sources in the project
by issuing the "make" command from the project's root directory.
(The process may take several minutes, the time depending on
your computer and its disk characteristics.)  A quicker strategy
would be to obtain a compressed copy of the database (about 150 MB).


EXAMPLES

To find Mt. Lebanon's taxing districts:

  $ sqlite3 data/reval.db
  SQLite version 3.7.7.1 2011-06-28 17:39:05
  Enter ".help" for instructions
  Enter SQL statements terminated with a ";"

  sqlite> .mode line
  sqlite> select * from tds where name like '%lebanon%';

                 kind = SD
                 name = Mt Lebanon
            bldg_rate = 26.63
            land_rate = 26.63
           total_rate = 0.0
  homestead_exclusion = 0.0
        rel_asm_total = 1.29856741047805

                 kind = Muni
                 name = MT. LEBANON
            bldg_rate = 5.43
            land_rate = 5.43
           total_rate = 0.0
  homestead_exclusion = 0.0
        rel_asm_total = 1.29856741047805

Because some districts tax the land and building value of properties
at different rates, the land_rate and bldg_rate are given separately.
For districts that use the same rate for both, these can be set to
zero and the single rate given in the total_rate field instead:

  sqlite> select * from tds where kind = 'County';
                 kind = County
                 name = Allegheny
            bldg_rate = 0.0
            land_rate = 0.0
           total_rate = 5.69
  homestead_exclusion = 15000.0
        rel_asm_total = 1.37529504829668

Also, note that, if a taxing district supports the homestead
exclusion, the exclusion amount will be given, as well.

To see how these rules work out, here are the estimated taxes due
for property 0001C00037000000.  First, for each taxing district
separately:

  sqlite> select * from td_ptx where PIN = '0001C00037000000';

      PIN = 0001C00037000000
     kind = County
     name = Allegheny
  Tax2013 = 51581.7133842374
  Tax2012 = 71125.0

      PIN = 0001C00037000000
     kind = SD
     name = City Of Pittsburgh
  Tax2013 = 112637.429193824
  Tax2012 = 174000.0

      PIN = 0001C00037000000
     kind = Muni
     name = PITTSBURGH
  Tax2013 = 87270.6737220187
  Tax2012 = 135000.0

And, now, the property's total for all taxing districts:

  sqlite> select * from ptx where PIN = '0001C00037000000';

      PIN = 0001C00037000000
  Tax2013 = 251489.81630008
  Tax2012 = 380125.0
  ptx_rel = 0.66159767523862

For this property, then, the reassessment had the effect of lowering
property taxes by a third:

  sqlite> select Tax2013 / Tax2012 - 1 as ptx_inc
     ...> from ptx where PIN = '0001C00037000000';

  ptx_inc = -0.33840232476138

Note that this fact is also given by the ptx_rel value for the property,
which represents the 2013 tax burden relative to the 2012 burden.  For
this property, it's 66% (= two thirds).


QUESTIONS

If you have any questions about these data or analyses, please
direct them to Tom Moertel <tom@moertel.org>.
