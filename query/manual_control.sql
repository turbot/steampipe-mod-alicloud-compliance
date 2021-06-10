select
  -- Required Columns
  akas as resource,
  'info' as status,
  'Manual verification required.' as reason,
  -- Additional Dimensions
  account_id
from
 alicloud_account;
