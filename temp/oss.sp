query "oss_bucket_encrypted_with_byok" {
  sql = <<-EOQ
    select
      'acs:oss:::' || b.name as resource,
      case
        when server_side_encryption ->> 'SSEAlgorithm' = 'KMS' and k.creator = k.account_id then 'ok'
        else 'alarm'
      end as status,
      case
        when server_side_encryption ->> 'SSEAlgorithm' = 'KMS' and k.creator = k.account_id then b.title || ' encrypted with BYOK.'
        else b.title || ' not encrypted with BYOK.'
      end as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "b.")}
    from
      alicloud_oss_bucket b
      left join alicloud_kms_key k on b.server_side_encryption ->> 'KMSMasterKeyID' = k.key_id;
  EOQ
}

query "oss_bucket_encrypted_with_servcie_key" {
  sql = <<-EOQ
    select
      'acs:oss:::' || b.name as resource,
      case
        when server_side_encryption ->> 'SSEAlgorithm' = 'KMS' and k.creator = 'Oss' then 'ok'
        else 'alarm'
      end as status,
      case
        when server_side_encryption ->> 'SSEAlgorithm' = 'KMS' and k.creator = 'Oss' then b.title || ' encrypted with Service Key.'
        else b.title || ' not encrypted with Service Key.'
      end as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "b.")}
    from
      alicloud_oss_bucket b
      left join alicloud_kms_key k on b.server_side_encryption ->> 'KMSMasterKeyID' = k.key_id;
  EOQ
}

query "oss_bucket_enforces_ssl" {
  sql = <<-EOQ
    with ssl_ok as (
      select
        distinct name,
        'ok' as status
      from
        alicloud_oss_bucket,
        jsonb_array_elements(policy -> 'Statement') as s,
        jsonb_array_elements_text(s -> 'Principal') as p,
        jsonb_array_elements_text(s -> 'Resource') as r,
        jsonb_array_elements_text(
          s -> 'Condition' -> 'Bool' -> 'acs:SecureTransport'
        ) as ssl
      where
        p = '*'
        and s ->> 'Effect' = 'Deny'
        and ssl :: bool = false
    )
    select
      'acs:oss:::' || b.name as resource,
      case
        when ok.status = 'ok' then 'ok'
        else 'alarm'
      end status,
      case
        when ok.status = 'ok' then b.title || ' bucket policy enforces HTTPS.'
        else b.title || ' bucket policy does not enforce HTTPS.'
      end reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "b.")}
    from
      alicloud_oss_bucket as b
      left join ssl_ok as ok on ok.name = b.name;
  EOQ
}

query "oss_bucket_logging_enabled" {
  sql = <<-EOQ
    select
      'acs:oss:::' || name as resource,
      case
        when logging ->> 'TargetBucket' <> '' then 'ok'
        else 'alarm'
      end as status,
      case
        when logging ->> 'TargetBucket' <> '' then title || ' logging enabled.'
        else title || ' logging disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_oss_bucket;
  EOQ
}

query "oss_bucket_public_access_blocked" {
  sql = <<-EOQ
    select
      'acs:oss:::' || name as resource,
      case
        when acl = 'private' then 'ok'
        else 'alarm'
      end as status,
      case
        when acl = 'private' then title || ' not publicly accessible.'
        else name || ' publicly accessible.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_oss_bucket;
  EOQ
}