select
  -- Required Columns
  'acs:ram::' || account_id || ':user/' || name as resource,
  case
    when mfa_enabled then 'ok'
    else 'alarm'
  end as status,
  case
    when mfa_enabled then name || ' mfa enabled.'
    else name || ' mfa disabled.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_user;