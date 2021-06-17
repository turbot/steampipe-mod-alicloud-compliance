select
  -- Required Columns
  'acs' || ':actiontrail:' || trail.region || ':account_id' || ':actiontrail/' || trail.name as resource,
  case
    when bucket.acl <> 'private' then 'alarm'
    else 'ok'
  end as status,
  case
    when bucket.acl <> 'private' then 'oss bucket ' || bucket.name || ' used to store ActionTrail logs is publicly accessible.'
    else 'oss bucket ' || bucket.name || ' used to store ActionTrail logs is not publicly accessible.'
  end as reason,
  -- Additional Dimensions
  trail.region,
  trail.account_id
from
  alicloud_action_trail as trail
  join alicloud_oss_bucket as bucket on trail.oss_bucket_name = bucket.name;