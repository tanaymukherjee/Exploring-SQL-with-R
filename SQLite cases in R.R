# SQLite

# 1. SQL (local)
library(RSQLite)
sqlitePath <- "/path/to/sqlite/database"
table <- "responses"

saveData <- function(data) {
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  # Construct the update query by looping over the data fields
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    table, 
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  # Submit the update query and disconnect
  dbGetQuery(db, query)
  dbDisconnect(db)
}

loadData <- function() {
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", table)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}


# 2. MySQL (local or remote)
library(RMySQL)

options(mysql = list(
  "host" = "127.0.0.1",
  "port" = 3306,
  "user" = "myuser",
  "password" = "mypassword"
))
databaseName <- "myshinydatabase"
table <- "responses"

saveData <- function(data) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
                  port = options()$mysql$port, user = options()$mysql$user, 
                  password = options()$mysql$password)
  # Construct the update query by looping over the data fields
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    table, 
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  # Submit the update query and disconnect
  dbGetQuery(db, query)
  dbDisconnect(db)
}

loadData <- function() {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
                  port = options()$mysql$port, user = options()$mysql$user, 
                  password = options()$mysql$password)
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", table)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}


# 3. Google Sheets (remote)
library(googlesheets)

table <- "responses"

saveData <- function(data) {
  # Grab the Google Sheet
  sheet <- gs_title(table)
  # Add the data as a new row
  gs_add_row(sheet, input = data)
}

loadData <- function() {
  # Grab the Google Sheet
  sheet <- gs_title(table)
  # Read the data
  gs_read_csv(sheet)
}


# 4.MongoDB (local or remote)
library(mongolite)

options(mongodb = list(
  "host" = "ds012345.mongolab.com:61631",
  "username" = "myuser",
  "password" = "mypassword"
))
databaseName <- "myshinydatabase"
collectionName <- "responses"

saveData <- function(data) {
  # Connect to the database
  db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb://%s:%s@%s/%s",
                options()$mongodb$username,
                options()$mongodb$password,
                options()$mongodb$host,
                databaseName))
  # Insert the data into the mongo collection as a data.frame
  data <- as.data.frame(t(data))
  db$insert(data)
}

loadData <- function() {
  # Connect to the database
  db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb://%s:%s@%s/%s",
                options()$mongodb$username,
                options()$mongodb$password,
                options()$mongodb$host,
                databaseName))
  # Read all the entries
  data <- db$find()
  data
}