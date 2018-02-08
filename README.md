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
$ pip install awscli

$ aws configure
> AWS Access Key ID: <enter your key>
> AWS Secret Access Key: <enter your secret>
> Default region name: us-east-1
> Default output format: <leave blank>
```

After this, start R, and:

```R
if(!require(remotes)) {
  install.packages("remotes")
}

remotes::install_github("datacamp/dbconnectr")
remotes::install_github("r-dbi/RMySQL") # for MySQL databases
remotes::install_github("r-dbi/RPostgres") # for PostgreSQL databases
```

## How to use

**For security reasons, we only allow DB connections from our VPN.**

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

To avoid the (time costly) fetching of credentials to AWS every time, `dbconnectr` allows you to cache the credentials on your local machine:

```R
library(dbconnectr)

# First time is slow
conn <- create_connection("main-app", cache = TRUE)

# Second time is fast
conn <- create_connection("main-app", cache = TRUE)
```

## Use in RStudio

The `aws` executable will not be found when you're working in RStudio (because the `PATH` is not properly set). To fix this, open up a terminal to find out the location of the `aws` executable:

```bash
$ which aws
/Library/Frameworks/Python.framework/Versions/3.6/bin
```

Next, create a file `~/.Renviron` that adds this `bin` folder to the `PATH`, e.g.:

```bash
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
```

_Note that the exact location of the `aws` executable can be different on your system, depending on how you installed the AWS CLI._ Now, if you start RStudio and your R session initializes, the folder that contains the `aws` executable will be in your `PATH`, and you should be able to call `aws` commands:

```
> system2("aws", args = "--version")
aws-cli/1.14.32 Python/3.6.4 Darwin/17.3.0 botocore/1.8.36
```

## AWS Parameter Store Structure

See [README of dbconnect-python project](https://github.com/datacamp/dbconnect-python#aws-parameter-store-structure).

