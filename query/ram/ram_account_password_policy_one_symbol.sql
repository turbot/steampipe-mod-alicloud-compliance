select
  -- Required Columns
  'acs:ram::' || a.account_id as resource,
  case
    when require_symbols then 'ok'
    else 'alarm'
  end as status,
  case
    when minimum_password_length is null then 'No password policy set.'
    when require_symbols then 'Password policy for symbol set'
    else 'Password policy for symbol not set'
  end as reason,
  -- Additional Dimensions
  a.account_id
from
  alicloud_account as a
  left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;