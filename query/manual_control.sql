select
  -- Required Columns
  'arn:acs:::' || account_id as resource,
  'info' as status,
  'Manual verification required.' as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_account;