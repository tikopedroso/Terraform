terraform {
  required_version = ">1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.55.0"
    }
  }
}

//Parâmetros específicos 
provider "azurerm" {
  features {
  }
}

//Criando o Resource Group
resource "azurerm_resource_group" "rg_cloud_exercises" {
  name     = "rg_cloud_exercises"
  location = "East US"
}
