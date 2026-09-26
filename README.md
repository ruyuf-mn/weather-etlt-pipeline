#  Weather EtLT Pipeline 

An end-to-end EtLT (Extract, Light Transform, Load, Heavy Transform) data pipeline that extracts hourly weather data for Riyadh and Jeddah, loads it into PostgreSQL (Supabase), and builds analytical data models using SQL Views & Window Functions.

---

# Architecture & Pipeline Workflow

This project intentionally follows the **EtLT** pattern:
1. Extract (`E`): Fetch hourly weather metrics (temperature, relative humidity) via the Open-Meteo API.
2. Light Transform (`t`): Initial light cleaning and temperature conversion using Python.
3. Load (`L`): Ingest raw structured tables directly into PostgreSQL.
4. Heavy Transform (`T`): Execute heavy analytical modeling, lag calculations, and ranking directly inside PostgreSQL using SQL Views and Window Functions.

---

# Tech Stack & Tools

* Programming Language: Python
* API: [Open-Meteo Weather API](https://open-meteo.com/)
* Database: PostgreSQL (Supabase)
* Libraries: `requests`, `pandas` , `psycopg2` / `sqlalchemy` 
* Data Modeling: SQL Views, Window Functions (`LAG`, `DENSE_RANK`, `PARTITION BY`)

---

# Database Models & Analytical Views

The SQL logic creates four production ready views:

1. `riyadh_full_analysis`: Hourly temperature/humidity trends, previous hour differences (`LAG`), and daily/overall rankings (`DENSE_RANK`).
2. `jeddah_full_analysis`: Comprehensive analytical metrics for Jeddah mirroring the Riyadh structure.
3. `weather_daily_summary`: Aggregated daily average temperatures and humidity levels comparing both cities side-by-side.
4. `weather_comparison`: Direct hourly comparison between Riyadh and Jeddah.

---

# How to Run the Project

 1. Prerequisites
Ensure you have Python installed and the required libraries:
```bash
pip install pandas requests psycopg2-binary
```
2. Run the Extraction & Loading Script
Execute the Python script to fetch the latest weather data and populate PostgreSQL:
```bash
python etl_pipeline.py
```
3. Build Analytical Views
Run the SQL script transform_.sql inside your SQL Editor or Database Client to construct the analytical views.
