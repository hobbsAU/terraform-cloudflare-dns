# Cloudflare DNS Terraform module

## Description
Terraform module that enables Create, Retrieve, Update and Delete (CRUD) operations for DNS related resources on [Cloudflare](https://www.cloudflare.com/). You could use this as part of an Infrastructure as Code (IaC) pipeline to create a Cloudflare managed DNS zone.

## Provider Resources
The following resources are supported:
- [cloudflare_zone](https://www.terraform.io/docs/providers/cloudflare/r/zone.html)
- [cloudflare_record](https://www.terraform.io/docs/providers/cloudflare/r/record.html)


## Requirements
Terraform => 0.12
Cloudflare Provider => 2.5


## Usage
See [Examples](#examples) for extended usage.

```hcl
module "cloudflare_dns" {
  source = "github.com/hobbsAU/terraform-cloudflare-dns"

  cloudflare_token 	= "INSERT_CLOUDFLARE_TOKEN"
  domain 		= "testdomain.com"
  common_records 	= [ ["@", "A", 1, "true", "1.2.3.4"], ["www", "CNAME", 1, "false", "name.testdomain.com"] ]
}

```

### Conditional creation
Sometimes you need to have a way to create resources conditionally however Terraform does not allow to use `count` inside `module` block. This module only creates resources if any `_name` variables are set.

The following example does not create any resources.

```hcl
module "cloudflare_dns" {
  source = "github.com/hobbsAU/terraform-cloudflare-dns"

  cloudflare_token 	= "INSERT_CLOUDFLARE_TOKEN"
  domain 		= ""
  common_records 	= ""
}
```


### Examples
See example.tf in module/examples.

## Versioning
This module uses [semantic versioning](https://semver.org/) to avoid compatibility problems.

## Authors
Module is created and maintained by [hobbsAU](https://github.com/hobbsAU).

