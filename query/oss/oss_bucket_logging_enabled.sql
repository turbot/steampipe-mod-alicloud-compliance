select
  -- Required Columns
  'arn:acs:oss:::' || name as resource,
  case
    when logging ->> 'TargetBucket' <> '' then 'ok'
    else 'alarm'
  end as status,
  case
    when logging ->> 'TargetBucket' <> '' then title || ' logging enabled.'
    else title || ' logging not enabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_oss_bucket;