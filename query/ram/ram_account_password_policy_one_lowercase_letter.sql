select
  -- Required Columns
  'acs:ram::' || account_id as resource,
  case
    when require_lowercase_characters then 'ok'
    else 'alarm'
  end as status,
  case
    when require_lowercase_characters then 'Lowercase policy set.'
    else 'Lowercase policy not set.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_password_policy;