# All variables are declared and defaults defined here

variable "cloudflare_token" {
  description 	= "API Token with the following permissions: Zone.Zone Settings, Zone.Zone, Zone.DNS"
  type 		= string
  default 	= ""
}

variable "domain" {
  description 	= "Name of DNS Zone"
  type 		= string
  default 	= ""
}

variable "common_records" {
  description 	= "Common record types including: A, AAAA, CNAME, NS, PTR, SPF, and TXT. [name, type, ttl, proxied, value]"
  type 		= list(tuple([string, string, number, bool, string]))
  default 	= []
}

variable "mx_records" {
  description 	= "MX record type. [name, ttl, priority, value]"
  type 		= list(tuple([string, number, number, string]))
  default 	= []
}

variable "srv_records" {
  description 	= "SRV record type. [service, proto, priority, weight, port, target]"
  type    	= list(tuple([string, string, number, number, number, string]))
  default 	= []
}

variable "tlsa_records" {
  description 	= "TLSA record type. [name, usage, selector, matching_type, certificate]"
  type    	= list(tuple([string, number, number, number, string]))
  default 	= []
}

