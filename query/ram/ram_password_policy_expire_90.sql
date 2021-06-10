select
  -- Required Columns
  'acs:ram::' || a.account_id as resource,
  case
    when max_password_age <= 90 then 'ok'
    else 'alarm'
  end as status,
  case
    when max_password_age is null then 'No Password expire policy set.'
    else 'Password expire policy set to ' || max_password_age || '.'
  end as reason,
  -- Additional Dimensions
  a.account_id
from
  alicloud_account as a
  left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;