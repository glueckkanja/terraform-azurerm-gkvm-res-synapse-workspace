
output "resource" {
  description = "This is the full resource output for the Synapse Workspace resource."
  sensitive   = true
  value       = azapi_resource.this
}

output "resource_id" {
  description = "The ID of the Synapse Workspace."
  value       = azapi_resource.this
}

output "private_endpoints" {
  description = "A map of private endpoints. The map key is the supplied input to var.private_endpoints. The map value is the entire azurerm_private_endpoint resource."
  value       = azurerm_private_endpoint.this
}

output "name" {
  description = "The name of the Synapse Workspace."
  value       = azapi_resource.this.name
}

output "admin_password" {
  description = "Returns the sqladmin password if installation is configured to use the password.  Otherwise returns null"
  sensitive   = true
  value       = random_password.sql_admin_password[0].result
}
