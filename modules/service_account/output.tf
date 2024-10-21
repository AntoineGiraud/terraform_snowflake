
output "runner_public_key" {
  value = tls_private_key.key_service_account.public_key_pem
}

output "runner_private_key" {
  value     = tls_private_key.key_service_account.private_key_pem
  sensitive = true
}
