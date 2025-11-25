query "rds_instance_postgresql_log_connections_parameter_on" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when engine != 'PostgreSQL' then 'skip'
        when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_connections", "ParameterValue": "on"}]' then 'ok'
        else 'alarm'
      end as status,
      case
        when engine != 'PostgreSQL' then title || ' is ' || engine || ' server.'
        when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_connections", "ParameterValue": "on"}]' then title || ' ''log_connections'' parameter set to ''on''.'
        else title || ' ''log_connections'' parameter set to ''off''.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_rds_instance;
  EOQ
}

query "rds_instance_postgresql_log_disconnections_parameter_on" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when engine != 'PostgreSQL' then 'skip'
        when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_disconnections", "ParameterValue": "on"}]' then 'ok'
        else 'alarm'
      end as status,
      case
        when engine != 'PostgreSQL' then title || ' is ' || engine || ' server.'
        when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_disconnections", "ParameterValue": "on"}]' then title || ' ''log_disconnections'' parameter set to ''on''.'
        else title || ' ''log_disconnections'' parameter set to ''off''.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_rds_instance;
  EOQ
}

query "rds_instance_postgresql_log_duration_parameter_on" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when engine != 'PostgreSQL' then 'skip'
        when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_duration", "ParameterValue": "on"}]' then 'ok'
        else 'alarm'
      end as status,
      case
        when engine != 'PostgreSQL' then title || ' is ' || engine || ' server.'
        when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_duration", "ParameterValue": "on"}]' then title || ' ''log_duration'' parameter set to ''on''.'
        else title || ' ''log_duration'' parameter set to ''off''.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_rds_instance;
  EOQ
}

query "rds_instance_restrict_access_to_internet" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when security_ips :: jsonb ? '0.0.0.0/0' then 'alarm'
        else 'ok'
      end as status,
      case
        when security_ips :: jsonb ? '0.0.0.0/0' then title || ' publicly accessible.'
        else title || ' not publicly accessible.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_rds_instance;
  EOQ
}

query "rds_instance_sql_audit_enabled" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when sql_collector_policy ->> 'SQLCollectorStatus' = 'Enable' then 'ok'
        else 'alarm'
      end as status,
      case
        when sql_collector_policy ->> 'SQLCollectorStatus' = 'Enable' then title || ' SQL audit enabled.'
        else title || ' SQL audit disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_rds_instance;
  EOQ
}

query "rds_instance_sql_audit_retention_period_180_days" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when sql_collector_retention > 180 then 'ok'
        else 'alarm'
      end as status,
      title || ' SQL audit enabled with retention period ' || sql_collector_retention || ' days.'
      as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_rds_instance;
  EOQ
}

query "rds_instance_ssl_enabled" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when ssl_status = 'Enabled' then 'ok'
        else 'alarm'
      end as status,
      case
        when ssl_status = 'Enabled' then title || ' SSL enabled.'
        else title || ' SSL disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_rds_instance;
  EOQ
}

query "rds_instance_tde_enabled" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when tde_status = 'Enabled' then 'ok'
        else 'alarm'
      end as status,
      case
        when tde_status = 'Enabled' then title || ' TDE enabled.'
        else title || ' TDE disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_rds_instance;
  EOQ
}

query "rds_instance_tde_encrypted_with_byok" {
  sql = <<-EOQ
    select
      r.arn as resource,
      case
        when r.tde_status = 'Enabled' and r.tde_encryption_key is not null and k.key_id is not null and k.creator = k.account_id then 'ok'
        else 'alarm'
      end as status,
      case
        when r.tde_status != 'Enabled' then r.title || ' TDE is not enabled.'
        when r.tde_encryption_key is null then r.title || ' TDE enabled but not using a custom key (BYOK).'
        when k.key_id is null then r.title || ' TDE enabled with key ' || r.tde_encryption_key || ' but key not found in KMS. Verify the key exists and is accessible.'
        when k.creator is null or k.creator != k.account_id then r.title || ' TDE enabled but encryption key is not customer-managed (BYOK). Key creator: ' || coalesce(k.creator, 'unknown') || ', Account ID: ' || coalesce(k.account_id, 'unknown')
        when r.tde_status = 'Enabled' and r.tde_encryption_key is not null and k.creator = k.account_id then r.title || ' TDE enabled with BYOK (custom key ' || k.key_id || ').'
        else r.title || ' TDE not configured with BYOK.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
    from
      alicloud_rds_instance r
      left join alicloud_kms_key k on r.tde_encryption_key = k.key_id;
  EOQ
}
