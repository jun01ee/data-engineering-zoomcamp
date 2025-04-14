import os

from pyspark.sql import SparkSession
from pyspark.sql.functions import input_file_name, regexp_extract, col, lit, expr

from google.cloud import bigquery
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/Users/23491378/keys/dataengineering-project-456707-dd73f064e848.json'

bucket = "jun01ee-bucket"
gcs_jar_path = f"gs://{bucket}/jars/gcs-connector-hadoop3-2.2.19-shaded.jar"
bigquery_jar_path = f"gs://{bucket}/jars/spark-3.5-bigquery-0.42.1.jar"

# Initialize Spark session
spark = SparkSession.builder \
    .appName("GCSRead") \
    .config("spark.jars", f"{gcs_jar_path}, {bigquery_jar_path}") \
    .config("spark.hadoop.fs.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem") \
    .getOrCreate()

# Path to CSVs on GCS
GCS_PATH = f"gs://{bucket}/*.csv"
BQ_PROJECT = "dataengineering-project-456707"
BQ_DATASET = "dezoomcamp_project_dataset"

# Load CSVs with filename column
df = spark.read.option("header", "true").option("inferSchema", "true").csv(GCS_PATH) \
    .withColumn("source_file", input_file_name())

# Extract year from file path (assumes something like .../2019_exports.csv)
df = df.withColumn("year", regexp_extract("source_file", r"(\d{4})", 1).cast("int"))

# Rename columns to avoid issues with spaces/special characters
df = df.withColumnRenamed("Section ID", "section_id") \
       .withColumnRenamed("Section", "section_name") \
       .withColumnRenamed("HS2 ID", "hs2_id") \
       .withColumnRenamed("HS2", "hs2_name") \
       .withColumnRenamed("Australia' Exports", "australia_exports") \
       .withColumnRenamed("United States' Exports", "us_exports")

print(df.columns)

# Convert to long format
df_long = df.select(
    "year", "section_id", "section_name", "hs2_id", "hs2_name", "australia_exports", "us_exports"
).withColumn("australia_exports", col("australia_exports").cast("double")) \
 .withColumn("us_exports", col("us_exports").cast("double"))

australia_df = df_long.select("year", "section_id", "section_name", "hs2_id", "hs2_name", "australia_exports") \
    .withColumn("country", lit("Australia")) \
    .withColumnRenamed("australia_exports", "export_value")

us_df = df_long.select("year", "section_id", "section_name", "hs2_id", "hs2_name", "us_exports") \
    .withColumn("country", lit("United States")) \
    .withColumnRenamed("us_exports", "export_value")

tidy_df = australia_df.unionByName(us_df).dropna(subset=["export_value"])

# Create dimensions
dim_section = tidy_df.select("section_id", "section_name").dropDuplicates()
dim_HS2 = tidy_df.select("hs2_id", "hs2_name", "section_id").dropDuplicates()

# Create fact tables
fact_export_by_product = tidy_df.groupBy("year", "country", "hs2_id") \
    .agg(expr("sum(export_value) as total_export"))

fact_export_by_year = tidy_df.groupBy("year", "country") \
    .agg(expr("sum(export_value) as total_export"))

# Function to write to BigQuery
def write_to_bq(dataframe, table_name):
    dataframe.write \
        .format("bigquery") \
        .option("table", f"{BQ_PROJECT}:{BQ_DATASET}.{table_name}") \
        .option("temporaryGcsBucket", bucket) \
        .mode("overwrite") \
        .save()

# Write tables to BigQuery
write_to_bq(dim_section, "dim_section")
write_to_bq(dim_HS2, "dim_HS2")
write_to_bq(fact_export_by_product, "fact_export_by_product")
write_to_bq(fact_export_by_year, "fact_export_by_year")

# stop the session
spark.stop()