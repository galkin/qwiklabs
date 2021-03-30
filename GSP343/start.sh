#!/bin/bash

bq mk bike
cd $(dirname $BASH_SOURCE)
cat step_2.sql | bq query --nouse_legacy_sql --nosync | awk '{split($0,a,":"); print a[2]}'
cat step_3.sql | bq query --nouse_legacy_sql --nosync | awk '{split($0,a,":"); print a[2]}'
while ! bq wait;
do
  echo waiting;
done;
bq wait
cat step_4_1.sql | bq query --nouse_legacy_sql
cat step_4_2.sql | bq query --nouse_legacy_sql
cat step_5_1.sql | bq query --nouse_legacy_sql
cat step_5_2.sql | bq query --nouse_legacy_sql
