import os
import argparse

from pyspark.sql import SparkSession
from pyspark.sql import functions as F


from google.cloud import bigquery
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/Users/23491378/keys/dataengineering-project-456707-dd73f064e848.json'
