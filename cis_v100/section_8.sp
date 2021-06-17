locals {
  cis_v100_8_common_tags = merge(local.cis_v100_common_tags, {
    cis_section_id = "8"
  })
}

benchmark "cis_v100_8" {
  title         = "8 Security Center"
  #documentation = file("./cis_v100/docs/cis_v100_8.md")
  children = [
    control.cis_v100_8_1,
    control.cis_v100_8_3,
    control.cis_v100_8_4,
    control.cis_v100_8_5,
    control.cis_v100_8_6,
    control.cis_v100_8_7,
    control.cis_v100_8_8,
    ]
  tags          = local.cis_v100_8_common_tags
}

control "cis_v100_8_1" {
  title         = "8.1 Ensure that Security Center is Advanced or Enterprise Edition"
  description   = "The Advanced or Enterprise Edition enables threat detection for network and endpoints, providing malware detection, webshell detection and anomaly detection in Security Center."
  sql           = query.security_center_advanced_or_enterprise_edition.sql
  #documentation = file("./cis_v100/docs/cis_v100_8_1.md")

  tags = merge(local.cis_v100_8_common_tags, {
    cis_item_id = "8.1"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "cis_v100_8_3" {
  title         = "8.3 Ensure that Automatic Quarantine is enabled"
  description   = "Enable automatic quarantine of virus protection in Security Center."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_8_3.md")

  tags = merge(local.cis_v100_8_common_tags, {
    cis_item_id = "8.3"
    cis_level   = "2"
    cis_type    = "manual"
  })
}

control "cis_v100_8_4" {
  title         = "8.4 Ensure that Webshell detection is enabled on all web servers"
  description   = "Enable webshell detection on all web servers to scans periodically the Web directories for detecting webshells on servers."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_8_4.md")

  tags = merge(local.cis_v100_8_common_tags, {
    cis_item_id = "8.4"
    cis_level   = "2"
    cis_type    = "manual"
  })
}

control "cis_v100_8_5" {
  title         = "8.5 Ensure that notification is enabled on all high risk items"
  description   = "Enable all risk item notification in Vulnerability, Baseline Risks, Alerts and Accesskey Leak event detection categories."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_8_5.md")

  tags = merge(local.cis_v100_8_common_tags, {
    cis_item_id = "8.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_8_6" {
  title         = "8.6 Ensure that Config Assessment is granted with privilege"
  description   = "Grant Security Center’s Cloud Platform Configuration Assessment the privilege to access other cloud product."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_8_6.md")

  tags = merge(local.cis_v100_8_common_tags, {
    cis_item_id = "8.6"
    cis_level   = "2"
    cis_type    = "manual"
  })
}

control "cis_v100_8_7" {
  title         = "8.7 Ensure that scheduled vulnerability scan is enabled on all servers"
  description   = "Ensure that scheduled vulnerability scan is enabled on all servers."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_8_7.md")

  tags = merge(local.cis_v100_8_common_tags, {
    cis_item_id = "8.7"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "cis_v100_8_8" {
  title         = "8.8 Ensure that Asset Fingerprint automatically collects asset fingerprint data"
  description   = "The Enterprise Edition enables asset fingerprint collection for endpoints providing a collection of port, software, processes, scheduled tasks and middleware in Security Center."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_8_8.md")

  tags = merge(local.cis_v100_8_common_tags, {
    cis_item_id = "8.8"
    cis_level   = "2"
    cis_type    = "manual"
  })
}