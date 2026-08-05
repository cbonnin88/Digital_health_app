# 📊 EuroHealth App - Product Analytics Dashboard

## Project Overview
This project is an end-to-end data analytics pipeline and interactive dashboard built to monitor user engagement and conversion metrics for the EuroHealth application. The dashboard connects securely to Google BigQuery, processes user event data, and visualizes key product indicators using Streamlit and Plotly.

## Tech Stack
* **Python:** Core programming language.
* **Streamlit:** Web application framework for the interactive dashboard.
* **dbt (data build tool):** Analytics engineering tool used to transform raw data in the warehouse.
* **Google BigQuery:** Cloud data warehouse for executing complex analytical SQL queries.
* **Plotly Express:** Data visualization library for rendering advanced charts (e.g., funnel analysis).
* **Streamlit Community Cloud:** Hosting and deployment platform.

---

## Core Business Questions Answered

| Business Question | Metric Tracked | Dashboard Solution |
| :--- | :--- | :--- |
| How many unique users are active on the platform daily? | Daily Active Users (DAU) | A time-series line chart tracking `COUNT(DISTINCT user_id)` grouped by date from the `fct_user_activity` table. |
| Where are users dropping off in the core product flow? | Funnel Conversion Rate | A funnel visualization mapping the volume of sessions moving from `login` to `view_dashboard` to `click_upload`. |
| What is the success rate of our primary user journey? | Overall Conversion Rate | A calculated metric displaying the percentage of users who complete the funnel compared to those who started it. |

---
## Data Modeling (dbt)
The data architecture follows analytics engineering best practices, transforming raw JSON/CSV dumps into clean, query-ready tables.

* **Staging Layer (`stg_events`):** 
  * Normalizes column names and casts raw data types into standard formats (e.g., parsing timestamps).
  * Cleans specific event streams to map the user journey (logins, dashboard views, uploads).
* **Marts Layer (`fct_user_activity`):** 
  * Aggregates event data to the daily and user level to optimize dashboard query performance.
  * Pre-calculates session bounds and daily active constraints.
* **Data Quality & Testing:**
  * Configured `schema.yml` files to enforce `unique` and `not_null` tests on primary keys (like `user_id` and `session_id`) to ensure dashboard accuracy.

<img width="1052" height="514" alt="Capture d’écran 2026-08-03 à 09 05 20" src="https://github.com/user-attachments/assets/5c4e352b-6ee3-4b1b-be3d-a4a9eb2b83e9" />


---

## Architecture & Data Flow
1. **Data Storage:** Raw event data and modeled analytics tables (`fct_user_activity`, `stg_events`) are stored in a Google Cloud BigQuery dataset (`dbt_health_app`).
2. **Data Transformation (dbt):** Raw data is cleaned, structured, and aggregated into analytical tables using dbt.
3. **Data Extraction:** The Streamlit app runs cached, optimized SQL queries directly against BigQuery to fetch aggregated metrics.
4. **Data Visualization:** The results are parsed into pandas DataFrames and rendered into interactive UI components using Plotly and Streamlit native elements.

---

## Local Setup and Installation

**1. Clone the repository**
Download the project files to your local machine.

**2. Install dependencies**
Ensure you have Python installed, then run the following command to install the required libraries:
`pip install -r requirements.txt`

**3. Configure Google Cloud Authentication**
This project requires a Google Cloud Service Account with `BigQuery Data Viewer` and `BigQuery User` roles. 
* Create a `.streamlit` folder in the root directory.
* Inside that folder, create a `secrets.toml` file.
* Map your Service Account JSON keys to the following structure (ensure line breaks in the private key are represented as literal `\n`):

```toml
[gcp_service_account]
type = "service_account"
project_id = "your-project-id"
private_key_id = "your-private-key-id"
private_key = "-----BEGIN PRIVATE KEY-----\nYOUR_KEY_HERE\n-----END PRIVATE KEY-----\n"
client_email = "your-email@your-project.iam.gserviceaccount.com"
client_id = "your-client-id"
auth_uri = "[https://accounts.google.com/o/oauth2/auth](https://accounts.google.com/o/oauth2/auth)"
token_uri = "[https://oauth2.googleapis.com/token](https://oauth2.googleapis.com/token)"
auth_provider_x509_cert_url = "[https://www.googleapis.com/oauth2/v1/certs](https://www.googleapis.com/oauth2/v1/certs)"
client_x509_cert_url = "your-cert-url"
