select
  -- Required Columns
  'arn:acs:oss:::' || name as resource,
  case
    when acl = 'private' then 'ok'
    else 'alarm'
  end as status,
  case
    when acl = 'private' then title || ' blocks public access.'
    else name || ' does not blocks public access.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_oss_bucket;