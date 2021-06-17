select
  -- Required Columns
  'acs:oss:::' || name as resource,
  case
    when acl = 'private' then 'ok'
    else 'alarm'
  end as status,
  case
    when acl = 'private' then title || ' not publicly accessible.'
    else name || ' publicly accessible.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_oss_bucket;