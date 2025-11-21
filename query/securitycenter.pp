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

query "security_center_all_assets_installed_with_agent" {
  sql = <<-EOQ
    select
      'acs:securitycenter:' || region || ':' || account_id || ':asset/' || coalesce(instance_id, uuid) as resource,
      case
        when client_status = 'online' then 'ok'
        else 'alarm'
      end as status,
      case
        when client_status = 'online' then 'Asset ' || uuid || ' has security center agent installed and online.'
        when client_status = 'offline' then 'Asset ' || uuid || ' has security center agent installed but is offline.'
        when client_status = 'uninstall' then 'Asset '|| uuid || ' does not have security center agent installed.'
        when client_status is null then 'Asset ' || uuid || ' security center agent status unknown.'
        else 'Asset ' ||  uuid || ' security center agent status: ' || client_status || '.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_security_center_asset;
  EOQ
}
