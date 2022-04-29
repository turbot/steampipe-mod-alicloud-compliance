locals {
  cis_v100_3_common_tags = merge(local.cis_v100_common_tags, {
    cis_section_id = "3"
  })
}

benchmark "cis_v100_3" {
  title         = "3 Networking"
  documentation = file("./cis_v100/docs/cis_v100_3.md")
  children = [
    control.cis_v100_3_1,
    control.cis_v100_3_2,
    control.cis_v100_3_3,
    control.cis_v100_3_4,
    control.cis_v100_3_5,
    ]

  tags = merge(local.cis_v100_3_common_tags, {
    type = "Benchmark"
  })
}

control "cis_v100_3_1" {
  title         = "3.1 Ensure legacy networks does not exist"
  description   = "In order to prevent use of legacy networks, ECS instances should not have a legacy network configured."
  sql           = query.ecs_instance_with_no_legacy_network.sql
  documentation = file("./cis_v100/docs/cis_v100_3_1.md")

  tags = merge(local.cis_v100_3_common_tags, {
    cis_item_id = "3.1"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/ECS"
  })
}

control "cis_v100_3_2" {
  title         = "3.2 Ensure that SSH access is restricted from the internet"
  description   = "Security groups provide stateful filtering of ingress/egress network traffic to Alibaba Cloud resources. It is recommended that no security group allows unrestricted ingress access to port 22 or port 3389."
  sql           = query.ecs_security_group_remote_administration.sql
  documentation = file("./cis_v100/docs/cis_v100_3_2.md")

  tags = merge(local.cis_v100_3_common_tags, {
    cis_item_id = "3.2"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/ECS"
  })
}

control "cis_v100_3_3" {
  title         = "3.3 Ensure VPC flow logging is enabled in all VPCs"
  description   = "You can use the flow log function to monitor the IP traffic information for an ENI, a VSwitch or a VPC. If you create a flow log for a VSwitch or a VPC, all the Elastic Network Interfaces, including the newly created Elastic Network Interfaces, are monitored. Such flow log data is stored in Log Service, where you can view and analyze IP traffic information. It is recommended that VPC Flow Logs be enabled for packet 'Rejects' for VPCs."
  sql           = query.manual_control.sql
  documentation = file("./cis_v100/docs/cis_v100_3_3.md")

  tags = merge(local.cis_v100_3_common_tags, {
    cis_item_id = "3.3"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/VPC"
  })
}

control "cis_v100_3_4" {
  title         = "3.4 Ensure routing tables for VPC peering are 'least access'"
  description   = "Once a VPC peering connection is established, routing tables must be updated to establish any connections between the peered VPCs. These routes can be as specific as desired, even peering a VPC to only a single host on the other side of the connection."
  sql           = query.manual_control.sql
  documentation = file("./cis_v100/docs/cis_v100_3_4.md")

  tags = merge(local.cis_v100_3_common_tags, {
    cis_item_id = "3.4"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/VPC"
  })
}

control "cis_v100_3_5" {
  title         = "3.5 Ensure the security group are configured with fine grained rules"
  description   = "Security groups provide stateful filtering of ingress/egress network traffic to Alibaba Cloud resources. It is recommended that all security group configured with fine grained rules."
  sql           = query.manual_control.sql
  documentation = file("./cis_v100/docs/cis_v100_3_5.md")

  tags = merge(local.cis_v100_3_common_tags, {
    cis_item_id = "3.5"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/ECS"
  })
}
