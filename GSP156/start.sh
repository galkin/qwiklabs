#!/bin/bash

# Step 1
bq query --use_legacy_sql=false \
'SELECT
   word,
   SUM(word_count) AS count
 FROM
   `bigquery-public-data`.samples.shakespeare
 WHERE
   word LIKE "%raisin%"
 GROUP BY
   word'

#Step 2
bq query --use_legacy_sql=false \
'SELECT
   word
 FROM
   `bigquery-public-data`.samples.shakespeare
 WHERE
   word = "huzzah"'

#Step 3
bq mk babynames

#Step 4
wget http://www.ssa.gov/OACT/babynames/names.zip
unzip names.zip
bq load babynames.names2010 yob2010.txt name:string,gender:string,count:integer

#Step 5
bq query "SELECT name,count FROM babynames.names2010 WHERE gender = 'F' ORDER BY count DESC LIMIT 5"
bq query "SELECT name,count FROM babynames.names2010 WHERE gender = 'M' ORDER BY count ASC LIMIT 5"

#Step 6
bq rm -r -f babynames