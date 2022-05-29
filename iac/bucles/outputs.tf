# For Outputs
output "storage_accounts_for" {
description = "Storage Account Name con For"
   value = [for storage in azurerm_storage_account.storage_account : storage.name]
}
