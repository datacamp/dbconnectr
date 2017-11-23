# dbconnectr

[![Build Status](https://api.travis-ci.org/datacamp/dbconnectr.svg?branch=master)](https://travis-ci.org/datacamp/dbconnectr)

### Why use this module?

- Make it easy to discover new databases at DataCamp
- Allow us to rotate DB credentials, without anyone having to update their scripts
- Make it easy to open the documentation of a database
- Allow fine-grained access permissions by using the AWS Key and Secrets for each client.

## Installation

Make sure to ask the IDE team for your AWS Key and Secret.

```bash
pip install awscli

aws configure
> AWS Access Key ID: <enter your key>
> AWS Secret Access Key: <enter your secret>
> Default region name: us-east-1
> Default output format: <leave blank>
```

After this, start R, and:

```R
if(!require(devtools)) {
  install.packages("devtools")
}
devtools::install_github("datacamp/dbconnectr")

install.packages("RMySQL") # for MySQL databases
install.packages("RPostgres") # for RPostgres databases
```

## How to use

**For security reasons, we only allow DB connections from our VPN. Make sure to be connected when using this module.**

```R
library(dbconnectr)

# List all available databases
get_databases()

# Get DBI connection to specific database
conn <- create_connection("main-app")

# Use DBI connection like you normally do
library(DBI)
dbListTables(conn)

# Visit the database documentation
get_docs("main-app")
```

## AWS Parameter Store Structure

See [README of dbconnect-python project](https://github.com/datacamp/dbconnect-python#aws-parameter-store-structure)

