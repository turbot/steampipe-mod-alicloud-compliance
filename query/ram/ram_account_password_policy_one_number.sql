select
  -- Required Columns
  'acs:ram::' || a.account_id as resource,
  case
    when require_numbers then 'ok'
    else 'alarm'
  end as status,
  case
    when minimum_password_length is null then 'No password policy set.'
    when require_numbers then 'Password policy for number set.'
    else 'Password policy for number not set.'
  end as reason,
  -- Additional Dimensions
  a.account_id
from
  alicloud_account as a
  left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;