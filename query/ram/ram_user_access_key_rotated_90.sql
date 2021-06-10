select
  -- Required Columns
  'acs:ram::' || account_id || ':user/' || user_name as resource,
  case
    when user_name = '<root>' then 'skip'
    when password_last_changed < current_date - interval '90 days' and password_exist then 'alarm'
    else 'ok'
  end as status,
  case
    when user_name = '<root>' then ' skipped for root user.'
    when password_last_changed < current_date - interval '90 days' and password_exist then  'Password not updated as recommended.'
    else 'Password updated as recommended.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_credential_report;