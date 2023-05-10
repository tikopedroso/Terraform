//IPPublic 
resource "azurerm_public_ip" "ippublic_cloud_exercises" {
  name                = "ippublic_cloud_exercises"
  resource_group_name = azurerm_resource_group.rg_cloud_exercises.name
  location            = azurerm_resource_group.rg_cloud_exercises.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}
//Conectando network interfaces no resource group via config subrede
resource "azurerm_network_interface" "nic_cloud_exercises" {
  name                = "nic_cloud_exercises"
  location            = azurerm_resource_group.rg_cloud_exercises.location
  resource_group_name = azurerm_resource_group.rg_cloud_exercises.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub_cloud_exercises.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ippublic_cloud_exercises.id
  }
}
//virtual machine
resource "azurerm_linux_virtual_machine" "vm-cloud-exercises" {
  name                            = "vm-cloud-exercises"
  resource_group_name             = azurerm_resource_group.rg_cloud_exercises.name
  location                        = azurerm_resource_group.rg_cloud_exercises.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "123@Mudar!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_cloud_exercises.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
//Associação do network interfaces com Security Group
resource "azurerm_network_interface_security_group_association" "nic_sg_cloud_exercises" {
  network_interface_id      = azurerm_network_interface.nic_cloud_exercises.id
  network_security_group_id = azurerm_network_security_group.sg_cloud_exercises.id
}
//Plugin para instalação de dependências
resource "null_resource" "install-nginx" {
  connection {
    type     = "ssh"
    host     = azurerm_public_ip.ippublic_cloud_exercises.ip_address
    user     = "adminuser"
    password = "123@Mudar!"
  }

  //Atualiza o Linux e instala o NGIX na criação da VM 
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx"
    ]
  }

  depends_on = [
    azurerm_linux_virtual_machine.vm-cloud-exercises
  ]
}