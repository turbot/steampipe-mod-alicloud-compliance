locals {
  cis_v200_5_common_tags = merge(local.cis_v200_common_tags, {
    cis_section_id = "5"
  })
}

benchmark "cis_v200_5" {
  title         = "5 Storage"
  documentation = file("./cis_v200/docs/cis_v200_5.md")
  children = [
    control.cis_v200_5_1,
    control.cis_v200_5_2,
    control.cis_v200_5_3,
    control.cis_v200_5_4,
    control.cis_v200_5_5,
    control.cis_v200_5_6,
    control.cis_v200_5_7,
    control.cis_v200_5_8,
    control.cis_v200_5_9
  ]

  tags = merge(local.cis_v200_5_common_tags, {
    service = "AliCloud/OSS"
    type    = "Benchmark"
  })
}

control "cis_v200_5_1" {
  title         = "5.1 Ensure that OSS bucket is not anonymously or publicly accessible"
  description   = "It is recommended that the access policy on OSS bucket does not allows anonymous and/or public access."
  query         = query.oss_bucket_public_access_blocked
  documentation = file("./cis_v200/docs/cis_v200_5_1.md")

  tags = merge(local.cis_v200_5_common_tags, {
    cis_item_id = "5.1"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/OSS"
  })
}

control "cis_v200_5_2" {
  title         = "5.2 Ensure that there are no publicly accessible objects in storage buckets"
  description   = "It is recommended that storage object ACL should not grant public access."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_5_2.md")

  tags = merge(local.cis_v200_5_common_tags, {
    cis_item_id = "5.2"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}

control "cis_v200_5_3" {
  title         = "5.3 Ensure that logging is enabled for OSS buckets"
  description   = "OSS Bucket Access Logging generates a log that contains access records for each request made to your OSS bucket. An access log record contains details about the request, such as the request type, the resources specified in the request worked, and the time and date the request was processed. It is recommended that bucket access logging be enabled on the OSS bucket."
  query         = query.oss_bucket_logging_enabled
  documentation = file("./cis_v200/docs/cis_v200_5_3.md")

  tags = merge(local.cis_v200_5_common_tags, {
    cis_item_id = "5.3"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/OSS"
  })
}

control "cis_v200_5_4" {
  title         = "5.4 Ensure that 'Secure transfer required' is set to 'Enabled'"
  description   = "Enable the data encryption in transit."
  query         = query.oss_bucket_enforces_ssl
  documentation = file("./cis_v200/docs/cis_v200_5_4.md")

  tags = merge(local.cis_v200_5_common_tags, {
    cis_item_id = "5.4"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/OSS"
  })
}

control "cis_v200_5_5" {
  title         = "5.5 Ensure that the shared URL signature expires within an hour"
  description   = "Expire the shared URL signature within an hour."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_5_5.md")

  tags = merge(local.cis_v200_5_common_tags, {
    cis_item_id = "5.5"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}

control "cis_v200_5_6" {
  title         = "5.6 Ensure that URL signature is allowed only over https"
  description   = "URL signature should be allowed only over HTTPS protocol."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_5_6.md")

  tags = merge(local.cis_v200_5_common_tags, {
    cis_item_id = "5.6"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}

control "cis_v200_5_7" {
  title         = "5.7 Ensure network access rule for storage bucket is not set to publicly accessible"
  description   = "Restricting default network access helps to provide a new layer of security, since OSS accept connections from clients on any network. To limit access to selected networks, the default action must be changed."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_5_7.md")

  tags = merge(local.cis_v200_5_common_tags, {
    cis_item_id = "5.2"
    cis_level   = "2"
    cis_type    = "automated"
    service     = "AliCloud/OSS"
  })
}

control "cis_v200_5_8" {
  title         = "5.8 Ensure server-side encryption is set to 'Encrypt with Service Key'"
  description   = "Enable server-side encryption (Encrypt with Service Key) for objects."
  query         = query.oss_bucket_encrypted_with_servcie_key
  documentation = file("./cis_v200/docs/cis_v200_5_8.md")

  tags = merge(local.cis_v200_5_common_tags, {
    cis_item_id = "5.8"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}

control "cis_v200_5_9" {
  title         = "5.9 Ensure server-side encryption is set to 'Encrypt with BYOK'"
  description   = "Enable server-side encryption (Encrypt with BYOK) for objects."
  query         = query.oss_bucket_encrypted_with_byok
  documentation = file("./cis_v200/docs/cis_v200_5_8.md")

  tags = merge(local.cis_v200_5_common_tags, {
    cis_item_id = "5.9"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}
