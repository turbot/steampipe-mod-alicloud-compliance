select
  -- Required Columns
  'acs:ram::' || account_id || ':user/' || user_name as resource,
  case
    when access_key_1_active and access_key_2_active then 'alarm'
    else 'ok'
  end as status,
  case
    when access_key_1_active and access_key_2_active then 'Access key exists.'
    else 'Access key not exists.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_credential_report
where
  user_name = '<root>';