select
  -- Required Columns
  'acs:ram::' || account_id || ':user/' || user_name as resource,
  case
    when mfa_active then 'ok'
    else 'alarm'
  end as status,
  case
    when mfa_active then user_name || ' MFA enabled.'
    else user_name || ' MFA not enabled.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_credential_report
where
  user_name = '<root>';