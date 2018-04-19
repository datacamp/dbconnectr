# dbconnectr 0.0.5

* Offer redshift as an alternative, using the Postgres driver
* DBI is now in DEPENDS rather than IMPORTS
* Allow passing ... to `create_connection` (and `create_connection_pool`) to pass additional parameters to `dbConnect` (or to `dbPool`).

# dbconnectr 0.0.4

* Added a `NEWS.md` file to track changes to the package.
* Switched from RMySQL (no longer supported) to RMariaDB
* Moved driver packages from Suggests to Imports so that they no longer have to be installed separately (all are on CRAN)
* Added support for Amazon AWS Athena, which takes on the odbc package as a dependency. (It requires the Simba Athena ODBC driver to be installed)
