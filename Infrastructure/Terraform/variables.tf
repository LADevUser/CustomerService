variable "environment" {
  type = string  
  description = "The environment for the infrastructure artifacts to be created"
    validation {
    condition     = contains(["dev", "staging","prod"], lower(var.environment))
    error_message = "Unsupported Service specified. Supported service are: dev, staging, prod"
  }
}

variable "resource_group_location" {
  type = string
  default     = "North Europe"
  description = "Location of the resource group."
}

variable "division_prefix" {
    type = string 
  description = "Prefix of the division you are deploying for"
  validation {
    condition     = contains(["swe"], lower(var.division_prefix))
    error_message = "Unsupported Service specified. Supported service are: rg, st, as ,fa ,la"
  }
}

variable "servicedefinition_prefix" {
  type = string 
  description = "Prefix of the service you are deploying."
  validation {
    condition     = contains(["cu", "ord", "sup"], lower(var.servicedefinition_prefix))
    error_message = "Unsupported Service specified. Supported service are: addboxes, allboxes, carrier,contact,myboxes,ourboxes,platform,search,sysadmin,yourboxes"
  }
}

variable "idnum_prefix"{
    type = string  
    description = "identifier number of the resources deployed"

}

variable saaccesstier{
  type = string
  description = "The accesstier of the storageaccount to be created. Notice Case Sensetive"
    validation {
    condition     = contains(["Cool", "Hot"], var.saaccesstier)
    error_message = "Unsupported Service specified. Supported service are: Cool, Hot .. Notice case sensitivity"
  }
}

variable saaccount_kind{
  type = string
  description = "the kind of storage account to be created (usualla a v2)"
}

variable "saaccount_replication" {
  type = string
  description = "The storage account replication plan"

}

variable "saaccount_tier" {
    type = string
    description = "The storage account access tier"
        validation {
    condition     = contains(["Standard", "Premium"], var.saaccount_tier)
    error_message = "Unsupported Service specified. Supported service are: Standard, Premium .. Notice case sensitivity"
  }
}

variable "sa_queuename" {
      type = string
    description = "The name of the azure queue"
  
}

variable "blobcontainerlist" {
  
  type = list(string)
  description = "an array of names for blobs to be created in the storage account"
}

variable "ca_containerappname" {
        type = string
    description = "The name of the azure container app"
}

variable "cosmosdb_account_name" {
          type = string
    description = "The name of the azure cosmos account"
}

variable "cosmosdb_sqldb_name" {
            type = string
    description = "The name of the azure cosmos sql database"
}

variable "sql_container_name" {
  type        = string
  description = "SQL API container name."
}

variable "max_throughput" {
  type        = number
  default     = 4000
  description = "Cosmos db database max throughput"
  validation {
    condition     = var.max_throughput >= 4000 && var.max_throughput <= 1000000
    error_message = "Cosmos db autoscale max throughput should be equal to or greater than 4000 and less than or equal to 1000000."
  }
  validation {
    condition     = var.max_throughput % 100 == 0
    error_message = "Cosmos db max throughput should be in increments of 100."
  }
}

variable "functionappname" {
    type        = string
    description = "the function app name."
}