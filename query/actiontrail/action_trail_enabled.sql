select
  -- Required Columns
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
      and sls_project_arn is not null then name ' is configured to export copies of all Log entries'
    else name ' is not configured to export copies of all Log entries'
  end as reason,
  -- Additional Dimensions
  home_region,
  account_id
from
  alicloud_action_trail;