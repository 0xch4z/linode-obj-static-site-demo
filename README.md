# We're building a static website (with Terraform)!

## What is Terraform?

Terraform is a tool for defining and provisioning infrastructure in a declarative syntax. Basically, you describe a specification for a resource (like a server or load balancer) in code, the run `terraform apply` and it will take care of making sure your infrastructure matches the specification.

### Install Terraform

For mac users, you can just run:

```bash
brew install terraform
```

Check out [the docs](https://learn.hashicorp.com/tutorials/terraform/install-cli) for more methods.

## What is S3CMD?

S3CMD is a command line tool for managing S3 buckets and objects. We will use it to add a website configuration to our OBJ bucket.

### Install S3CMD

Again, mac users can just run:

```bash
brew install s3cmd
```

For alternatives, check out this [documentation](https://github.com/s3tools/s3cmd/blob/master/INSTALL.md).

## Expectations

- You must have a domain name.
- You must have an OBJ bucket and it's label must match your domain name, including subdomain (i.e. `www.acme.org`). See [this guide](https://www.linode.com/docs/platform/object-storage/host-static-site-object-storage/#optional-next-steps).
- You must add a CNAME record for your subdomain, pointing to `website-us-east-1.linodeobjects.com`; this is how it knows where to look for the bucket (i.e. `www.acme.org.website-us-east-1.linodeobjects.com`).

## Procedure

Modify the `main.tf` file to match your domain and public files. Then run `terraform apply` and enjoy your new static site.
