select
  -- Required Columns
  'acs:ram::' || account_id || ':user/' || user_name as resource,
  case
    when user_last_logon < current_date - interval '90 days' or user_last_logon is null then 'ok'
    else 'alarm'
  end as status,
  case
    when user_last_logon < current_date - interval '90 days' or user_last_logon is null then 'Root account not used.'
    else 'Root account used.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_credential_report
where
  user_name = '<root>';