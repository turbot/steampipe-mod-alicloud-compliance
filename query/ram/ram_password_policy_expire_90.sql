select
  -- Required Columns
  'acs:ram::' || account_id as resource,
  case
    when max_password_age <= 90 then 'ok'
    else 'alarm'
  end as status,
  case
    when max_password_age <= 90 then 'Expire password policy set to ' || max_password_age || '.'
    else 'Expire password policy not set.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_password_policy;