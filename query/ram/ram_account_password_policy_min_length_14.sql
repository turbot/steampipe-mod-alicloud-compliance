select
  -- Required Columns
  'acs:ram::' || a.account_id as resource,
  case
    when minimum_password_length >= 14 then 'ok'
    else 'alarm'
  end as status,
  case
    when minimum_password_length is null then 'No password policy set.'
    else 'Minimum password length set to ' || minimum_password_length || '.'
  end as reason,
  -- Additional Dimensions
  a.account_id
from
  alicloud_account as a
  left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;