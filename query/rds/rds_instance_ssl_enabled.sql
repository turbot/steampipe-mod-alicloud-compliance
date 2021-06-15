select
  -- Required Columns
  arn as resource,
  case
    when ssl_status = 'Enabled' then 'ok'
    else 'alarm'
  end as status,
  case
    when ssl_status = 'Enabled' then title || ' SSL Enabled.'
    else title || ' SSL Disabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;