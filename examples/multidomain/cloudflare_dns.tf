variable "cloudflare_token" {}
variable "domain" {}
variable "common_records" { default = [] }
variable "mx_records" { default = [] }
variable "srv_records" { default = [] }
variable "tlsa_records" { default = [] }

module "cloudflare_dns" {
  source = "github.com/hobbsAU/terraform-cloudflare-dns"

  cloudflare_token = var.cloudflare_token
  domain           = var.domain
  common_records   = var.common_records
  srv_records      = var.srv_records
  tlsa_records     = var.tlsa_records
  mx_records       = var.mx_records
}

output "cloudflare_zone_name" {
  description = "Zone Name"
  value       = module.cloudflare_dns.zone_name
}
output "cloudflare_zone_id" {
  description = "Zone ID"
  value       = module.cloudflare_dns.zone_id
}
output "cloudflare_zone_status" {
  description = "Zone Status"
  value       = module.cloudflare_dns.zone_status
}
output "cloudflare_zone_nameservers" {
  description = "Zone Name Servers"
  value       = module.cloudflare_dns.zone_nameservers
}
