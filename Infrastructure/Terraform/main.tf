

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "rg-${var.division_prefix}-${var.servicedefinition_prefix}-${var.environment}-${var.idnum_prefix}"
}

resource "azurerm_storage_account" "sa" {
  name = "st${lower(var.division_prefix)}${var.servicedefinition_prefix}${lower(var.environment)}${var.idnum_prefix}"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.resource_group_location
  access_tier = var.saaccesstier
  account_kind = var.saaccount_kind
  account_replication_type = var.saaccount_replication
  account_tier = var.saaccount_tier
}

resource "azurerm_storage_queue" "sa_qname" {
  name = "${lower(var.sa_queuename)}"
  storage_account_name  = "${azurerm_storage_account.sa.name}"
}

resource "azurerm_storage_container" "containers" {
  count = length(var.blobcontainerlist)
  name = var.blobcontainerlist[count.index] 
  storage_account_name  = "${azurerm_storage_account.sa.name}"
  container_access_type = "private"
}

locals {  

  default_tags = {
    environment = var.environment
    owner       = "J.Son"
    app         = var.ca_containerappname
  }

}

resource "azurerm_log_analytics_workspace" "CoAppWsLog" {
  name                = "ws-log-${lower(var.division_prefix)}-coapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.default_tags
}

resource "azurerm_container_app_environment" "CoAppEnv" {
  name                      = "cae-${lower(var.division_prefix)}-${var.servicedefinition_prefix}-${lower(var.environment)}-${var.idnum_prefix}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.CoAppWsLog.id

  tags = local.default_tags
}

resource "azurerm_container_app" "coappcs" {
  name                         = "ca-${var.division_prefix}-${var.servicedefinition_prefix}-${var.environment}-${var.idnum_prefix}"

  container_app_environment_id = azurerm_container_app_environment.CoAppEnv.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  #registry {
  #  server               = "docker.io"    
  #}

    template {
    container {
      name   = "co-${var.division_prefix}-${var.servicedefinition_prefix}-app-apihost"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
          } 

      min_replicas = 1
      max_replicas = 1
      } 



  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 80
    traffic_weight {
      latest_revision = true
      percentage = 100
    }

  }

 

  
  tags = local.default_tags
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "as-${var.division_prefix}-${var.servicedefinition_prefix}-${var.environment}-${var.idnum_prefix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location
  os_type = "Windows"
  sku_name = "Y1"
}

resource "azurerm_windows_function_app" "Cuhandler" {
  name                       = "fa-${var.division_prefix}-${var.servicedefinition_prefix}-${var.environment}-${var.functionappname}"
  location                   = var.resource_group_location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.app_service_plan.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  functions_extension_version = "~4"

  site_config {
    
    #always_on = true
  } 

    app_settings = {
    
  }
}

resource "azurerm_cosmosdb_account" "CoDBAccount" {
  name                      = var.cosmosdb_account_name
  location                  = var.resource_group_location
  resource_group_name       = azurerm_resource_group.rg.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_automatic_failover = false
  geo_location {
    location          = var.resource_group_location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  depends_on = [
    azurerm_cosmosdb_account.CoDBAccount
  ]
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = var.cosmosdb_sqldb_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.CoDBAccount.name
  autoscale_settings {
    max_throughput = var.max_throughput
  }
}

resource "azurerm_cosmosdb_sql_container" "CoDB_SQLCont" {
  name                  = var.sql_container_name
  resource_group_name   = azurerm_resource_group.rg.name
  account_name          = azurerm_cosmosdb_account.CoDBAccount.name
  database_name         = azurerm_cosmosdb_sql_database.main.name
  partition_key_path    = "/definition/id"
  partition_key_version = 1
  autoscale_settings {
    max_throughput = var.max_throughput
  }

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}

output "azurerm_container_app_url" {
  value = azurerm_container_app.coappcs.latest_revision_fqdn
}