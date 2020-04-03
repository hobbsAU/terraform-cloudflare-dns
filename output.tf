# output.tf - all output variables are declared here
output "zone_name" {
  value = "${cloudflare_zone.zone[*].zone}"
}
output "zone_id" {
  value = "${cloudflare_zone.zone[*].id}"
}
output "zone_status" {
  value = "${cloudflare_zone.zone[*].status}"
}
output "zone_nameservers" {
  value = "${cloudflare_zone.zone[*].name_servers}"
}

