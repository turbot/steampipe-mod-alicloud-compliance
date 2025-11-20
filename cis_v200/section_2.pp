locals {
  cis_v200_2_common_tags = merge(local.cis_v200_common_tags, {
    cis_section_id = "2"
  })
}

benchmark "cis_v200_2" {
  title         = "2 Logging and Monitoring"
  documentation = file("./cis_v200/docs/cis_v200_2.md")
  children = [
    control.cis_v200_2_1,
    control.cis_v200_2_2,
    control.cis_v200_2_3,
    control.cis_v200_2_4,
    control.cis_v200_2_5,
    control.cis_v200_2_6,
    control.cis_v200_2_7,
    control.cis_v200_2_8,
    control.cis_v200_2_9,
    control.cis_v200_2_10,
    control.cis_v200_2_11,
    control.cis_v200_2_12,
    control.cis_v200_2_13,
    control.cis_v200_2_14,
    control.cis_v200_2_15,
    control.cis_v200_2_16,
    control.cis_v200_2_17,
    control.cis_v200_2_18,
    control.cis_v200_2_19,
    control.cis_v200_2_20,
    control.cis_v200_2_21,
    control.cis_v200_2_22,
    control.cis_v200_2_23
  ]

  tags = merge(local.cis_v200_2_common_tags, {
    type = "Benchmark"
  })
}

control "cis_v200_2_1" {
  title         = "2.1 Ensure that ActionTrail are configured to export copies of all Log entries"
  description   = "ActionTrail is a web service that records API calls for your account and delivers log files to you. The recorded information includes the identity of the API caller, the time of the API call, the source IP address of the API caller, the request parameters, and the response elements returned by the Alibaba Cloud service. ActionTrail provides a history of API calls for an account, including API calls made via the Management Console, SDKs, command line tools."
  query         = query.action_trail_enabled
  documentation = file("./cis_v200/docs/cis_v200_2_1.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.1"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/ActionTrail"
  })
}

control "cis_v200_2_2" {
  title         = "2.2 Ensure the OSS used to store ActionTrail logs is not publicly accessible"
  description   = "ActionTrail logs a record of every API call made in your Alibaba Cloud account. These logs file are stored in an OSS bucket. It is recommended that the access control list (ACL) of the OSS bucket, which ActionTrail logs to, shall prevent public access to the ActionTrail logs."
  query         = query.action_trail_oss_bucket_not_public
  documentation = file("./cis_v200/docs/cis_v200_2_2.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.2"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/ActionTrail"
  })
}

control "cis_v200_2_3" {
  title         = "2.3 Ensure audit logs for multiple cloud resources are integrated with Log Service"
  description   = "Log Service provides functions of log collection and analysis in real time across multiple cloud resources under the authorized resource owners. This enable the large-scale corporate for security governance over all resources owned by multiple accounts by integrating the log from different sources and monitoring."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_2_3.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.3"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_4" {
  title         = "2.4 Ensure Log Service is enabled for Container Service for Kubernetes"
  description   = "Log Service shall be connected with Kubernetes clusters of Alibaba Cloud Container Service to collect the audit log for central monitoring and analysis. You can simply enable Log Service when creating a cluster for log collection."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_2_4.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.4"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_5" {
  title         = "2.5 Ensure virtual network flow log service is enabled"
  description   = "The flow log can be used to capture the traffic of an Elastic Network Interface (ENI), Virtual Private Cloud (VPC) or Virtual Switch (VSwitch). The flow log of a VPC or VSwitch shall be integrated with Log Service to capture the traffic of all ENIs in the VPC or VSwtich including the ENIs created after the flow log function is enabled. The traffic data captured by flow logs is stored in Log Service for real-time monitoring and analysis. A capture window is about 10 minutes, during which the traffic data is aggregated and then released to flow log record."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_2_5.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.5"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/VPC"
  })
}

control "cis_v200_2_6" {
  title         = "2.6 Ensure Anti-DDoS access and security log service is enabled"
  description   = "Alibaba Cloud Anti-DDoS Pro supports integration with Log Service for website access log (including HTTP flood attack logs) to enable the real-time analysis and reporting center features. The log collected can be monitored on a central dashboard on Log Service."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_2_6.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.6"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/AntiDDoS"
  })
}

control "cis_v200_2_7" {
  title         = "2.7 Ensure Web Application Firewall access and security log service is enabled"
  description   = "Log Service collects log entries that record visits to and attacks on websites that are protected by Alibaba Cloud Web Application Firewall (WAF), and supports real-time log query and analysis. The query results are centrally displayed in dashboards."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_2_7.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.7"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/WAF"
  })
}

control "cis_v200_2_8" {
  title         = "2.8 Ensure Cloud Firewall access and security log analysis is enabled"
  description   = "Log Service collects log entries of internet traffic that are protected by Cloud Firewall, and supports real-time log query and analysis. The query results are centrally displayed in dashboards."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_2_8.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.8"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/CloudFirewall"
  })
}

control "cis_v200_2_9" {
  title         = "2.9 Ensure Security Center Network, Host and Security log analysis is enabled"
  description   = "Log Service collects log entries of Security Center for security logs, network logs, and host logs, with 14 subtypes."
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_2_9.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.9"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/SecurityCenter"
  })
}

control "cis_v200_2_10" {
  title         = "2.10 Ensure log monitoring and alerts are set up for RAM Role changes"
  description   = "It is recommended that a query and alarm should be established for RAM Role creation, deletion and updating activities."
  query         = query.sls_alert_ram_role_changes
  documentation = file("./cis_v200/docs/cis_v200_2_10.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.10"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_11" {
  title         = "2.11 Ensure log monitoring and alerts are set up for Cloud Firewall changes"
  description   = "It is recommended that a metric filter and alarm be established for Cloud Firewall rule changes."
  query         = query.sls_alert_cloud_firewall_changes
  documentation = file("./cis_v200/docs/cis_v200_2_11.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.11"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_12" {
  title         = "2.12 Ensure log monitoring and alerts are set up for VPC network route changes"
  description   = "It is recommended that a metric filter and alarm be established for VPC network route changes."
  query         = query.sls_alert_vpc_route_changes
  documentation = file("./cis_v200/docs/cis_v200_2_12.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.12"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_13" {
  title         = "2.13 Ensure log monitoring and alerts are set up for VPC changes"
  description   = "It is recommended that a log search/analysis query and alarm be established for VPC changes."
  query         = query.sls_alert_vpc_changes
  documentation = file("./cis_v200/docs/cis_v200_2_13.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.13"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_14" {
  title         = "2.14 Ensure log monitoring and alerts are set up for OSS permission changes"
  description   = "It is recommended that a metric filter and alarm be established for OSS Bucket RAM changes."
  query         = query.sls_alert_oss_permission_changes
  documentation = file("./cis_v200/docs/cis_v200_2_14.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.14"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_15" {
  title         = "2.15 Ensure log monitoring and alerts are set up for RDS instance configuration changes"
  description   = "It is recommended that a metric filter and alarm be established for RDS Instance configuration changes."
  query         = query.sls_alert_rds_configuration_changes
  documentation = file("./cis_v200/docs/cis_v200_2_15.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.15"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_16" {
  title         = "2.16 Ensure a log monitoring and alerts are set up for unauthorized API calls"
  description   = "Real-time monitoring of API calls can be achieved by directing ActionTrail Logs to LogService and establishing corresponding query and alarms. It is recommended that a query and alarm be established for unauthorized API calls."
  query         = query.sls_alert_unauthorized_api_calls
  documentation = file("./cis_v200/docs/cis_v200_2_16.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.16"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_17" {
  title         = "2.17 Ensure a log monitoring and alerts are set up for Management Console sign-in without MFA"
  description   = "Real-time monitoring of API calls can be achieved by directing ActionTrail Logs to Log Service and establishing corresponding query and alarms. It is recommended that a query and alarm be established for console logins that are not protected by multi-factor authentication (MFA)."
  query         = query.sls_alert_console_signin_without_mfa
  documentation = file("./cis_v200/docs/cis_v200_2_17.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.17"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_18" {
  title         = "2.18 Ensure a log monitoring and alerts are set up for usage of 'root' account"
  description   = "Real-time monitoring of API calls can be achieved by directing ActionTrail Logs to Log Service and establishing corresponding query and alarms. It is recommended that a query and alarm be established for console logins that are not protected by root login attempts."
  query         = query.sls_alert_root_account_usage
  documentation = file("./cis_v200/docs/cis_v200_2_18.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.18"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_19" {
  title         = "2.19 Ensure a log monitoring and alerts are set up for Management Console authentication failures"
  description   = "Real-time monitoring of API calls can be achieved by directing ActionTrail Logs to Log Service and establishing corresponding query and alarms. It is recommended that a query and alarm be established for failed console authentication attempts."
  query         = query.sls_alert_console_authentication_failures
  documentation = file("./cis_v200/docs/cis_v200_2_19.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.19"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_20" {
  title         = "2.20 Ensure a log monitoring and alerts are set up for disabling or deletion of customer created CMKs"
  description   = "Real-time monitoring of API calls can be achieved by directing ActionTrail Logs to Log Service and establishing corresponding query and alarms. It is recommended that a query and alarm be established for customer created KMSs which have changed state to disabled or deletion."
  query         = query.sls_alert_kms_key_disable_deletion
  documentation = file("./cis_v200/docs/cis_v200_2_20.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.20"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_21" {
  title         = "2.21 Ensure a log monitoring and alerts are set up for OSS bucket policy changes"
  description   = "Real-time monitoring of API calls can be achieved by directing ActionTrail Logs to Log Service and establishing corresponding query and alarms. It is recommended that a query and alarm be established for changes to OSS bucket policies."
  query         = query.sls_alert_oss_bucket_policy_changes
  documentation = file("./cis_v200/docs/cis_v200_2_21.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.21"
    cis_level   = "1"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_22" {
  title         = "2.22 Ensure a log monitoring and alerts are set up for security group changes"
  description   = "Real-time monitoring of API calls can be achieved by directing ActionTrail Logs to Log Service and establishing corresponding query and alarms. Security Groups are a stateful packet filter that controls ingress and egress traffic within a VPC. It is recommended that query and alarm be established changes to Security Groups."
  query         = query.sls_alert_security_group_changes
  documentation = file("./cis_v200/docs/cis_v200_2_22.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.22"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}

control "cis_v200_2_23" {
  title         = "2.23 Ensure that Logstore data retention period is set 365 days or greater"
  description   = "Ensure Activity Log Retention is set for 365 days or greater"
  query         = query.manual_control
  documentation = file("./cis_v200/docs/cis_v200_2_22.md")

  tags = merge(local.cis_v200_2_common_tags, {
    cis_item_id = "2.23"
    cis_level   = "2"
    cis_type    = "manual"
    service     = "AliCloud/SLS"
  })
}
