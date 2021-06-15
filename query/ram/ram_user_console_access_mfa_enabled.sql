select
  -- Required Columns
  'acs:ram::' || account_id || ':user/' || user_name as resource,
  case
    when password_exist and not mfa_active then 'alarm'
    else 'ok'
  end as status,
  case
    when not password_exist then user_name || ' password login disabled.'
    when password_exist and not mfa_active then user_name || ' password login enabled but no MFA device configured.'
    else user_name || ' password login enabled and MFA device configured.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_credential_report;