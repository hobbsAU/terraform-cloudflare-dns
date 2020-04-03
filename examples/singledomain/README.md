# Example: Single domain provisioning on Cloudflare

## Description
The example in this directory will provision a single zone (domain) on Cloudflare.

This example uses an external vars file to populate the module variables.

## Requirements
- Cloudflare api token defined in the testdomain.vars file as API_TOKEN (the token must have the following permissions: Zone.Zone Settings, Zone.Zone, Zone.DNS)" 

## Usage
```bash
$ git clone https://github.com/hobbsAU/terraform-cloudflare-dns.git
$ cd terraform-cloudflare-dns/examples/singledomain
$ vim testdomain.vars
$ terraform init
$ terraform plan -var-file testdomain.vars
$ terraform apply -var-file testdomain.vars
```

Note: This example may create resources that cost money. Run `terraform destroy` to remove these resources.

