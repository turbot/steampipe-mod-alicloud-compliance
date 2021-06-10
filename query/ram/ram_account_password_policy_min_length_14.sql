select
  -- Required Columns
  'acs:ram::' || account_id as resource,
  case
    when minimum_password_length >= 14 then 'ok'
    else 'alarm'
  end as status,
  case
    when minimum_password_length >= 14 then 'Minimum password length policy set to ' || minimum_password_length || '.'
    else 'Minimum password length policy not set.'
  end as "reason",
  -- Additional Dimensions
  account_id
from
  alicloud_ram_password_policy;