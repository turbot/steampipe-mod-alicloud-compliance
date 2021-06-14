locals {
  cis_v100_4_common_tags = merge(local.cis_v100_common_tags, {
    cis_section_id = "4"
  })
}

benchmark "cis_v100_4" {
  title         = "4 Virtual Machines"
  #documentation = file("./cis_v100/docs/cis_v100_4.md")
  children = [
    control.cis_v100_4_1,
    control.cis_v100_4_2,
    control.cis_v100_4_3,
    control.cis_v100_4_4,
    control.cis_v100_4_5,
    ]
  tags          = local.cis_v100_4_common_tags
}

control "cis_v100_4_1" {
  title         = "4.1 Ensure that 'Unattached disks' are encrypted"
  description   = "Ensure that unattached disks in a subscription are encrypted."
  sql           = query.ecs_unattached_disk_encryption_enabled.sql
  #documentation = file("./cis_v100/docs/cis_v100_4_1.md")

  tags = merge(local.cis_v100_4_common_tags, {
    cis_item_id = "4.1"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v100_4_2" {
  title         = "4.2 Ensure that ‘Virtual Machine’s disk’ are encrypted"
  description   = "Ensure that disk are encrypted when it is created with the creation of VM instance."
  sql           = query.ecs_disk_encryption_enabled.sql
  #documentation = file("./cis_v100/docs/cis_v100_4_2.md")

  tags = merge(local.cis_v100_4_common_tags, {
    cis_item_id = "4.2"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v100_4_3" {
  title         = "4.3 Ensure no security groups allow ingress from 0.0.0.0/0 to port 22"
  description   = "Security groups provide stateful filtering of ingress/egress network traffic to Alibaba Cloud resources. It is recommended that no security group allows unrestricted ingress access to port 22."
  sql           = query.ecs_security_group_restrict_ssh.sql
  #documentation = file("./cis_v100/docs/cis_v100_4_3.md")

  tags = merge(local.cis_v100_4_common_tags, {
    cis_item_id = "4.3"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v100_4_4" {
  title         = "4.4 Ensure no security groups allow ingress from 0.0.0.0/0 to port 3389"
  description   = "Security groups provide filtering of ingress/egress network traffic to Aliyun resources. It is recommended that no security group allows unrestricted ingress access to port 3389."
  sql           = query.ecs_security_group_restrict_rdp.sql
  #documentation = file("./cis_v100/docs/cis_v100_4_4.md")

  tags = merge(local.cis_v100_4_common_tags, {
    cis_item_id = "4.4"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v100_4_5" {
  title         = "4.5 Ensure that the latest OS Patches for all Virtual Machines are applied"
  description   = "Ensure that the latest OS patches for all virtual machines are applied."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_4_5.md")

  tags = merge(local.cis_v100_4_common_tags, {
    cis_item_id = "4.5"
    cis_level   = "1"
    cis_type    = "manual"
  })
}
