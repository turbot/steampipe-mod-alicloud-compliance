select
  -- Required Columns
  arn as resource,
  case
    when tde_status = 'Enabled' then 'ok'
    else 'alarm'
  end as status,
  case
    when tde_status = 'Enabled' then title || ' TDE Enabled.'
    else db_instance_id || ' TDE not enabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;