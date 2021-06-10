select
  -- Required Columns
  'acs:ram::' || a.account_id as resource,
  case
    when password_reuse_prevention >= 5 then 'ok'
    else 'alarm'
  end as status,
  case
    when minimum_password_length is null then 'No password policy set.'
    when password_reuse_prevention is null then 'Password reuse prevention not set.'
    else 'Password reuse prevention policy set to ' || password_reuse_prevention || '.'
  end as reason,
  -- Additional Dimensions
  a.account_id
from
  alicloud_account as a
  left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;