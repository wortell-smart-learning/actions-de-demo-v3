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
