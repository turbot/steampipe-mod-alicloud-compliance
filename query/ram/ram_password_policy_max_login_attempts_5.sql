select
  -- Required Columns
  'acs:ram::' || a.account_id as resource,
  case
    when max_login_attempts <= 5 then 'ok'
    else 'alarm'
  end as status,
  case
    when max_login_attempts is null then 'Max login attempts not set.'
    else 'Max login attempts set to ' || max_login_attempts || '.'
  end as reason,
  -- Additional Dimensions
  a.account_id
from
  alicloud_account as a
  left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
