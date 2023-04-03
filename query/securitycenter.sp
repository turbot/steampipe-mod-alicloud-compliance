query "security_center_advanced_or_enterprise_edition" {
  sql = <<-EOQ
    select
      account_id as resource,
      case
        when version in ('2', '3', '5') then 'ok'
        else 'alarm'
      end as status,
      case
        when version in ('2','3') then 'Security Center Enterprise edition enabled.'
        when version in ('5') then 'Security Center Advanced edition enabled.'
        else 'Security Center Enterprise or Advanced edition disabled.'
      end as reason
      ${local.common_dimensions_sql}
    from
      alicloud_security_center_version;
  EOQ
}