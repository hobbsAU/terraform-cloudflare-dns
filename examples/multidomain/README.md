# Example: Managing multiple domain provisioning on Cloudflare

## Description
The example in this directory shows how to manage provisioning for multiple zones (domains) on Cloudflare.

This example uses an external vars file to populate the module variables. This example uses a bash helper script to manage the zones. All zones in the directory passed to the script will be automatically detected. To exclude a zone rename it with a leading "\_".

## Requirements
- Cloudflare api token defined in the testdomain.vars file as API_TOKEN (the token must have the following permissions: Zone.Zone Settings, Zone.Zone, Zone.DNS)" 

## Usage
```bash
$ git clone https://github.com/hobbsAU/terraform-cloudflare-dns.git
$ cd terraform-cloudflare-dns/examples/multidomain
$ vim ./zones/testdomain1.vars
$ vim ./zones/testdomain2.vars
$ ./cfctl.sh -p ./zones
```

Note: This example may create resources that cost money. Run `terraform destroy` to remove these resources.

