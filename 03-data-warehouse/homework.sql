CREATE OR REPLACE EXTERNAL TABLE `zoomcamp.week3_yellow_taxi`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://datazoomcamp_week3_juno/yellow_tripdata_2024-*.parquet']
);

select count(*) from `zoomcamp.week3_yellow_taxi`;

SELECT COUNT(DISTINCT(PULocationID)) FROM `zoomcamp.week3_yellow_taxi`;

CREATE OR REPLACE TABLE `zoomcamp.week3_nonpartitioned_yellow_taxi`
AS SELECT * FROM  `zoomcamp.week3_yellow_taxi`;

SELECT COUNT(DISTINCT(PULocationID)) FROM `zoomcamp.week3_nonpartitioned_yellow_taxi`;

select count(*) from `zoomcamp.week3_nonpartitioned_yellow_taxi`
where fare_amount = 0 ;

CREATE OR REPLACE TABLE `zoomcamp.week3_partitioned_yellow_taxi`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS (
  SELECT * FROM `zoomcamp.week3_yellow_taxi`
);

SELECT DISTINCT(VendorID) FROM `ny-taxi-juno.zoomcamp.week3_partitioned_yellow_taxi`
where date(tpep_dropoff_datetime) between '2024-03-01' and '2024-03-15';

SELECT DISTINCT(VendorID) FROM `ny-taxi-juno.zoomcamp.week3_nonpartitioned_yellow_taxi`
where date(tpep_dropoff_datetime) between '2024-03-01' and '2024-03-15';

