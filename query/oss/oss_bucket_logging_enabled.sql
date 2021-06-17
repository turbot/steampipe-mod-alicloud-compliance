select
  -- Required Columns
  'acs:oss:::' || name as resource,
  case
    when logging ->> 'TargetBucket' <> '' then 'ok'
    else 'alarm'
  end as status,
  case
    when logging ->> 'TargetBucket' <> '' then title || ' logging enabled.'
    else title || ' logging disabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_oss_bucket;