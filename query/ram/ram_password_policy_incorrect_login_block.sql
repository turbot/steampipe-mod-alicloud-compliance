select
  -- Required Columns
  'acs:ram::' || account_id as resource,
  case
    when max_login_attempts = 5 then 'ok'
    else 'alarm'
  end as status,
  case
    when max_login_attempts = 5 then 'Max login attempts set to ' || max_login_attempts || '.'
    else 'Max login attempts ' || max_login_attempts || '.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_password_policy;
