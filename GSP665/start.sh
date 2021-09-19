#!/bin/bash

# Task 2: Perform a simple query
bq query --use_legacy_sql=false \
'SELECT * FROM `bigquery-public-data.crypto_bitcoin.transactions` as transactions
WHERE transactions.hash = "a1075db55d416d3ca199f55b6084e2115b9345e16c5cf302fc80e9d5fbf5d48d"'

# Task 3: Validate the data
bq query --use_legacy_sql=false \
'WITH double_entry_book AS (
   -- debits
   SELECT
    array_to_string(inputs.addresses, ",") as address
   , inputs.type
   , -inputs.value as value
   FROM `bigquery-public-data.crypto_dogecoin.inputs` as inputs
   UNION ALL
   -- credits
   SELECT
    array_to_string(outputs.addresses, ",") as address
   , outputs.type
   , outputs.value as value
   FROM `bigquery-public-data.crypto_dogecoin.outputs` as outputs
)
SELECT
   address
,   type   
,   sum(value) as balance
FROM double_entry_book
GROUP BY 1,2
ORDER BY balance DESC
LIMIT 100'

# Task 5: Explore two famous cryptocurrency events
bq query --use_legacy_sql=false \
'CREATE OR REPLACE TABLE lab.51 (transaction_hash STRING) as 
SELECT transaction_id FROM `bigquery-public-data.bitcoin_blockchain.transactions` , UNNEST( outputs ) as outputs
where outputs.output_satoshis = 19499300000000'

bq query --use_legacy_sql=false \
'CREATE OR REPLACE TABLE lab.52 (balance NUMERIC) as
WITH double_entry_book AS (
   -- debits
   SELECT
    array_to_string(inputs.addresses, ",") as address
   , -inputs.value as value
   FROM `bigquery-public-data.crypto_bitcoin.inputs` as inputs
   UNION ALL
   -- credits
   SELECT
    array_to_string(outputs.addresses, ",") as address
   , outputs.value as value
   FROM `bigquery-public-data.crypto_bitcoin.outputs` as outputs
   
)
SELECT   
sum(value) as balance
FROM double_entry_book
where address = "1XPTgDRhN8RFnzniWCddobD9iKZatrvH4"'