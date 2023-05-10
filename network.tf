//VNET dentro do resource group criado acima
resource "azurerm_virtual_network" "vnet_cloud_exercises" {
  name                = "vnet_cloud_exercises"
  location            = azurerm_resource_group.rg_cloud_exercises.location
  resource_group_name = azurerm_resource_group.rg_cloud_exercises.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
    AtvImpacta  = "ImpactaCloud"
  }
}

//SUBNET referenciando em qual resource group e qual vnet criada anteriormente
resource "azurerm_subnet" "sub_cloud_exercises" {
  name                 = "sub_cloud_exercises"
  resource_group_name  = azurerm_resource_group.rg_cloud_exercises.name
  virtual_network_name = azurerm_virtual_network.vnet_cloud_exercises.name
  address_prefixes     = ["10.0.1.0/24"]
}

//Security Group  
resource "azurerm_network_security_group" "sg_cloud_exercises" {
  name                = "sg_cloud_exercises"
  location            = azurerm_resource_group.rg_cloud_exercises.location
  resource_group_name = azurerm_resource_group.rg_cloud_exercises.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}