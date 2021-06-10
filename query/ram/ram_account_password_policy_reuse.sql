select
  -- Required Columns
  'acs:ram::' || account_id as resource,
  case
    when password_reuse_prevention >= 5 then 'ok'
    else 'alarm'
  end as status,
  case
  when password_reuse_prevention >= 5 then 'reuse prevention policy set.'
  else 'reuse prevention not set.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_password_policy;