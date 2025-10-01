# TODO List

This document outlines the incremental steps required to align the project with the specifications in `requirements.md`.

## 1. Infra-as-Code (IaC)

The project currently uses Bicep, but the requirements mandate Terraform.

Important: if you want to test something, use the following variables:
* resource_group_name: demo-20251004
* location: westeurope
On top of that, don't apply any terraform thing yourself. Instead, ask the user to do this for you.

## 2. Data Plane

### Azure Data Factory
- [ ] Create ADF pipeline to load CSV data from the data lake, convert it to Parquet, and store it in a "silver" layer (`bronze_to_silver_pipeline`).
- [ ] Create ADF pipeline to load the Parquet data from the "silver" layer into the SQL Database.

## 3. GitHub Actions (CI/CD)

(To be extended)