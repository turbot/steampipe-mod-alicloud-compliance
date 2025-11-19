locals {
  cis_v200_4_common_tags = merge(local.cis_v200_common_tags, {
    cis_section_id = "4"
  })
}

benchmark "cis_v200_4" {
  title         = "4 Virtual Machines"
  documentation = file("./cis_v200/docs/cis_v200_4.md")
  children = [
    control.cis_v200_4_1,
    control.cis_v200_4_2,
    control.cis_v200_4_3,
    control.cis_v200_4_4,
    control.cis_v200_4_5,
    control.cis_v200_4_6,
  ]

  tags = merge(local.cis_v200_4_common_tags, {
    service = "AliCloud/ECS"
    type    = "Benchmark"
  })
}

control "cis_v200_4_1" {
  title         = "4.1 Ensure that 'Unattached disks' are encrypted"
  description   = "Ensure that unattached disks in a subscription are encrypted."
  query         = query.ecs_unattached_disk_encryption_enabled
  documentation = file("./cis_v200/docs/cis_v200_4_1.md")

  tags = merge(local.cis_v200_4_common_tags, {
    cis_item_id = "4.1"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/ECS"
  })
}

control "cis_v200_4_2" {
  title         = "4.2 Ensure that 'Virtual Machine’s disk' are encrypted"
  description   = "Ensure that disk are encrypted when it is created with the creation of VM instance."
  query         = query.ecs_disk_encryption_enabled
  documentation = file("./cis_v200/docs/cis_v200_4_2.md")

  tags = merge(local.cis_v200_4_common_tags, {
    cis_item_id = "4.2"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/ECS"
  })
}

control "cis_v200_4_3" {
  title         = "4.3 Ensure no security groups allow ingress from 0.0.0.0/0 to port 22"
  description   = "Security groups provide stateful filtering of ingress/egress network traffic to Alibaba Cloud resources. It is recommended that no security group allows unrestricted ingress access to port 22."
  query         = query.ecs_security_group_restrict_ingress_ssh_all
  documentation = file("./cis_v200/docs/cis_v200_4_3.md")

  tags = merge(local.cis_v200_4_common_tags, {
    cis_item_id = "4.3"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/ECS"
  })
}

control "cis_v200_4_4" {
  title         = "4.4 Ensure no security groups allow ingress from 0.0.0.0/0 to port 3389"
  description   = "Security groups provide filtering of ingress/egress network traffic to Aliyun resources. It is recommended that no security group allows unrestricted ingress access to port 3389."
  query         = query.ecs_security_group_restrict_ingress_rdp_all
  documentation = file("./cis_v200/docs/cis_v200_4_4.md")

  tags = merge(local.cis_v200_4_common_tags, {
    cis_item_id = "4.4"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/ECS"
  })
}

control "cis_v200_4_5" {
  title         = "4.5 Ensure that the latest OS Patches for all Virtual Machines are applied"
  description   = "Ensure that the latest OS patches for all virtual machines are applied."
  query         = query.ecs_instance_latest_os_patches_applied
  documentation = file("./cis_v200/docs/cis_v200_4_5.md")

  tags = merge(local.cis_v200_4_common_tags, {
    cis_item_id = "4.5"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/ECS"
  })
}

control "cis_v200_4_6" {
  title         = "4.6 Ensure that the endpoint protection for all Virtual Machines is installed"
  description   = "Ensure that endpoint protection (Security Center agent) is installed on all virtual machines."
  query         = query.ecs_security_center_agent_installed
  documentation = file("./cis_v200/docs/cis_v200_4_6.md")

  tags = merge(local.cis_v200_4_common_tags, {
    cis_item_id = "4.6"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/ECS"
  })
}
