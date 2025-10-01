# Requirements

In order to execute this demo correctly, the following needs to be prepared:

* Infra-as-Code: A Terraform configuration setting up the following infrastructure:
  * Data Lake (ADLSgen2)
  * Azure Data Factory
  * SQL Database
* "Data plane" contents for populating the products:
  * ADF: 
    * Pipeline loading a CSV to Parquet (bronze to silver)
    * Pipeline loading a Parquet to SQL Database
* GitHub Actions:
  * Infra-as-code
  * CI/CD deploying the data plane

We will use the OICD authentication between Azure and GitHub Actions.