select
  -- Required Columns
  'acs:ram::' || a.account_id as resource,
  case
    when require_lowercase_characters then 'ok'
    else 'alarm'
  end as status,
  case
    when minimum_password_length is null then 'No password policy set.'
    when require_lowercase_characters then 'Lowercase password policy set.'
    else 'Lowercase password policy not set.'
  end as reason,
  -- Additional Dimensions
  a.account_id
from
  alicloud_account as a
  left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;