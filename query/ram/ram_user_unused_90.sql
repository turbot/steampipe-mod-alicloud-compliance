select
  -- Required Columns
  'acs:ram::' || account_id || ':user/' || name as resource,
  case
    when last_login_date < current_date - interval '90 days' or last_login_date is null then 'alarm'
    else 'ok'
  end as status,
  case
    when last_login_date < current_date - interval '90 days' or last_login_date is null then name || ' not logged on for 90 days.'
    else name || ' logged on within 90 days.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_user;