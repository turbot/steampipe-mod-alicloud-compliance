select
  -- Required Columns
  'acs:ram::' || account_id || ':user/' || user_name as resource,
  case
    when user_last_logon is null then 'ok'
    else 'alarm'
  end as status,
  case
    when user_last_logon is null then 'Root account not used.'
    else 'Root account last used ' || extract(day from current_date - user_last_logon) || ' days ago.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_credential_report
where
  user_name = '<root>';