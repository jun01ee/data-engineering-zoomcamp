Sure! Here's a `README.md` file tailored for your project, which covers yearly scheduled PySpark data ingestion from GCS to BigQuery using Google Cloud Dataproc:

---

```markdown
# Yearly Export Data Ingestion Project

This project performs yearly ingestion of trade export data stored in Google Cloud Storage (GCS), processes it using PySpark, and writes the transformed output into Google BigQuery for analysis.

## 🧩 Overview

- **Source**: Trade export CSV files in GCS
- **Processing**: PySpark on Google Cloud Dataproc (Serverless Batch)
- **Destination**: BigQuery tables
- **Automation**: Scheduled annually using Google Cloud Scheduler + Cloud Functions

---

## 📁 Project Structure

```
project/
│
├── export_ingestion.py             # PySpark script for ETL
├── jars/
│   ├── gcs-connector-hadoop3-2.2.19-shaded.jar
│   └── spark-3.5-bigquery-0.42.1.jar
├── keys/
│   └── gcp-sa-key.json             # GCP Service Account JSON Key
├── scripts/
│   └── deploy.sh                   # Deployment helper (optional)
├── dataproc_scheduler/
│   ├── submit_batch.py            # Cloud Function to trigger batch job
│   └── requirements.txt           # Dependencies for Cloud Function
└── README.md
```

---

## ⚙️ Setup Instructions

### 1. Enable Required APIs

```bash
gcloud services enable dataproc.googleapis.com \
    bigquery.googleapis.com \
    storage.googleapis.com \
    cloudscheduler.googleapis.com \
    cloudfunctions.googleapis.com \
    iam.googleapis.com
```

### 2. Upload Dependencies

Upload JARs and PySpark script to a GCS bucket:

```bash
gsutil cp export_ingestion.py gs://<your-bucket>/scripts/
gsutil cp jars/*.jar gs://<your-bucket>/jars/
```

---

## 🚀 Submitting the Dataproc Batch Job

You can run the PySpark script using Dataproc Serverless:

```bash
gcloud dataproc batches submit pyspark \
    --region=<your-region> \
    --batch=export-ingestion-batch-$(date +%Y%m%d) \
    --jars=gs://<your-bucket>/jars/gcs-connector-hadoop3-2.2.19-shaded.jar,gs://<your-bucket>/jars/spark-3.5-bigquery-0.42.1.jar \
    --subnet=default \
    --async \
    -- gs://<your-bucket>/scripts/export_ingestion.py
```

---

## ⏰ Automating with Scheduler

### 1. Deploy Cloud Function

Deploy the Cloud Function that submits the batch job:

```bash
gcloud functions deploy submit_export_ingestion \
    --runtime=python310 \
    --region=<your-region> \
    --source=dataproc_scheduler/ \
    --entry-point=submit_job \
    --trigger-http \
    --allow-unauthenticated
```

### 2. Create Cloud Scheduler Job

```bash
gcloud scheduler jobs create http yearly-export-ingestion \
    --schedule="0 0 1 1 *" \
    --uri=<CLOUD_FUNCTION_URL> \
    --http-method=POST \
    --region=<your-region>
```

---

## 🔐 Authentication

Make sure your Dataproc and BigQuery jobs are authenticated:

- Grant the Dataproc Service Agent the following roles:
  - `BigQuery Data Editor`
  - `Storage Object Viewer`
- Your Cloud Function should use a service account with permission to submit Dataproc jobs.

---

## 📊 Output

The PySpark job writes processed data to the following BigQuery dataset:

```
Project: dataengineering-project-456707
Dataset: dezoomcamp_project_dataset
Tables: dim_section, dim_HS2, fact_export_by_product
```

---

## 📌 Notes

- Ensure your GCS paths are public or accessible via the configured service account.
- Test jobs manually before scheduling them.
- JARs must be hosted on GCS for Dataproc to access them properly.

---

## 🧼 Cleanup

To avoid unexpected charges:

```bash
gcloud scheduler jobs delete yearly-export-ingestion
gcloud functions delete submit_export_ingestion
gsutil rm -r gs://<your-bucket>/scripts/
gsutil rm -r gs://<your-bucket>/jars/
```

---

## 📞 Contact

For questions or improvements, feel free to open an issue or reach out!

```

---

Let me know if you'd like it personalized for GitHub (badges, links, etc.) or if you're hosting the Cloud Function code somewhere else!
