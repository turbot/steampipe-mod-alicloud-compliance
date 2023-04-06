query "action_trail_enabled" {
  sql = <<-EOQ
    select
      'acs:actiontrail:' || home_region || ':' || account_id || ':actiontrail/' || name as resource,
      case
        when
          trail_region = 'All'
          and oss_bucket_name is not null
          and sls_project_arn is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when
          trail_region = 'All'
          and oss_bucket_name is not null
          and sls_project_arn is not null then name ' is configured to export copies of all log entries'
        else name ' is not configured to export copies of all log entries'
      end as reason
      ${local.common_dimensions_sql}
    from
      alicloud_action_trail;
  EOQ
}

query "action_trail_oss_bucket_not_public" {
  sql = <<-EOQ
    select
      'acs' || ':actiontrail:' || trail.region || ':account_id' || ':actiontrail/' || trail.name as resource,
      case
        when bucket.acl <> 'private' then 'alarm'
        else 'ok'
      end as status,
      case
        when bucket.acl <> 'private' then 'oss bucket ' || bucket.name || ' used to store ActionTrail logs is publicly accessible.'
        else 'oss bucket ' || bucket.name || ' used to store ActionTrail logs is not publicly accessible.'
      end as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "trail.")}
    from
      alicloud_action_trail as trail
      join alicloud_oss_bucket as bucket on trail.oss_bucket_name = bucket.name;
  EOQ
}
