select
  -- Required Columns
  'acs:ram::' || account_id as resource,
  case
    when require_symbols then 'ok'
    else 'alarm'
  end as status,
  case
    when require_symbols then 'Symbol policy set.'
    else 'symbol policy not set.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_password_policy;