# ------------------------------------
# loader keys
# ------------------------------------
output "cdc_runner_public_key_prod" {
  value = tls_private_key.key_cdc_runner_prod.public_key_pem
}

output "cdc_runner_private_key_prod" {
  value     = tls_private_key.key_cdc_runner_prod.private_key_pem
  sensitive = true
}
output "cdc_runner_public_key_dev" {
  value = tls_private_key.key_cdc_runner_dev.public_key_pem
}

output "cdc_runner_private_key_dev" {
  value     = tls_private_key.key_cdc_runner_dev.private_key_pem
  sensitive = true
}

# ------------------------------------
# transformer keys
# ------------------------------------
output "dbt_runner_public_key" {
  value = tls_private_key.key_dbt_runner.public_key_pem
}

output "dbt_runner_private_key" {
  value     = tls_private_key.key_dbt_runner.private_key_pem
  sensitive = true
}
