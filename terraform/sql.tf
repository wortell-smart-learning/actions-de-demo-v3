resource "azurerm_mssql_server" "sql_server" {
  name                         = "sql-${var.resource_group_name}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "ThisIsNotAPassword123!"
  tags                         = {}
}

resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "sql_db" {
  name                = "sqldb-${var.resource_group_name}"
  server_id           = azurerm_mssql_server.sql_server.id
  sku_name            = "S0"
}
