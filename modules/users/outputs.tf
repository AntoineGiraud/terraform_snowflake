# 1️⃣ les user dédiés
output "usr_loader" {
    value = snowflake_service_user.loader.name
}
output "usr_transformer" {
    value = snowflake_service_user.transformer.name
}
output "usr_reader" {
    value = snowflake_service_user.reader.name
}