select
  -- Required Columns
  arn as resource,
  case
    when tde_status = 'Enabled' then 'ok'
    else 'alarm'
  end as status,
  case
    when tde_status = 'Enabled' then title || ' TDE enabled.'
    else title || ' TDE disabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;