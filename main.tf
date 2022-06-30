# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  cloud {
    organization = "Aesirean-Empire"
    workspaces {
      name = "development"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "development"
  location = "westus2"
}

resource "azurerm_container_registry" "acr" {
  name                = "taemdev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}


resource "azurerm_kubernetes_cluster" "kube" {
  name                = "taem-dev-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "taem-dev-cluster"
  sku_tier            = "Free"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_B4ms"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.22.6"
}

resource "azurerm_role_assignment" "aks_role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.kube.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}