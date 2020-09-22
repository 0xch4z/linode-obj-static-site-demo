locals {
  index_document = "index.html"
  error_document = "404.html"

  s3cmd_args = [
    "--host", "us-east-1.linodeobjects.com",
    "--host-bucket", "'%(bucket)s.us-east-1.linodeobjects.com'",
    "--access_key", "$ACCESS_KEY",
    "--secret_key", "$SECRET_KEY",
  ]

  content_type = {
    css  = "text/css"
    html = "text/html"
    png  = "image/png"
  }
}

resource "linode_object_storage_bucket" "bucket" {
  label = "www.ch4z.io"
  cluster = "us-east-1"
}

resource "linode_object_storage_key" "key" {
  label = "www.ch4z.io"
}

resource "null_resource" "website_conf" {
  triggers = {
    bucket_id = linode_object_storage_bucket.bucket.id
    index_document = local.index_document
    error_document = local.error_document
  }

  provisioner "local-exec" {
    environment = {
      ACCESS_KEY = linode_object_storage_key.key.access_key
      SECRET_KEY = linode_object_storage_key.key.secret_key
    }

    command = "s3cmd ws-create ${join(" ", local.s3cmd_args)} --ws-index ${local.index_document} --ws-error ${local.error_document} s3://${linode_object_storage_bucket.bucket.label}"
  }
}

resource "linode_object_storage_object" "index" {
  for_each = fileset(path.module, "public/**/*")

  cluster = linode_object_storage_bucket.bucket.cluster
  bucket = linode_object_storage_bucket.bucket.label
  secret_key = linode_object_storage_key.key.secret_key
  access_key = linode_object_storage_key.key.access_key

  content_type = lookup(local.content_type, regex("\\.(\\w+)$", basename(each.value))[0], null)
  acl = "public-read"
  source = each.value
  key = replace(each.value, "public/", "")
  etag = md5(each.value)
}
