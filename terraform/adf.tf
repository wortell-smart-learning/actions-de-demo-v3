locals {
  is_dev_branch = var.adf_git_branch != "main"
}

resource "azurerm_data_factory" "adf_dev" {
  count               = local.is_dev_branch ? 1 : 0
  name                = "adf-${var.resource_group_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  identity {
    type = "SystemAssigned"
  }
  github_configuration {
    account_name    = "wortell-smart-learning"
    branch_name     = var.adf_git_branch
    git_url         = "https://github.com"
    repository_name = "actions-de-demo-v3"
    root_folder     = "/src/adf"
  }
}

resource "azurerm_data_factory" "adf_prod" {
  count               = local.is_dev_branch ? 0 : 1
  name                = "adf-${var.resource_group_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  identity {
    type = "SystemAssigned"
  }
}

locals {
  adf_id = local.is_dev_branch ? azurerm_data_factory.adf_dev[0].id : azurerm_data_factory.adf_prod[0].id
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "adls" {
  name                = "ls_adls"
  data_factory_id     = local.adf_id
  connection_string   = azurerm_storage_account.adls.primary_connection_string
}

resource "azurerm_data_factory_linked_service_azure_sql_database" "sql" {
  name                = "ls_sql"
  data_factory_id     = local.adf_id
  connection_string   = "Data Source=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sql_db.name};User ID=${azurerm_mssql_server.sql_server.administrator_login};Password=${azurerm_mssql_server.sql_server.administrator_login_password};Integrated Security=False;Encrypt=True;Connection Timeout=30"
}

resource "azurerm_data_factory_dataset_delimited_text" "source_csv" {
  name                = "ds_source_csv"
  data_factory_id     = local.adf_id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.adls.name

  azure_blob_storage_location {
    container = "bronze"
    path      = "sales"
    filename  = "*.csv"
  }

  column_delimiter = ","
  row_delimiter    = "\n"
  encoding         = "UTF-8"
  quote_character  = "\""
  escape_character = "\\"
  first_row_as_header = true
}

resource "azurerm_data_factory_dataset_parquet" "destination_parquet" {
  name                = "ds_destination_parquet"
  data_factory_id     = local.adf_id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.adls.name

  azure_blob_storage_location {
    container = "silver"
    path      = "sales"
  }
}

resource "azurerm_data_factory_pipeline" "bronze_to_silver_pipeline" {
  name            = "bronze_to_silver_pipeline"
  data_factory_id = local.adf_id

  activities_json = jsonencode([
    {
      name = "CopyCsvToParquet"
      type = "Copy"
      inputs = [
        {
          referenceName = azurerm_data_factory_dataset_delimited_text.source_csv.name
          type          = "DatasetReference"
        }
      ]
      outputs = [
        {
          referenceName = azurerm_data_factory_dataset_parquet.destination_parquet.name
          type          = "DatasetReference"
        }
      ]
      typeProperties = {
        source = {
          type = "DelimitedTextSource"
        }
        sink = {
          type = "ParquetSink"
        }
      }
    }
  ])
}

resource "azurerm_data_factory_dataset_azure_sql_table" "sql_table" {
  name                = "ds_sql_table"
  data_factory_id     = local.adf_id
  linked_service_id   = azurerm_data_factory_linked_service_azure_sql_database.sql.id
  table               = "Sales"
}

resource "azurerm_data_factory_pipeline" "silver_to_gold_pipeline" {
  name            = "silver_to_gold_pipeline"
  data_factory_id = local.adf_id

  activities_json = jsonencode([
    {
      name = "CopyParquetToSql"
      type = "Copy"
      inputs = [
        {
          referenceName = azurerm_data_factory_dataset_parquet.destination_parquet.name
          type          = "DatasetReference"
        }
      ]
      outputs = [
        {
          referenceName = azurerm_data_factory_dataset_azure_sql_table.sql_table.name
          type          = "DatasetReference"
        }
      ]
      typeProperties = {
        source = {
          type = "ParquetSource"
        }
        sink = {
          type = "AzureSqlSink"
        }
      }
    }
  ])
}
