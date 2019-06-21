# dbconnectr 0.0.6.9000

* Added profile and region arguments to create_connection, which are then given to AWS when fetching the parameters.

# dbconnectr 0.0.6

* Set David Robinson as maintainer
* Turn slashes into hyphens when saving a connection cache file (supports tiered access, in which parameters can contain "/")
* Changed `get_creds` to get all parameters from AWS in one query

# dbconnectr 0.0.5

* Offer redshift as an alternative, using the Postgres driver
* DBI is now in DEPENDS rather than IMPORTS
* Allow passing ... to `create_connection` (and `create_connection_pool`) to pass additional parameters to `dbConnect` (or to `dbPool`).

# dbconnectr 0.0.4

* Added a `NEWS.md` file to track changes to the package.
* Switched from RMySQL (no longer supported) to RMariaDB
* Moved driver packages from Suggests to Imports so that they no longer have to be installed separately (all are on CRAN)
* Added support for Amazon AWS Athena, which takes on the odbc package as a dependency. (It requires the Simba Athena ODBC driver to be installed)
