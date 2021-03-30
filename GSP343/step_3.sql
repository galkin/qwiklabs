CREATE OR REPLACE MODEL bike.subscriber_model
OPTIONS
  (model_type="linear_reg", labels=["duration_minutes"]) AS
SELECT
    start_station_name,
    EXTRACT(HOUR FROM start_time) AS start_hour,
    subscriber_type,
    duration_minutes
FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips` AS trips
WHERE EXTRACT(YEAR FROM start_time) = 2018