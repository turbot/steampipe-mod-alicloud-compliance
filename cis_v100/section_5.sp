locals {
  cis_v100_5_common_tags = merge(local.cis_v100_common_tags, {
    cis_section_id = "5"
  })
}

benchmark "cis_v100_5" {
  title         = "5 Storage"
  documentation = file("./cis_v100/docs/cis_v100_5.md")
  children = [
    control.cis_v100_5_1,
    control.cis_v100_5_2,
    control.cis_v100_5_3,
    control.cis_v100_5_4,
    control.cis_v100_5_5,
    control.cis_v100_5_6,
    control.cis_v100_5_8,
    control.cis_v100_5_9,
  ]

  tags = merge(local.cis_v100_5_common_tags, {
    service = "AliCloud/OSS"
    type    = "Benchmark"
  })
}

control "cis_v100_5_1" {
  title         = "5.1 Ensure that OSS bucket is not anonymously or publicly accessible"
  description   = "It is recommended that the access policy on OSS bucket does not allows anonymous and/or public access."
  sql           = query.oss_bucket_public_access_blocked.sql
  documentation = file("./cis_v100/docs/cis_v100_5_1.md")

  tags = merge(local.cis_v100_5_common_tags, {
    cis_item_id = "5.1"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/OSS"
  })
}

control "cis_v100_5_2" {
  title         = "5.2 Ensure that there are no publicly accessible objects in storage buckets"
  description   = "It is recommended that storage object ACL should not grant public access."
  sql           = query.manual_control.sql
  documentation = file("./cis_v100/docs/cis_v100_5_2.md")

  tags = merge(local.cis_v100_5_common_tags, {
    cis_item_id = "5.2"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}

control "cis_v100_5_3" {
  title         = "5.3 Ensure that logging is enabled for OSS buckets"
  description   = "OSS Bucket Access Logging generates a log that contains access records for each request made to your OSS bucket. An access log record contains details about the request, such as the request type, the resources specified in the request worked, and the time and date the request was processed. It is recommended that bucket access logging be enabled on the OSS bucket."
  sql           = query.oss_bucket_logging_enabled.sql
  documentation = file("./cis_v100/docs/cis_v100_5_3.md")

  tags = merge(local.cis_v100_5_common_tags, {
    cis_item_id = "5.3"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/OSS"
  })
}

control "cis_v100_5_4" {
  title         = "5.4 Ensure that 'Secure transfer required' is set to 'Enabled'"
  description   = "Enable the data encryption in transit."
  sql           = query.oss_bucket_enforces_ssl.sql
  documentation = file("./cis_v100/docs/cis_v100_5_4.md")

  tags = merge(local.cis_v100_5_common_tags, {
    cis_item_id = "5.4"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/OSS"
  })
}

control "cis_v100_5_5" {
  title         = "5.5 Ensure that the shared URL signature expires within an hour"
  description   = "Expire the shared URL signature within an hour."
  sql           = query.manual_control.sql
  documentation = file("./cis_v100/docs/cis_v100_5_5.md")

  tags = merge(local.cis_v100_5_common_tags, {
    cis_item_id = "5.5"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}

control "cis_v100_5_6" {
  title         = "5.6 Ensure that URL signature is allowed only over https"
  description   = "URL signature should be allowed only over HTTPS protocol."
  sql           = query.manual_control.sql
  documentation = file("./cis_v100/docs/cis_v100_5_6.md")

  tags = merge(local.cis_v100_5_common_tags, {
    cis_item_id = "5.6"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}

control "cis_v100_5_8" {
  title         = "5.8 Ensure server-side encryption is set to 'Encrypt with Service Key'"
  description   = "Enable server-side encryption (Encrypt with Service Key) for objects."
  sql           = query.oss_bucket_encrypted_with_servcie_key.sql
  documentation = file("./cis_v100/docs/cis_v100_5_8.md")

  tags = merge(local.cis_v100_5_common_tags, {
    cis_item_id = "5.8"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}

control "cis_v100_5_9" {
  title         = "5.9 Ensure server-side encryption is set to 'Encrypt with BYOK'"
  description   = "Enable server-side encryption (Encrypt with BYOK) for objects."
  sql           = query.oss_bucket_encrypted_with_byok.sql
  documentation = file("./cis_v100/docs/cis_v100_5_8.md")

  tags = merge(local.cis_v100_5_common_tags, {
    cis_item_id = "5.9"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/OSS"
  })
}
