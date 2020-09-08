output "log_analytics" {
  value = module.logging
  description = "outputs the log analytics configuration settings as documented in log analytics module"
}

output "global_settings" {
  value = var.global_settings
  description = "global settings of the landing zone"
}

output "subscription_prefix" {
  value = data.null_data_source.subscription_prefix.outputs.subscription_prefix
  description = "The subscription prefix used for naming conventions"
}